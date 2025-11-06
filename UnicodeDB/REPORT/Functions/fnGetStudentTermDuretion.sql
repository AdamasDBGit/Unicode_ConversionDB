CREATE FUNCTION [REPORT].[fnGetStudentTermDuretion] 
(
	@StudentDetailID INT,
	@CourseID INT,
	@TermID INT
)
RETURNS  @rtnTable TABLE
(
	iSequence INT,
	sTermName VARCHAR(250),
	dtTermStartDate DATETIME,
	dtTermActualEndDate DATETIME,
	dtTermCalculateEndDate DATETIME,
	iTermDuretion NUMERIC(8,2),
	iStudentDetailID INT,
	sEmployeeName VARCHAR(1000),
	fScheduleVariance NUMERIC(8,2),
	iCourseID INT,
	iTermID INT
)

AS 
BEGIN
	-- Fill the table variable with the rows for your result set
		DECLARE @GetSequence INT
		DECLARE @GetStartDate DATETIME
		DECLARE @GetEndDate DATETIME
		DECLARE @GetActualEndDate DATETIME
		DECLARE @GetCourseDuretion NUMERIC(8,2)
		DECLARE @GetTermDuretion NUMERIC(8,2)
		DECLARE @GetTotalSessionInTerm NUMERIC(8,2)
		DECLARE @GetTotalSessionInCourse INT
		DECLARE @GetEmployeeName VARCHAR(1000)	
		DECLARE @GetRecomendedNoSession NUMERIC(8,2)	
		DECLARE @GetActualNoSession NUMERIC(8,2)	
		DECLARE @GetScheduleVariance NUMERIC(8,2)		

		DECLARE @iTermID INT
		DECLARE @sTermName VARCHAR(250)
		DECLARE @iSequence INT

		DECLARE @iEmployeeID INT
		DECLARE @sEmployeeName VARCHAR(1000)
		DECLARE @sEmpName VARCHAR(300)

		SET @GetCourseDuretion = 0
		SET @GetTermDuretion = 0
		SET @GetTotalSessionInCourse = 0
		SET @GetTotalSessionInTerm = 0
		
		
		SELECT @GetTotalSessionInCourse = COUNT(SM.I_Session_ID)
		FROM dbo.T_Session_Master SM
		WHERE SM.I_Session_ID IN (SELECT DISTINCT SMM.I_Session_ID FROM dbo.T_Session_Module_Map SMM
		INNER JOIN T_Module_Term_Map MTM
		ON MTM.I_Module_ID = SMM.I_Module_ID
		AND SMM.I_Status = 1
		AND MTM.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map TCM
		ON TCM.I_Term_ID = MTM.I_Term_ID
		AND TCM.I_Status =1
		AND TCM.I_Course_ID = @CourseID
		AND TCM.I_Status =1 )


		DECLARE TERM_cursor CURSOR FOR 
			SELECT distinct TCM.I_Term_ID, TCM.I_Sequence, TM.S_Term_Name
			FROM dbo.T_Student_Batch_Details AS tsbd
			INNER JOIN dbo.T_Student_Batch_Master AS tsbm
			ON tsbd.I_Batch_ID = tsbm.I_Batch_ID
			INNER JOIN T_Term_Course_Map TCM
			ON TCM.I_Course_ID = tsbm.I_Course_ID
			AND tsbd.I_Student_ID =@StudentDetailID
			AND tsbm.I_Course_ID =@CourseID
			INNER JOIN T_Term_Master TM
			ON TCM.I_Term_ID = TM.I_Term_ID
			AND TM.I_Term_ID = @TermID
			ORDER BY TCM.I_Term_ID

			OPEN TERM_cursor 
			FETCH NEXT FROM TERM_cursor 
			INTO @iTermID,@iSequence,@sTermName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @GetStartDate = MIN(Dt_Schedule_Date) FROM dbo.T_TimeTable_Master AS tttm 
		INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tttm.I_Batch_ID = tsbd.I_Batch_ID AND tsbd.I_Status=1
		INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbd.I_Batch_ID = tsbm.I_Batch_ID
		INNER JOIN dbo.T_Student_Center_Detail AS tscd 
		on tsbd.I_Student_ID=tscd.I_Student_Detail_ID AND tttm.I_Center_ID=tscd.I_Centre_Id
		WHERE I_Student_Detail_ID = @StudentDetailID 
		AND I_Is_Complete =  1 
		AND I_Course_ID = @CourseID 
		AND I_Term_ID = @iTermID
		--AND Dt_Attendance_Date = (SELECT MIN(Dt_Attendance_Date) FROM dbo.T_Student_Attendance_Details 
		--								WHERE I_Student_Detail_ID = @StudentDetailID 
		--								AND I_Has_Attended =  1 
		--								AND I_Course_ID = @CourseID 
		--								AND I_Term_ID = @iTermID)

		SELECT @GetEndDate = Max(Dt_Schedule_Date) FROM dbo.T_TimeTable_Master AS tttm
		INNER JOIN dbo.T_Student_Batch_Details AS tsbd ON tttm.I_Batch_ID = tsbd.I_Batch_ID AND tsbd.I_Status=1
		INNER JOIN dbo.T_Student_Batch_Master AS tsbm ON tsbd.I_Batch_ID = tsbm.I_Batch_ID
		INNER JOIN dbo.T_Student_Center_Detail AS tscd 
		on tsbd.I_Student_ID=tscd.I_Student_Detail_ID AND tttm.I_Center_ID=tscd.I_Centre_Id
		WHERE tsbd.I_Student_ID = @StudentDetailID 
		--AND I_Has_Attended =  1 
		AND I_Course_ID = @CourseID 
		AND I_Term_ID = @iTermID
		--AND Dt_Attendance_Date = (SELECT MAX(Dt_Attendance_Date) FROM dbo.T_Student_Attendance_Details 
		--								WHERE I_Student_Detail_ID = @StudentDetailID 
		--								AND I_Has_Attended =  1 
		--								AND I_Course_ID = @CourseID 
		--								AND I_Term_ID = @iTermID)

		SET @GetTotalSessionInTerm = 0

		SELECT @GetTotalSessionInTerm = COUNT(SM.I_Session_ID) FROM dbo.T_Session_Master SM
		WHERE SM.I_Session_ID IN ( SELECT DISTINCT SMM.I_Session_ID FROM dbo.T_Session_Module_Map SMM 
		INNER JOIN T_Module_Term_Map MTM
		ON MTM.I_Module_ID = SMM.I_Module_ID
		AND SMM.I_Status = MTM.I_Status
		AND MTM.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map TCM
		ON TCM.I_Term_ID = MTM.I_Term_ID
		AND TCM.I_Term_ID = @iTermID
		AND TCM.I_Status =1
		AND TCM.I_Course_ID = @CourseID
		AND TCM.I_Status =1)				
	
		SELECT @GetCourseDuretion = CDM.N_Course_Duration 
		FROM dbo.T_Course_Delivery_Map CDM
		INNER JOIN T_Course_Center_Delivery_FeePlan CCDF
		ON CCDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
		INNER JOIN dbo.T_Student_Batch_Master AS tsbm
		ON CDM.I_Course_ID = tsbm.I_Course_ID
		AND CDM.I_Delivery_Pattern_ID = tsbm.I_Delivery_Pattern_ID
		INNER JOIN dbo.T_Student_Batch_Details AS tsbd
		ON tsbd.I_Batch_ID = tsbm.I_Batch_ID
		INNER JOIN dbo.T_Student_Center_Detail AS tscd
		ON tscd.I_Student_Detail_ID = tsbd.I_Student_ID
		INNER JOIN dbo.T_Center_Batch_Details AS tcbd
		ON tsbm.I_Batch_ID = tcbd.I_Batch_ID
		AND tcbd.I_Centre_Id = tscd.I_Centre_Id
		WHERE tsbd.I_Student_ID = @StudentDetailID
		AND tsbm.I_Course_ID = @CourseID
		AND CDM.I_Status  <> 0
		
		if @GetTotalSessionInCourse>0 
		BEGIN
			SET @GetTermDuretion  = (@GetCourseDuretion * @GetTotalSessionInTerm) / @GetTotalSessionInCourse
		END
		SET @GetActualEndDate = DATEADD(d, @GetTermDuretion, @GetStartDate)

		-- Get faculty conductiong(term can have more than one faculty conducting the class)
		-- SET @GetEmployeeName = ''

		SET @sEmployeeName =''
		SELECT @sEmployeeName = @sEmployeeName + CAST(T.EmployeeName AS VARCHAR(1000)) + ',' FROM
			(SELECT DISTINCT (tum.S_Title +' ' + tum.S_First_Name + ' ' + ISNULL(tum.S_Middle_Name,'') + ' ' + tum.S_Last_Name) as EmployeeName
			FROM dbo.T_Student_Attendance_Details SAD
			INNER JOIN dbo.T_User_Master AS tum
			ON SAD.S_Crtd_By = tum.S_Login_ID
			AND SAD.I_Student_Detail_ID = @StudentDetailID
			AND SAD.I_Course_ID = @CourseID
			AND SAD.I_Term_ID = @iTermID) T

		
		SET @sEmployeeName = SUBSTRING(@sEmployeeName,0,LEN(@sEmployeeName))


		IF @GetTermDuretion > 0 
		BEGIN
			SET @GetRecomendedNoSession = (@GetTotalSessionInTerm / @GetTermDuretion) * DATEDIFF(d,@GetStartDate , GETDATE())
		END

		SELECT  @GetActualNoSession = COUNT(I_Session_ID) FROM dbo.T_Student_Attendance_Details 
		where I_Term_ID = @iTermID AND I_Course_ID = @CourseID AND I_Student_Detail_ID = @StudentDetailID AND I_Has_Attended = 1
		if @GetRecomendedNoSession > 0
		BEGIN
			SET @GetScheduleVariance = (@GetRecomendedNoSession - @GetActualNoSession) / @GetRecomendedNoSession
		END
	
		-- Insert Record in return table 
		INSERT INTO @rtnTable(iSequence,sTermName,dtTermStartDate,dtTermActualEndDate,dtTermCalculateEndDate,iTermDuretion,iStudentDetailID,sEmployeeName,fScheduleVariance,iCourseID,iTermID) 
		VALUES(@iSequence,@sTermName,@GetStartDate,@GetEndDate,@GetActualEndDate,@GetTermDuretion,@StudentDetailID,@sEmployeeName,@GetScheduleVariance,@CourseID, @iTermID)
				
	   FETCH NEXT FROM TERM_cursor 
	   INTO @iTermID,@iSequence,@sTermName

	END


	CLOSE TERM_cursor
	DEALLOCATE TERM_cursor
	
	RETURN;

END