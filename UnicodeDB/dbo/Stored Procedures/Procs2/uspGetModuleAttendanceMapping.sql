CREATE PROCEDURE [dbo].[uspGetModuleAttendanceMapping] 
	@iModuleId int = null,
	@iStudentID INT

AS
BEGIN

	SET NOCOUNT OFF;

	SELECT COUNT(*) FROM dbo.T_Student_Attendance_Details 
	WHERE I_Module_ID = ISNULL(@iModuleId,I_Module_ID)
	and I_Student_Detail_ID = @iStudentID
	
END
