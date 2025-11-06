CREATE PROCEDURE [dbo].[uspGetTermAttendanceMapping] 
	@iCourseID int = null,
	@iTermId int
AS
BEGIN

	SET NOCOUNT OFF;

	SELECT COUNT(*) FROM dbo.T_Student_Attendance_Details 
	WHERE I_Course_ID = ISNULL(@iCourseID,I_Course_ID)
	and I_Term_ID = @iTermId
	
END
