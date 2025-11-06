CREATE FUNCTION [PSCERTIFICATE].[uspGetPerformanceRating]
(
	@iStudentID INT,
	@iCourseID INT
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @iTotalTermCount INT, @iTotalMarks INT, @iWeightedMarks NUMERIC(18,2), @sGrade VARCHAR(20)
	
	SELECT @iTotalTermCount = COUNT([TSTD].[I_Student_Term_Detail_ID]) FROM [dbo].[T_Student_Term_Detail] AS TSTD
	WHERE [TSTD].[I_Student_Detail_ID] = @iStudentID AND [TSTD].[I_Course_ID] = @iCourseID
	AND [TSTD].[S_Term_Final_Marks] IS NOT NULL

	SELECT @iTotalMarks = SUM([TSTD].[S_Term_Final_Marks]) FROM [dbo].[T_Student_Term_Detail] AS TSTD
	WHERE [TSTD].[I_Student_Detail_ID] = @iStudentID AND [TSTD].[I_Course_ID] = @iCourseID
	AND [TSTD].[S_Term_Final_Marks] IS NOT NULL
	
	SELECT @iWeightedMarks = @iTotalMarks / @iTotalTermCount
	
	SELECT @sGrade = S_Grade_Type
	FROM dbo.T_Grading_Pattern_Detail
	WHERE I_Grading_Pattern_ID = (SELECT I_Grading_Pattern_ID FROM dbo.T_Course_Master WHERE I_Course_ID = @iCourseID)
	AND I_MinMarks <= @iWeightedMarks
	AND I_MaxMarks >= @iWeightedMarks
	
	RETURN @sGrade
END