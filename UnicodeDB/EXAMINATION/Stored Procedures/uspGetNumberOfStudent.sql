/**************************************************************************************************************
Created by  : SandeepAcharrya
Date		: 15.05.2007
Description : This SP will return the number of students for a particular exam from the eligibility list table
Parameters  : 
Returns     : 
**************************************************************************************************************/ 
CREATE PROCEDURE [EXAMINATION].[uspGetNumberOfStudent]
(
	@iExamID INT
)
AS
BEGIN
	SELECT COUNT(I_Student_Detail_ID) AS [I_No_Of_Students] FROM EXAMINATION.T_Eligibility_List WHERE I_Exam_ID = @iExamID
END
