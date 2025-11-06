CREATE PROCEDURE [dbo].[uspGetMonthlyExamSubjectList]
(
@iBrandID INT
)
AS
BEGIN

SELECT DISTINCT TTES.I_Exam_Component_ID,TECM.S_Component_Name,TETM.S_Exam_Type_Name FROM dbo.T_Term_Eval_Strategy TTES
INNER JOIN dbo.T_Exam_Component_Master TECM ON TTES.I_Exam_Component_ID = TECM.I_Exam_Component_ID
INNER JOIN dbo.T_Course_Master TCM ON TTES.I_Course_ID = TCM.I_Course_ID
LEFT JOIN dbo.T_Exam_Type_Master TETM ON TETM.I_Exam_Type_Master_ID=TECM.I_Exam_Type_Master_ID
WHERE TTES.I_Status=1
AND TCM.I_Brand_ID=@iBrandID

END
