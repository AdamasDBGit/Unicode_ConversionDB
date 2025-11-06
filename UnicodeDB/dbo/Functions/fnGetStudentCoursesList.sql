-- =============================================
-- Author:		Shankha Roy
-- Create date: '07/11/2007'
-- Description:	This Function return a table 
-- constains courses of given student id
-- Return: Table
-- =============================================
CREATE FUNCTION [dbo].[fnGetStudentCoursesList]
(
	@StudentDetailID INT
)
RETURNS  @rtnTable TABLE
(
	I_Student_Detail_ID INT,
	Courses VARCHAR(2000)
)

AS 
-- Return the Table containing the student course details.
BEGIN

		DECLARE @GetCourse VARCHAR(MAX)
		DECLARE @StudentID INT

		SET @GetCourse = ''

		SELECT @GetCourse = @GetCourse + CAST(CM.[S_Course_Name] AS VARCHAR(250))+ ','
		--CM.S_Course_Name AS S_Course_Name
		FROM
		dbo.T_Student_Course_Detail SCD
		INNER JOIN dbo.T_Course_Master CM 
		ON SCD.I_Course_ID = CM.I_Course_ID
		WHERE I_Student_Detail_ID = @StudentDetailID

		SET @GetCourse = SUBSTRING(@GetCourse,1,LEN(@GetCourse) - 1)

		-- Insert Record in return table 
		INSERT INTO @rtnTable (I_Student_Detail_ID,Courses)
		VALUES (@StudentDetailID,@GetCourse)
	
	RETURN;

END