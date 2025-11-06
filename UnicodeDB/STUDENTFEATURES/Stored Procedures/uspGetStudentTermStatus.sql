CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentTermStatus] 
(
	-- Add the parameters for the stored procedure here
	@iStudentDetailID int,
	@iCourseID int,
	@iTermID int
)

AS
BEGIN
	
	SELECT * FROM dbo.T_Student_Term_Detail 
	WHERE I_Student_Detail_ID = @iStudentDetailID
	AND I_Course_ID = @iCourseID
	AND I_Term_ID = @iTermID

END
