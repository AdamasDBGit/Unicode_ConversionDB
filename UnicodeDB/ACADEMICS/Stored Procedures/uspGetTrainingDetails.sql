/*****************************************************************************************************************
Created by: Soumya Sikder
Date:15/06/2007
Description:Gets the list of Training Details for a particular training id
Parameters: TrainingId
******************************************************************************************************************/
CREATE PROCEDURE [ACADEMICS].[uspGetTrainingDetails]
(
	@iTrainingId int,
	@CurrentDate datetime
)
AS

BEGIN TRY 

	DECLARE @iTDMasterID INT
	
	-- Select TD Master ID from the system
	SELECT @iTDMasterID = I_Hierarchy_Master_ID
	FROM dbo.T_Hierarchy_Master
	WHERE S_Hierarchy_Type = 'RH'
	AND I_Status = 1

	-- Select list of finally approved faculty
	SELECT
		TC.I_Training_ID,
		TC.S_Training_Name,
		TC.Dt_Training_Date,
		TC.Dt_Training_End_Date,
		TC.S_Description,
		TC.S_Venue,
		TC.I_Status,
		TC.I_Document_ID,
		TC.I_User_ID,
		UM.S_Login_ID,
		UM.S_Title,
		UM.S_First_Name,
		UM.S_Middle_Name,
		UM.S_Last_Name,
		UM.S_Email_ID,
		UM.S_User_Type,
		UD.S_Document_Name,
		UD.S_Document_Type,
		UD.S_Document_Path,
		UD.S_Document_URL,
		UHD.I_Hierarchy_Detail_ID
	FROM Academics.T_Training_Calendar TC 
	INNER JOIN dbo.T_User_Master UM WITH(NOLOCK)
	ON TC.I_User_ID = UM.I_User_ID
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON TC.I_Document_ID = UD.I_Document_ID
	AND UD.I_Status = 1
	LEFT OUTER JOIN dbo.T_User_Hierarchy_Details UHD
	ON TC.I_User_ID = UHD.I_User_ID
	AND UHD.I_Hierarchy_Master_ID = @iTDMasterID
	AND UHD.I_Status = 1
	AND @CurrentDate >= ISNULL(UHD.Dt_Valid_From, @CurrentDate)
	AND @CurrentDate <= ISNULL(UHD.Dt_Valid_To, @CurrentDate)
	WHERE TC.I_Training_ID = @iTrainingId
	--AND TC.I_Status <> 2
	AND UM.I_Status = 1

	--table 2
	SELECT T.I_Training_ID,
		   S.I_Skill_ID,
		   S.S_Skill_Desc,
		   S.S_Skill_No,
		   S.S_Skill_Type,
		   S.I_Status
	FROM ACADEMICS.T_Training_Skill T
	INNER JOIN dbo.T_EOS_Skill_Master S
	ON T.I_Skill_ID = S.I_Skill_ID
	WHERE T.I_Training_ID = @iTrainingId
	AND S.I_Status = 1
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
