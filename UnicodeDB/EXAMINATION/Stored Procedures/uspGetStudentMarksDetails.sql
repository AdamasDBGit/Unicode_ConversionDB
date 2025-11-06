/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve all the marks and no of attempts for a student correponding to a 
				particular exam and center
Parameters  : yet to be specified
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetStudentMarksDetails]
	@iExamID int
AS
BEGIN
SET NOCOUNT ON;	
	SELECT	I_Exam_ID,
			I_Student_Detail_ID,
			ISNULL(S_Answer_XML,'NA') AS S_Answer_XML,
			ISNULL(N_Marks,0.00) AS N_Marks,
			ISNULL(I_No_Of_Attempts,0) AS I_No_Of_Attempts
	FROM EXAMINATION.T_Student_Question_Answer WITH(NOLOCK)
	WHERE I_Exam_ID=@iExamID
END
