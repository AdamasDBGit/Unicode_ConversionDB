Create view vStudentAISReport
as
SELECT 

tsm.I_Student_Marks_ID,
tsm.I_Student_Detail_ID,
TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                + ' ' + TSD.S_Last_Name StudentName,
TSD.S_Student_ID,
tcm.I_Course_ID,
tcm.S_Course_Name,
TBEM.I_Batch_ID,
TSBM.S_Batch_Code,
TSBM.S_Batch_Name,
TBEM.I_Term_ID,
TTM.S_Term_Code,
TTM.S_Term_Name,
tsm.I_Batch_Exam_ID ,
TBEM.I_Exam_Component_ID,
tecm.S_Component_Name,
TBEM.I_Module_ID,
tmm.S_Module_Code,
tmm.S_Module_Name,
tsm.I_Exam_Total

from EXAMINATION.T_Student_Marks AS TSM
inner JOIN EXAMINATION.T_Batch_Exam_Map  as TBEM ON TBEM.I_Batch_Exam_ID=TSM.I_Batch_Exam_ID
INNER JOIN dbo.T_Exam_Component_Master  AS tecm ON TBEM.I_Exam_Component_ID = tecm.I_Exam_Component_ID
INNER JOIN  dbo.T_Module_Master AS tmm ON TBEM.I_Module_ID =tmm.I_Module_ID
INNER JOIN dbo.T_Student_Detail AS tsd ON tsm.I_Student_Detail_ID=tsd.I_Student_Detail_ID
inner JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
INNER JOIN dbo.T_Course_Master AS tcm ON tmes.I_Course_ID = tcm.I_Course_ID
INNER JOIN dbo.T_Term_Master TTM ON TBEM.I_Term_ID=TTM.I_Term_ID
INNER JOIN dbo.T_Student_Batch_Master TSBM ON TBEM.I_Batch_ID=TSBM.I_Batch_ID