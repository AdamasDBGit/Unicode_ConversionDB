-- =============================================
-- Author:		Debarshi Basu
-- Create date: '24/05/2007'
-- Description:	Determines if the student has completed the 
--		previous terms successfully to appear for the next term evaluation exam
-- =============================================
CREATE FUNCTION [EXAMINATION].[ufnGetPreviousTermCompletionStatus]
(
	@iStudentID INT, 
	@iCourseID INT, 
	@iTermID INT
)
RETURNS  CHAR(1)

AS 
-- Returns the Student Status whether ACTIVE, ON LEAVE or DROPOUT.
BEGIN

DECLARE @cCompletionStatus CHAR(1)
DECLARE @iNoOfCompleteTerm INT, @iNoOfTotalTerms INT

SELECT @iNoOfTotalTerms = COUNT(DISTINCT I_Term_ID) 
FROM dbo.T_Student_Term_Detail WITH(NOLOCK)
WHERE I_Course_ID = @iCourseID
AND I_Term_ID IN (
					SELECT I_Term_ID 
					FROM dbo.T_Term_Course_Map WITH(NOLOCK)
					WHERE I_Course_ID = @iCourseID
					AND I_Status = 1
					AND I_Sequence < 
									(SELECT I_Sequence 
										FROM dbo.T_Term_Course_Map WITH(NOLOCK)
										WHERE I_Course_ID = @iCourseID
										AND I_Term_ID = @iTermID
										AND I_Status = 1 )
					)

SELECT @iNoOfCompleteTerm = COUNT(*) 
FROM dbo.T_Student_Term_Detail WITH(NOLOCK)
WHERE I_Course_ID = @iCourseID
AND I_Student_Detail_ID = @iStudentID
AND ISNULL(I_Is_Completed,0) = 1
AND I_Term_ID IN (
					SELECT I_Term_ID 
					FROM dbo.T_Term_Course_Map WITH(NOLOCK)
					WHERE I_Course_ID = @iCourseID
					AND I_Status = 1
					AND I_Sequence < 
									(SELECT I_Sequence 
										FROM dbo.T_Term_Course_Map WITH(NOLOCK)
										WHERE I_Course_ID = @iCourseID
										AND I_Term_ID = @iTermID
										AND I_Status = 1 )
					)

IF (@iNoOfCompleteTerm >= @iNoOfTotalTerms)
	BEGIN
		SET @cCompletionStatus = 'Y'
	END
ELSE
	BEGIN
		SET @cCompletionStatus = 'N'
	END

RETURN @cCompletionStatus
END