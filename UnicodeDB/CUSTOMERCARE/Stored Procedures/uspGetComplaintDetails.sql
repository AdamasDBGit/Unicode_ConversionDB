-- =============================================
-- Author:		Shankha Roy
-- Create date: 12/06/2007
-- Description:	Search a Complaint from T_Complaint_Request_details
-- =============================================

CREATE PROCEDURE [CUSTOMERCARE].[uspGetComplaintDetails]
(
	@I_Complaint_Req_ID INT
)

AS
BEGIN

SELECT 
			CRD.I_Complaint_Req_ID AS I_Complaint_Req_ID,
			ISNULL(CRD.I_Course_ID,0) AS I_Course_ID,   
			ISNULL(CRD.S_Remarks,'') AS  S_Remarks,
			ISNULL(CRD.I_Current_Escalation_level,0) AS I_Current_Escalation_level, 
			ISNULL(CRD.S_Email_ID,' ') AS  S_Email_ID,
			ISNULL(CRD.S_Contact_Number,' ') AS  S_Contact_Number,
			ISNULL(CRD.I_Complaint_Category_ID, 0) as I_Complaint_Category_ID,
			ISNULL(CRD.I_Complaint_Mode_ID,0) as I_Complaint_Mode_ID,
			ISNULL(CMM.S_Complaint_Mode_Value,' ') AS S_Complaint_Mode_Value ,
			ISNULL(CRD.I_User_Hierarchy_detail_ID,0) AS I_User_Hierarchy_detail_ID,
			ISNULL(CRD.S_Complaint_Code,' ') AS S_Complaint_Code,
			ISNULL(CRD.I_Status_ID, 0) as I_Status_ID,
			ISNULL(CRD.I_User_ID,0) AS  I_User_ID,  
			ISNULL(CRD.S_Complaint_Details,' ') AS  S_Complaint_Details,
			CRD.Dt_Complaint_Date AS  Dt_Complaint_Date,
			ISNULL(SD.S_First_Name,'') AS S_First_Name,
			ISNULL(SD.S_Middle_Name,'') AS S_Middle_Name,
			ISNULL(SD.S_Last_Name,'') AS S_Last_Name,
			ISNULL(SD.S_Student_ID,' ') AS S_Student_ID,
			ISNULL(CCM.S_Complaint_Desc,'') AS S_Complaint_Desc,
			ISNULL(CRD.I_Center_ID, 0) AS I_Center_ID,
			ISNULL(CM.S_Center_Name,'') AS S_Center_Name,
			ISNULL(CM.S_Center_Code,'') AS S_Center_Code,
			ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
			ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
			ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
			ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
			ISNULL(UD.I_Document_ID,0) AS I_Document_ID,
			ISNULL(COM.S_Course_Name,' ') AS S_Course_Name	,
			ISNULL(RCM.S_Root_Cause_Desc,' ') AS S_Root_Cause_Desc,
			ISNULL(RCM.S_Root_Cause_Code, '') AS S_Root_Cause_Code,
			ISNULL(CRD.I_Root_Cause_ID,0) AS I_Root_Cause_ID,
			CRD.Dt_Upd_On AS Dt_Upd_On,
			ISNULL(CRD.S_Upd_By,' ') AS S_Upd_By,
			ISNULL(UM.S_Login_ID,' ') AS S_Login_ID,
			ISNULL(UM.S_First_Name,' ') AS S_First_Name,
			ISNULL(UM.S_Middle_Name,' ') AS S_Middle_Name,
			ISNULL(UM.S_Last_Name,' ') AS S_Last_Name,
			ISNULL(CAST(([REPORT].fnGetCycleTimeForCustomerCare(2,CRD.I_Status_ID,CRD.I_Complaint_Req_ID))AS INT),0) AS CycleTime
			FROM		     
			CUSTOMERCARE.T_Complaint_Request_Detail CRD 
			INNER JOIN T_Student_Detail SD WITH (NOLOCK)
			ON CRD.I_Student_Detail_ID = SD.I_Student_Detail_ID
			INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM WITH (NOLOCK)
			ON CRD.I_Complaint_Category_ID = CCM.I_Complaint_Category_ID 
			INNER JOIN T_Centre_Master CM WITH (NOLOCK)
			ON CRD.I_Center_ID = CM.I_Centre_ID 
			INNER JOIN CUSTOMERCARE.T_Complaint_Mode_Master CMM WITH (NOLOCK)
			ON CRD.I_Complaint_Mode_ID =CMM.I_Complaint_Mode_ID
			LEFT OUTER JOIN dbo.T_Course_Master COM
			ON CRD.I_Course_ID = COM.I_Course_ID
			LEFT OUTER JOIN  dbo.T_Upload_Document UD 
			ON    CRD.I_Document_ID  = UD.I_Document_ID  
			LEFT OUTER JOIN CUSTOMERCARE.T_Root_Cause_Master RCM
			ON RCM.I_Root_Cause_ID =CRD.I_Root_Cause_ID
			LEFT OUTER JOIN dbo.T_User_Master UM
			ON CRD.I_User_ID = UM.I_User_ID
			WHERE I_Complaint_Req_ID= @I_Complaint_Req_ID

-- Select Complaint feedback Table[1]

			SELECT     A.S_Feedback_By AS S_Feedback_By, 
					   A.Dt_Feedback_Date AS Dt_Feedback_Date, 
					   A.S_Remarks AS S_Remarks, 
					   B.S_Feedback_Value AS S_Feedback_Value, 
					   B.S_Feedback_Code AS S_Feedback_Code,
					   A.I_Complaint_Req_ID AS I_Complaint_Req_ID,
					   A.I_Feedback_ID AS I_Feedback_ID
			FROM       CUSTOMERCARE.T_Complaint_Feedback A INNER JOIN
					   CUSTOMERCARE.T_Feedback_Master B ON 
					   A.I_Feedback_ID = B.I_Feedback_ID
			WHERE	   A.I_Complaint_Req_ID = @I_Complaint_Req_ID



END
