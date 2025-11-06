-- =============================================
-- Author:Shankha Roy
-- Create date: 12/06/2007
-- Description:	Search a Complaint for Escalation
-- =============================================

CREATE PROCEDURE [CUSTOMERCARE].[uspGetEscalateComplaint]
(
@iConfigDateDiff	INT,
@iAssignStatus INT,
@iResolveStatus INT,
@iEscalateLevel INT = null
)
AS
BEGIN

DECLARE @temComplaint TABLE
(
I_Complaint_ID INT
)
DECLARE @temNotResolveComplaint TABLE
(
I_Complaint_ID INT
)
DECLARE @temComplaintAssign TABLE
(
I_Complaint_Req_ID INT,
I_Current_Escalation_level INT,
I_Status_ID INT,
I_User_ID INT,
Dt_Upd_On DATETIME )

-- Insert from Complaint table
INSERT INTO @temComplaint
SELECT I_Complaint_Req_ID FROM CUSTOMERCARE.T_Complaint_Request_Detail
WHERE  I_Status_ID = @iAssignStatus

-- Insert from Complaint Histrory Table 
INSERT INTO @temComplaint
SELECT I_Complaint_Req_ID FROM CUSTOMERCARE.T_Complaint_Audit_Trail
WHERE  I_Status_ID = @iAssignStatus


-- Select complaint ID which are not resolved
INSERT INTO @temNotResolveComplaint
SELECT DISTINCT(I_Complaint_Req_ID) FROM CUSTOMERCARE.T_Complaint_Audit_Trail
WHERE I_Complaint_Req_ID IN (SELECT I_Complaint_ID FROM @temComplaint)
AND I_Complaint_Req_ID NOT IN (
SELECT DISTINCT(I_Complaint_Req_ID) FROM CUSTOMERCARE.T_Complaint_Audit_Trail
WHERE I_Status_ID = @iResolveStatus )
AND I_Complaint_Req_ID NOT IN (
SELECT DISTINCT(I_Complaint_Req_ID) FROM CUSTOMERCARE.T_Complaint_Request_Detail
WHERE I_Status_ID = @iResolveStatus )


			INSERT INTO @temComplaintAssign
			SELECT 
			CRD.I_Complaint_Req_ID AS I_Complaint_Req_ID,			
			ISNULL(CRD.I_Current_Escalation_level,0) AS I_Current_Escalation_level, 
			ISNULL(CRD.I_Status_ID, 0) as I_Status_ID,
			ISNULL(CRD.I_User_ID,0) AS  I_User_ID,
			CRD.Dt_Upd_On AS Dt_Upd_On					
			FROM		     
			CUSTOMERCARE.T_Complaint_Request_Detail CRD 			
			WHERE CRD.I_Complaint_Req_ID IN(SELECT I_Complaint_ID FROM @temNotResolveComplaint)
			AND CRD.I_Status_ID = @iAssignStatus

			INSERT INTO @temComplaintAssign
			SELECT 
			CAT.I_Complaint_Req_ID AS I_Complaint_Req_ID,			
			ISNULL(CAT.I_Current_Escalation_level,0) AS I_Current_Escalation_level, 
			ISNULL(CAT.I_Status_ID, 0) as I_Status_ID,
			ISNULL(CAT.I_User_ID,0) AS  I_User_ID,
			CAT.Dt_Upd_On AS Dt_Upd_On					
			FROM		     
			CUSTOMERCARE.T_Complaint_Audit_Trail CAT 			
			WHERE CAT.I_Complaint_Req_ID IN(SELECT I_Complaint_ID FROM @temNotResolveComplaint)
			AND CAT.I_Status_ID = @iAssignStatus

			SELECT 
			I_Complaint_Req_ID ,		
			ISNULL(I_Current_Escalation_level,0) AS I_Current_Escalation_level, 
			ISNULL(I_Status_ID, 0) as I_Status_ID,
			ISNULL(I_User_ID,0) AS  I_User_ID,
			Dt_Upd_On ,
			DATEDIFF(day,Dt_Upd_On,GETDATE()) as DATE		
			FROM		     
			@temComplaintAssign		
			WHERE DATEDIFF(day,Dt_Upd_On,GETDATE()) > @iConfigDateDiff 
			AND I_Current_Escalation_level <= @iEscalateLevel	

END
