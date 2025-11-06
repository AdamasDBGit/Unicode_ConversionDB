CREATE PROCEDURE [EOS].[uspGetSkillsForExamComponent]
(
	@iSkillID INT,
	@sComponents VARCHAR(500),
	@iCenterID INT = NULL
)
AS
BEGIN
	IF (@iCenterID IS NULL)
	BEGIN
		SELECT * FROM EOS.T_Skill_Exam_Map 
		WHERE	I_Centre_ID  IS NULL
				AND I_Exam_Component_ID IN 
				(
					SELECT * FROM dbo.fnString2Rows(@sComponents, ',')
				)
		AND I_Skill_ID <> @iSkillID
		AND I_Status = 1
	END
	ELSE
	BEGIN
		SELECT * FROM EOS.T_Skill_Exam_Map 
		WHERE	I_Centre_ID  = @iCenterID
				AND I_Exam_Component_ID IN 
				(
					SELECT * FROM dbo.fnString2Rows(@sComponents, ',')
				)
		AND I_Skill_ID <> @iSkillID
		AND I_Status = 1
	END
END
