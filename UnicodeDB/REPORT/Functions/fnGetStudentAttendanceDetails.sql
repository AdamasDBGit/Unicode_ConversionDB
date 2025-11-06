		  
CREATE FUNCTION [REPORT].[fnGetStudentAttendanceDetails]
(
	@iStudentID INT,
	@iTermID INT,
	@iBatchID INT
)
RETURNS	VARCHAR(10)
AS
BEGIN
	DECLARE @dAttendance VARCHAR(10)

	SELECT TOP 1 @dAttendance = CAST(ROUND(D_Attendance,0) AS VARCHAR(10)) FROM dbo.T_Student_Term_Detail AS tstd
	WHERE I_Student_Detail_ID = @iStudentID
	AND I_Term_ID = @iTermID
	AND I_Batch_ID = @iBatchID
	
	RETURN @dAttendance
END