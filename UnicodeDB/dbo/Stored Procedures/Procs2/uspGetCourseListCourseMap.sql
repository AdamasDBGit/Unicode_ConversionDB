CREATE PROCEDURE [dbo].[uspGetCourseListCourseMap] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

    -- Insert statements for procedure here
	SELECT	A.I_CourseList_Course_ID,
			A.I_CourseList_ID,
			B.S_CourseList_Name,
			A.I_Course_ID,
			C.S_Course_Code,
			C.S_Course_Name
	FROM dbo.T_CourseList_Course_Map A 
	INNER JOIN dbo.T_CourseList_Master B 
	ON A.I_CourseList_ID = B.I_CourseList_ID
	INNER JOIN dbo.T_Course_Master C
	ON A.I_Course_ID=C.I_Course_ID
	WHERE A.I_Status <> 0
	AND B.I_Status <> 0
END
