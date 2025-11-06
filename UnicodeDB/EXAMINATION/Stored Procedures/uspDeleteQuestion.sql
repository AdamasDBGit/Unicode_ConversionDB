/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will Delete the Question Details
Parameters  : 		@iQuestionID int
**************************************************************************************************************/


CREATE PROCEDURE [EXAMINATION].[uspDeleteQuestion]
	@iQuestionID int
AS
BEGIN	

	DELETE FROM EXAMINATION.T_SubQuestion_Choice
	WHERE I_SubQuestion_ID IN
	(SELECT I_SubQuestion_ID FROM EXAMINATION.T_SubQuestion
		WHERE I_Question_ID = @iQuestionID)

	DELETE FROM EXAMINATION.T_SubQuestion
	WHERE I_Question_ID = @iQuestionID

	DELETE FROM EXAMINATION.T_Question_Choices
	WHERE I_Question_ID = @iQuestionID

	DELETE FROM EXAMINATION.T_Question_Pool
	WHERE I_Question_ID = @iQuestionID

END
