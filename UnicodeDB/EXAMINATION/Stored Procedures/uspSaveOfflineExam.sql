/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will save the Online Exam
Parameters  : 	
**************************************************************************************************************/
  
  
  CREATE PROCEDURE [EXAMINATION].[uspSaveOfflineExam]
(
	@iExamID INT,
	@iStudentDetailID INT,
	@sAnswerXML XML,
	@nMarks NUMERIC(8,2),
	@sUpdBy VARCHAR(20),
	@DtUpdOn DATETIME
)
AS
BEGIN	
	UPDATE Examination.T_Student_Question_Answer
	SET S_Answer_XML = @sAnswerXML,
		N_Marks = @nMarks,
		I_No_Of_Attempts = ISNULL(I_No_Of_Attempts,0) + 1,
		S_Upd_By = @sUpdBy,
		Dt_Upd_On = @DtUpdOn
	WHERE I_Exam_ID = @iExamID
	AND I_Student_Detail_ID = @iStudentDetailID
END
