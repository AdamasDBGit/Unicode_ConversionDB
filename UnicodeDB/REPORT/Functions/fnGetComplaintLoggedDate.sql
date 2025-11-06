-- ============================================================
-- Author:		SHANKHA ROY
-- Create date: '28/01/2008'
-- Description:	This Function return Logged date of complaints
-- ============================================================
CREATE FUNCTION [REPORT].[fnGetComplaintLoggedDate]
(
@iComplaintID INT 
)
RETURNS  DATETIME

AS
BEGIN

	DECLARE @LogDate DATETIME
	--DECLARE @iComplaintID INT 

	--SET @iComplaintID = 49

	IF EXISTS(SELECT * FROM CUSTOMERCARE.T_Complaint_Request_Detail
	WHERE I_Status_ID =2 AND  I_Complaint_Req_ID =@iComplaintID)
	BEGIN
	SET @LogDate =(SELECT Dt_Upd_On FROM CUSTOMERCARE.T_Complaint_Request_Detail
	WHERE I_Status_ID =2 AND  I_Complaint_Req_ID =@iComplaintID)
	END
	ELSE
	BEGIN
	SET @LogDate =(SELECT MIN(Dt_Upd_On) FROM CUSTOMERCARE.T_Complaint_Audit_Trail
	WHERE I_Status_ID =2 AND  I_Complaint_Req_ID =@iComplaintID)
	END

RETURN @LogDate

END