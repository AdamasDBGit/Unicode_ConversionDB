--------------------------------------------------------------------------------------------
--Issue no 254
--------------------------------------------------------------------------------------------


CREATE PROCEDURE [EOS].[uspGetExamListForSkill]
(
@iSkillID INT = NULL,
@iCenterID INT = NULL
)
AS
BEGIN
IF (@iCenterID IS NULL)
BEGIN
SELECT TSEM.I_Skill_ID,
TSEM.I_Exam_Component_ID,
TECM.S_Component_Name,
TECM.S_Component_Type,
TSEM.Is_Pass_Mandatory,
TSEM.I_Cut_Off,
TSEM.I_Exam_Stage,
TSEM.I_Number_Of_Resits,
TSEM.I_Status,
TSEM.I_Total_Time
FROM EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)
INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)
ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID
WHERE I_Skill_ID = ISNULL(@iSkillID, I_Skill_ID)
AND TSEM.I_Centre_ID IS NULL
AND TSEM.I_Status <> 0
END
ELSE
BEGIN
SELECT TSEM.I_Skill_ID,
TSEM.I_Exam_Component_ID,
TECM.S_Component_Name,
TECM.S_Component_Type,
TSEM.Is_Pass_Mandatory,
TSEM.I_Cut_Off,
TSEM.I_Exam_Stage,
TSEM.I_Number_Of_Resits,
TSEM.I_Status,
TSEM.I_Total_Time
FROM EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)
INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)
ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID
WHERE I_Skill_ID = ISNULL(@iSkillID, I_Skill_ID)
AND TSEM.I_Centre_ID = @iCenterID
AND TSEM.I_Status <> 0
END
END
