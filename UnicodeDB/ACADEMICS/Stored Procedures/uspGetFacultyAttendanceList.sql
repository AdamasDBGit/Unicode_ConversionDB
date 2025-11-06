/*****************************************************************************************************************
Created by: Abhisek Bhattacharya
Date: 08/05/2007
Description:Gets the list of faculties for a particular center and training id who are approved to take the training
Parameters: CenterId, TrainingId
******************************************************************************************************************/
CREATE PROCEDURE [ACADEMICS].[uspGetFacultyAttendanceList]
(
	@iTrainingId int
)
AS

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @iTDMasterID INT
	
	-- Select TD Master ID from the system
	SELECT @iTDMasterID = I_Hierarchy_Master_ID
	FROM dbo.T_Hierarchy_Master
	WHERE S_Hierarchy_Type = 'RH'
	AND I_Status = 1
	

	SELECT
		FN.I_Faculty_Nomination_ID,
		FN.I_Centre_Id,
		CM.S_Center_Name,
		FN.I_Employee_ID,
		FN.C_Attended,
		FN.C_Approved,
		FN.N_Marks_Obtd,
		FN.C_Feedback_Provided,
		FN.C_Feedback_Received,
		UM.I_User_ID,
		ED.S_Emp_ID,
		ED.S_Title,
		ED.S_First_Name,
		ED.S_Middle_Name,
		ED.S_Last_Name,
		ED.S_Email_ID,
		ISNULL(HD.S_Hierarchy_Name,'') AS S_Hierarchy_Name
	FROM ACADEMICS.T_Faculty_Nomination FN WITH (NOLOCK)
	INNER JOIN dbo.T_Employee_Dtls ED
	ON FN.I_Employee_ID = ED.I_Employee_ID
	AND FN.I_Training_ID = @iTrainingId
	AND FN.C_Approved = 'Y'
	AND ED.I_Status IN (3,6)
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = FN.I_Centre_Id
	AND CM.I_Status = 1
	AND GETDATE() >= ISNULL(CM.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(CM.Dt_Valid_To,GETDATE())
	INNER JOIN dbo.T_User_Master UM
	ON UM.I_Reference_ID = ED.I_Employee_ID
	AND UM.S_User_Type = 'CE'
	AND UM.I_Status = 1
	LEFT OUTER JOIN dbo.T_User_Hierarchy_Details UHD
	ON UM.I_User_ID = UHD.I_User_ID
	AND UHD.I_Status = 1
	AND GETDATE() >= ISNULL(UHD.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(UHD.Dt_Valid_To,GETDATE())
	LEFT OUTER JOIN dbo.T_Hierarchy_Details HD
	ON HD.I_Hierarchy_Detail_ID = UHD.I_Hierarchy_Detail_ID
	AND HD.I_Status = 1
	AND HD.I_Hierarchy_Master_ID = @iTDMasterID
	ORDER BY FN.I_Employee_ID DESC
		
END
