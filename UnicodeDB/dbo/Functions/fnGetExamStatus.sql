-- =============================================
-- Author:		Shankha Roy
-- Create date: '12/13/2007'
-- Description:	This Function return a exam status
--  of exam given student id course id and term id
-- Return: String
-- =============================================
CREATE FUNCTION [dbo].[fnGetExamStatus]
(
	@iStudentId INT,
	@iCourseID INT,
	@iTermID INT = NULL
)
RETURNS VARCHAR(20)

AS
BEGIN

DECLARE @sExamStatus VARCHAR(20)
-- New Update Code ---
IF(@iTermID IS NOT NULL)
-- For Term Status 
 BEGIN
	SET @sExamStatus = (SELECT S_Term_Status FROM dbo.T_Student_Term_Detail WHERE I_Student_Detail_ID =@iStudentId AND I_Course_ID= @iCourseID AND I_Term_ID = @iTermID)
 END
ELSE
-- For Course Completion status
	BEGIN
		IF EXISTS(SELECT * FROM dbo.T_Student_Term_Detail WHERE I_Student_Detail_ID =@iStudentId AND I_Course_ID= @iCourseID )
			BEGIN
				IF EXISTS(SELECT S_Term_Status FROM dbo.T_Student_Term_Detail WHERE I_Student_Detail_ID =@iStudentId AND I_Course_ID= @iCourseID AND S_Term_Status ='Referred')
					BEGIN
						SET @sExamStatus='Referred'
					END
				ELSE
					BEGIN
						SET @sExamStatus='Pass'
					END
			END
		ELSE
			BEGIN
				SET @sExamStatus='Referred'
			END
	END


	RETURN @sExamStatus;
END