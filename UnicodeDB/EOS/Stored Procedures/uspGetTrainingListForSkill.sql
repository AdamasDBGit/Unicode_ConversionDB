/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the Training list for a particular Skill
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetTrainingListForSkill]
(	
	@iSkillID INT = NULL,
	@iCenterID INT = NULL
)	
AS
BEGIN
	IF (@iCenterID IS NULL)
	BEGIN
		SELECT I_Skill_ID, I_Training_ID, I_Training_Stage, I_Status
		FROM EOS.T_Skill_Training_Mapping
		WHERE	I_Skill_ID = @iSkillID
				AND I_Center_ID IS NULL
				AND I_Status <> 0
	END
	ELSE
	BEGIN
		SELECT I_Skill_ID, I_Training_ID, I_Training_Stage, I_Status
		FROM EOS.T_Skill_Training_Mapping
		WHERE	I_Skill_ID = @iSkillID				
				AND I_Center_ID = @iCenterID
				AND I_Status <> 0
	END
END
