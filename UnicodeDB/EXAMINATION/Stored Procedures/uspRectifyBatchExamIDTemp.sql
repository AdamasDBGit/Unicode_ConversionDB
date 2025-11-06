CREATE PROCEDURE [EXAMINATION].[uspRectifyBatchExamIDTemp]
(
@ExamCompID INT,
@ModuleID INT,
@TermID INT,
@BatchID INT
)
AS
BEGIN

DECLARE @OrgBatchExamID INT
--DECLARE @NewBatchExamID INT


SELECT @OrgBatchExamID=TBEM.I_Batch_Exam_ID FROM EXAMINATION.T_Batch_Exam_Map AS TBEM WHERE TBEM.I_Exam_Component_ID=@ExamCompID
AND TBEM.I_Module_ID=@ModuleID AND TBEM.I_Term_ID=@TermID AND TBEM.I_Batch_ID=@BatchID
AND TBEM.S_Crtd_By!='rice-group-admin'




UPDATE EXAMINATION.T_Student_Marks SET I_Batch_Exam_ID=@OrgBatchExamID WHERE I_Student_Marks_ID
IN
(
SELECT TSM.I_Student_Marks_ID FROM EXAMINATION.T_Batch_Exam_Map AS TBEM 
INNER JOIN EXAMINATION.T_Student_Marks AS TSM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
WHERE TBEM.I_Exam_Component_ID=@ExamCompID
AND TBEM.I_Module_ID=@ModuleID AND TBEM.I_Term_ID=@TermID AND TBEM.I_Batch_ID=@BatchID
AND TBEM.S_Crtd_By='rice-group-admin' AND TSM.I_Batch_Exam_ID!=@OrgBatchExamID
)


UPDATE EXAMINATION.T_Batch_Exam_Map SET I_Status=0 WHERE I_Batch_Exam_ID IN
(
SELECT TBEM.I_Batch_Exam_ID FROM EXAMINATION.T_Batch_Exam_Map AS TBEM WHERE TBEM.I_Exam_Component_ID=@ExamCompID
AND TBEM.I_Module_ID=@ModuleID AND TBEM.I_Term_ID=@TermID AND TBEM.I_Batch_ID=@BatchID
AND TBEM.S_Crtd_By='rice-group-admin'
)

END
