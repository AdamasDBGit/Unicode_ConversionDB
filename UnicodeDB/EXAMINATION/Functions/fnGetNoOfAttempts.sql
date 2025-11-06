-- ==============================================================================
-- Author:		Sandeep Acharyya
-- Create date: '30/05/2007'
-- Description:	This Function will return the number of attempts for that student
-- Return:		INT Number of Attempts
-- ==============================================================================

CREATE FUNCTION [EXAMINATION].[fnGetNoOfAttempts]
(
	@iStudentID INT,
	@iCourseID INT,
	@iTermID INT,
	@iModuleID INT,
	@iExamComponentID INT
)  
RETURNS  INT

AS
BEGIN
 
DECLARE @iAttemptCount INT

IF (@iModuleID = 0)
BEGIN
	SET @iModuleID = NULL
END

SELECT @iAttemptCount = COUNT(*) FROM EXAMINATION.T_Eligibility_List
WHERE I_Student_Detail_ID = @iStudentID
AND I_Exam_ID IN (
					SELECT I_Exam_ID FROM EXAMINATION.T_Examination_Detail WITH(NOLOCK)
					WHERE I_Exam_Component_ID = @iExamComponentID
					AND I_Course_ID = @iCourseID
					AND I_Term_ID = @iTermID
					AND I_Module_ID = ISNULL(@iModuleID,I_Module_ID)
				 )

RETURN @iAttemptCount
END