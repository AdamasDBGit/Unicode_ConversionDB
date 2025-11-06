/****************************************************************************/

CREATE FUNCTION [EXAMINATION].[fnCheckStudentCourseEnrollment]
(
	@iStudentID INT,
	@iCourseID INT,
	@iTermID INT,
	@iModuleID INT = NULL
)
RETURNS CHAR(1)

AS
BEGIN
	DECLARE @cReturn CHAR(1)
	SET @cReturn = 'N'	
	
	IF (@iModuleID IS NULL OR @iModuleID = 0)
	BEGIN
		IF EXISTS(SELECT I_Student_Term_Detail_ID FROM dbo.T_Student_Term_Detail WHERE I_Student_Detail_ID = @iStudentID
					AND I_Course_ID = @iCourseID AND I_Term_ID = @iTermID AND I_Is_Completed = 0)
		BEGIN
			SET @cReturn = 'Y'
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT I_Student_Module_Detail_ID FROM dbo.T_Student_Module_Detail WHERE I_Student_Detail_ID = @iStudentID
					AND I_Course_ID = @iCourseID AND I_Term_ID = @iTermID AND I_Module_ID = @iModuleID AND I_Is_Completed = 0)
		BEGIN
			SET @cReturn = 'Y'
		END		
	END
	
	RETURN @cReturn
END