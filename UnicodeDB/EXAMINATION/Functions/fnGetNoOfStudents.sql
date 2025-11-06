-- =============================================
-- Author:		Swagata De
-- Create date: '01/05/2007'
-- Description:	This Function will return the no. of students
--				who have registered for an exam 
-- Return:		No. of students
-- =============================================

CREATE FUNCTION [EXAMINATION].[fnGetNoOfStudents]
(
	@iExamId INT	
)  
RETURNS  INT

AS
BEGIN
 
DECLARE @iStudentCount INT

SET @iStudentCount=( SELECT COUNT(*) FROM EXAMINATION.T_Eligibility_List
GROUP BY I_Exam_ID
HAVING I_Exam_ID=@iExamId)

RETURN @iStudentCount
END