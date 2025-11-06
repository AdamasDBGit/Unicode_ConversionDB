CREATE PROCEDURE [EOS].[uspUpdateEmployeeSkillDetails]
(
	@iEmployeeID INT,
	@iExamComponentID INT
)
AS 
BEGIN

	DECLARE @iSkillID INT, @iCenterID INT

	SET @iCenterID = (SELECT I_Centre_Id FROM dbo.T_Employee_Dtls
						WHERE I_Employee_ID = @iEmployeeID)

	IF EXISTS(SELECT I_Skill_ID FROM EOS.T_Skill_Exam_Map 
				WHERE I_Exam_Component_ID = @iExamComponentID
				AND I_Centre_ID = @iCenterID
				AND I_Status <> 0)
	BEGIN
		SET @iSkillID = (SELECT I_Skill_ID FROM EOS.T_Skill_Exam_Map 
							WHERE I_Exam_Component_ID = @iExamComponentID
							AND I_Centre_ID = @iCenterID
							AND I_Status <> 0)
	END

	ELSE
	BEGIN
		SET @iSkillID = (SELECT I_Skill_ID FROM EOS.T_Skill_Exam_Map 
							WHERE I_Exam_Component_ID = @iExamComponentID
							AND I_Centre_ID IS NULL
							AND I_Status <> 0)
	END

	UPDATE EOS.T_Employee_Skill_Map 
	SET I_Status = 1
	WHERE I_Skill_ID = @iSkillID
	AND I_Employee_ID = @iEmployeeID

END
