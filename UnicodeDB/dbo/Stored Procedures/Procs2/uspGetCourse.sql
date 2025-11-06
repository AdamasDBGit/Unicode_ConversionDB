CREATE PROCEDURE [dbo].[uspGetCourse] 
	@iCourseID INT

AS
BEGIN

	SET NOCOUNT OFF;

	select I_CourseFamily_ID,I_Brand_ID,S_Course_Code,S_Course_Name,S_Course_Desc from dbo.T_Course_Master where I_Status=1 and I_Course_ID = @iCourseID
	
END
