CREATE FUNCTION [REPORT].[fnGetStudentCourseDuretion]
(
	@StudentDetailID INT = null,
	@CourseID INT
)
RETURNS  @rtnTable TABLE
(
	dtCourseStartDAte DATETIME,
	dtCourseEndDate DATETIME,
	iDuretion INT,
	iStudentDetailID INT,
	iCourseID INT
)

AS 
BEGIN
	-- Fill the table variable with the rows for your result set
	
		DECLARE @GetStartDate DATETIME
		DECLARE @GetEndDate DATETIME
		DECLARE @GetDuretion INT
		
		SET @GetDuretion = ''

		SELECT @GetStartDate = Dt_Attendance_Date FROM dbo.T_Student_Attendance_Details 
		WHERE I_Student_Detail_ID = @StudentDetailID 
		AND I_Has_Attended =  1 
		AND I_Course_ID = @CourseID
		AND Dt_Attendance_Date = (SELECT MIN(Dt_Attendance_Date) FROM dbo.T_Student_Attendance_Details 
										WHERE I_Student_Detail_ID = @StudentDetailID 
										AND I_Has_Attended =  1 
										AND I_Course_ID = @CourseID)
		SELECT @GetDuretion = CDM.N_Course_Duration 
		FROM dbo.T_Course_Delivery_Map CDM
		INNER JOIN T_Course_Center_Delivery_FeePlan CCDF
		ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
		INNER JOIN T_Student_Course_Detail SCD
		ON SCD.I_Course_Center_Delivery_ID = CCDF.I_Course_Center_Delivery_ID
		WHERE SCD.I_Student_Detail_ID = @StudentDetailID
		AND SCD.I_Course_ID = @CourseID
		
		SET @GetEndDate =  DATEADD(d, @GetDuretion, @GetStartDate)

		-- Insert Record in return table 
		INSERT INTO @rtnTable (dtCourseStartDAte,dtCourseEndDate,iDuretion,iStudentDetailID,iCourseID)
		VALUES (@GetStartDate,@GetEndDate,@GetDuretion,@StudentDetailID,@CourseID)
	
	RETURN;

END