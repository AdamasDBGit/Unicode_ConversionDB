CREATE FUNCTION [REPORT].[fnGetSequenceVariance]
(
	@StudentDetailID INT,
	@CourseID INT,
	@TermID INT,
	@dtStartDate datetime,
	@dtEndDate datetime
)
--RETURNS  NUMERIC(8,2)
RETURNS  @rtnTable TABLE
(
	nSequenceVariance NUMERIC(8,2),
	iStudentDetailID INT,
	iCourseID INT,
	iTermID INT
)

AS 
BEGIN
	-- Fill the table variable with the rows for your result set
		DECLARE @tblExistingSequence TABLE
		(
			I_tblExistingSequence INT IDENTITY(1,1),
			I_Term_ID INT,
			I_Module_ID INT,
			I_Session_ID INT,
			I_TermSequence INT,
			I_ModuleSequence INT, 
			I_SessionSequence INT,
			S_Session_Name VARCHAR(250)
		)

		DECLARE @tblGetSequence TABLE
		(
			I_tblGetSequence INT IDENTITY(1,1),
			I_Session_ID INT,
			I_Term_ID INT,
			I_Module_ID INT,
			Dt_Attendance_Date DATETIME
		)

		DECLARE @itblGetSequence INT
		DECLARE @itblGetNextSequence INT
		DECLARE @iSessionID INT
		DECLARE @iTermID INT
		DECLARE @iModuleID INT
		DECLARE @DtAttendanceDAte DATETIME

		DECLARE @INextSessionId INT
		DECLARE @ITblExistingSequence INT
		DECLARE @ITblExistingNextSession INT
		DECLARE @iDiff NUMERIC(8,2)
		DECLARE @iCount INT
		DECLARE @iLoop INT
		DECLARE @nSequenceVariance NUMERIC(8,2)

		SET @iDiff = 0
		SET @nSequenceVariance = 0
		SET @iCount = 0
		SET @iLoop = 0

		INSERT INTO @tblExistingSequence(I_Term_ID,I_Module_ID,I_Session_ID,I_TermSequence,I_ModuleSequence,I_SessionSequence,S_Session_Name) 
		SELECT DISTINCT TM.I_Term_ID, MM.I_Module_ID, SM.I_Session_ID,TCM.I_Sequence as TSeq, MTM.I_Sequence as MSeq, SMM.I_Sequence, SM.S_Session_Name
			FROM T_Session_Master SM
			INNER JOIN dbo.T_Session_Module_Map SMM
			ON SMM.I_Session_ID = SM.I_Session_ID
			AND SMM.I_Status = 1
			INNER JOIN T_Module_Master MM
			ON SMM.I_Module_ID = MM.I_Module_ID
			INNER JOIN T_Module_Term_Map MTM
			ON MTM.I_Module_ID = MM.I_Module_ID
			INNER JOIN T_Term_Master TM
			ON MTM.I_Term_ID = TM.I_Term_ID
			AND TM.I_Term_ID = @TermID
			INNER JOIN T_Term_Course_Map TCM
			ON TCM.I_Term_ID = TM.I_Term_ID
			INNER JOIN T_Course_Master CM
			ON TCM.I_Course_ID = CM.I_Course_ID
			WHERE CM.I_Course_ID = @CourseID
			GROUP BY TM.I_Term_ID, MM.I_Module_ID, SM.I_Session_ID,TCM.I_Sequence, MTM.I_Sequence, SMM.I_Sequence, SM.S_Session_Name, SMM.I_Session_Module_ID

		INSERT INTO @tblGetSequence(I_Session_ID,I_Term_ID,I_Module_ID,Dt_Attendance_Date)
		SELECT DISTINCT T.I_Session_ID,T.I_Term_ID,T.I_Module_ID,T.Dt_Attendance_Date FROM 
		(SELECT  I_Student_Detail_ID,I_Session_ID,I_Term_ID,I_Module_ID,min(Dt_Attendance_Date) Dt_Attendance_Date 
		FROM T_Student_Attendance_Details 
		GROUP BY I_Session_ID,I_Term_ID,I_Module_ID,I_Student_Detail_ID
		HAVING I_Student_Detail_ID = @StudentDetailID
		) T  WHERE T.I_Term_ID = @TermID --AND T.Dt_Attendance_Date >=@dtStartDate AND T.Dt_Attendance_Date <= @dtEndDate
		ORDER BY T.Dt_Attendance_Date

		SELECT @iCount = COUNT(I_tblGetSequence) FROM @tblGetSequence
		
		DECLARE Seq_Cursor CURSOR FOR 
			SELECT * FROM @tblGetSequence

		OPEN Seq_Cursor 
			FETCH NEXT FROM Seq_Cursor
			INTO @itblGetSequence,@iSessionID,@iTermID,@iModuleID,@DtAttendanceDAte
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iLoop = @iLoop + 1
		SET @itblGetNextSequence = @itblGetSequence + 1 
		if @iLoop < @iCount
		BEGIN
			SELECT @INextSessionId = I_Session_ID FROM @tblGetSequence WHERE I_tblGetSequence = @itblGetNextSequence AND I_Term_ID = @TermID
			SELECT @ITblExistingSequence = I_tblExistingSequence FROM @tblExistingSequence WHERE I_Session_ID = @iSessionID AND I_Term_ID = @TermID
			SELECT @ITblExistingNextSession = I_tblExistingSequence FROM @tblExistingSequence WHERE I_Session_ID = @INextSessionId AND I_Term_ID = @TermID
			IF @ITblExistingNextSession < @ITblExistingSequence
			BEGIN
				SET @iDiff = @iDiff + 1
			END
		END
		FETCH NEXT FROM Seq_Cursor 
			INTO @itblGetSequence,@iSessionID,@iTermID,@iModuleID,@DtAttendanceDAte
	END
	
		IF @iCount > 0
		BEGIN
			SET @nSequenceVariance = @iDiff / @iCount
		END
			INSERT INTO @rtnTable VALUES(@nSequenceVariance,@StudentDetailID,@CourseID,@TermID)
	
	CLOSE Seq_Cursor
	DEALLOCATE Seq_Cursor
	
	RETURN ;

END