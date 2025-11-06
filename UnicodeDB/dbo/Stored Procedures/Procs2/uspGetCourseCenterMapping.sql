CREATE PROCEDURE [dbo].[uspGetCourseCenterMapping] 
	@iCourseID INT

AS
BEGIN

	SET NOCOUNT OFF;

	SELECT COUNT(*) FROM dbo.T_Course_Center_Detail WHERE I_Course_ID = @iCourseID
	
END
