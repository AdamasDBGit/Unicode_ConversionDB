-- =============================================
-- Author:Shankha Roy
-- Create date: 12/06/2007
-- Description:	Search a Complaint history data of a complaint from T_Complaint_Audit_Trail
-- =============================================

CREATE PROCEDURE [CUSTOMERCARE].[uspGetComplaintHistory]
(
@iComplaintReqID INT
)
AS
BEGIN

-- SELECT Complaint details Table[0]
SELECT 		    
			CAT.I_Complaint_Req_ID AS I_Complaint_Req_ID,   
			ISNULL(CAT.S_Remarks,'') AS  S_Remarks,
			ISNULL(CAT.I_Current_Escalation_level,0) AS I_Current_Escalation_level, 
			ISNULL(CAT.S_Email_ID,' ') AS  S_Email_ID,
			ISNULL(CAT.S_Contact_Number,' ') AS  S_Contact_Number,
			ISNULL(CAT.I_Complaint_Category_ID, 0) as I_Complaint_Category_ID,
			ISNULL(CAT.I_Complaint_Mode_ID,0) as I_Complaint_Mode_ID,
			ISNULL(CMM.S_Complaint_Mode_Value,' ') AS S_Complaint_Mode_Value ,
			ISNULL(CAT.I_User_Hierarchy_detail_ID,0) AS I_User_Hierarchy_detail_ID,
			ISNULL(CAT.S_Complaint_Code,' ') AS S_Complaint_Code,
			ISNULL(CAT.I_Status_ID, 0) as I_Status_ID,
			ISNULL(CAT.I_User_ID,0) AS  I_User_ID,  
			ISNULL(CAT.S_Complaint_Details,' ') AS  S_Complaint_Details,
			CAT.Dt_Complaint_Date AS  Dt_Complaint_Date,			
			ISNULL(SD.S_First_Name,'') AS S_First_Name,
			ISNULL(SD.S_Middle_Name,'') AS S_Middle_Name,
			ISNULL(SD.S_Last_Name,'') AS S_Last_Name,
			ISNULL(SD.S_Student_ID,' ') AS S_Student_ID,
			ISNULL(CCM.S_Complaint_Desc,'') AS S_Complaint_Desc,
			ISNULL(CAT.I_Center_ID, 0) AS I_Center_ID,
			ISNULL(CM.S_Center_Name,'') AS S_Center_Name,
			ISNULL(CM.S_Center_Code,'') AS S_Center_Code,
			ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
			ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
			ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
			ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
			ISNULL(UD.I_Document_ID,0) AS I_Document_ID,
			CAT.I_Course_ID AS I_Course_ID,   
			ISNULL(COM.S_Course_Name,' ') AS S_Course_Name,
			ISNULL(RCM.S_Root_Cause_Desc,' ') AS S_Root_Cause_Desc,	
			ISNULL(CAT.I_Root_Cause_ID,' ') AS I_Root_Cause_ID,
			CAT.Dt_Upd_On AS Dt_Upd_On,
			CAT.S_Upd_By AS S_Upd_By,
			ISNULL(UM.S_Login_ID,' ') AS S_Login_ID,
			ISNULL(UM.S_First_Name,' ') AS S_First_Name,
			ISNULL(UM.S_Middle_Name,' ') AS S_Middle_Name,
			ISNULL(UM.S_Last_Name,' ') AS S_Last_Name,
			--DATEDIFF(day, CAT.Dt_Complaint_Date, getdate()) AS CycleTime
		  --   DATEDIFF(day, CAT.Dt_Complaint_Date, CAT.Dt_Upd_On) AS CycleTime
			ISNULL(CAST(([REPORT].fnGetCycleTimeForCustomerCare(2,CAT.I_Status_ID,CAT.I_Complaint_Req_ID))AS INT),0) AS CycleTime
			FROM		     
			[CUSTOMERCARE].T_Complaint_Audit_Trail CAT  
			INNER JOIN T_Student_Detail SD WITH (NOLOCK)
			ON CAT.I_Student_Detail_ID = SD.I_Student_Detail_ID
			INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM WITH (NOLOCK)
			ON CAT.I_Complaint_Category_ID = CCM.I_Complaint_Category_ID 
			INNER JOIN T_Centre_Master CM WITH (NOLOCK)
			ON CAT.I_Center_ID = CM.I_Centre_ID 
			INNER JOIN CUSTOMERCARE.T_Complaint_Mode_Master CMM WITH (NOLOCK)
			ON CAT.I_Complaint_Mode_ID =CMM.I_Complaint_Mode_ID
			LEFT OUTER JOIN dbo.T_Course_Master COM
			ON CAT.I_Course_ID = COM.I_Course_ID
			LEFT OUTER JOIN dbo.T_Upload_Document UD 
			ON    CAT.I_Document_ID  = UD.I_Document_ID
			LEFT OUTER JOIN CUSTOMERCARE.T_Root_Cause_Master RCM
			ON RCM.I_Root_Cause_ID =CAT.I_Root_Cause_ID
			LEFT OUTER JOIN dbo.T_User_Master UM
			ON CAT.I_User_ID = UM.I_User_ID
			WHERE CAT.I_Complaint_Req_ID= @iComplaintReqID

-- Select Complaint feedback Table[1]

SELECT     A.S_Feedback_By, 
		   A.Dt_Feedback_Date, 
           A.S_Remarks, 
		   B.S_Feedback_Value, 
           A.I_Complaint_Req_ID
FROM       CUSTOMERCARE.T_Complaint_Feedback A INNER JOIN
           CUSTOMERCARE.T_Feedback_Master B ON 
           A.I_Feedback_ID = B.I_Feedback_ID
WHERE		A.I_Complaint_Req_ID = @iComplaintReqID

END
