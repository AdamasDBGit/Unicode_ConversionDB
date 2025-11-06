/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will get the offline Question Paper but in encrypted Format
Parameters  : 		@iExamID int,
					@iStudentID int
**************************************************************************************************************/


CREATE PROCEDURE [EXAMINATION].[uspGetEncryptedQuestionPaper]
	@iExamID int	
AS
BEGIN	

	SELECT S_Question_XML
	FROM EXAMINATION.T_Offline_Examination_Master
	WHERE I_Exam_ID = @iExamID
END
