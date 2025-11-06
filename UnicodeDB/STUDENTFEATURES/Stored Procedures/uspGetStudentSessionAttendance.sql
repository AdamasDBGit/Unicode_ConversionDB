CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentSessionAttendance]
(
	@iStudentDetailID int,
	@iCourseID int,
	@iTermID int,
	@iModuleID int
)

AS
BEGIN

SET NOCOUNT ON

	DECLARE @sModuleName varchar(50)
	SET @sModuleName = (SELECT S_Module_Name FROM dbo.T_Module_Master
						WHERE I_Module_ID = @iModuleID)

	DECLARE @tblSessions TABLE
		(
			Sequence int,
			SessionID int,
			SessionName varchar(250),
			SessionType varchar(50),
			SessionDuration numeric(18,2)
		)
		INSERT INTO @tblSessions
		SELECT SMM.I_Sequence,SM.I_Session_ID, SM.S_Session_Name, 
			   STM.S_Session_Type_Name, SM.N_Session_Duration 
			FROM dbo.T_Session_Module_Map SMM
		INNER JOIN dbo.T_Session_Master SM
		ON SM.I_Session_ID = SMM.I_Session_ID
		INNER JOIN dbo.T_Session_Type_Master STM
		ON STM.I_Session_Type_ID = SM.I_Session_Type_ID
			WHERE SMM.I_Module_ID = @iModuleID
			AND SMM.I_Status = 1 
		ORDER BY SMM.I_Sequence

	DECLARE @tblSessionAttendance TABLE
		(
			ModuleID int,
			ModuleName varchar(50),
			Sequence int,
			SessionID int,
			SessionName varchar(250),
			SessionType varchar(50),
			SessionDuration numeric(18,2),
			AttendanceDate datetime,
			TimeSlot varchar(20)
		)

	INSERT INTO @tblSessionAttendance
		(ModuleID,ModuleName,Sequence,SessionID,SessionName,SessionType,SessionDuration)
	SELECT @iModuleID,@sModuleName,Sequence,SessionID,SessionName,SessionType,SessionDuration
		FROM @tblSessions

	UPDATE @tblSessionAttendance SET AttendanceDate =
	(SELECT Dt_Attendance_Date FROM dbo.T_Student_Attendance_Details
	WHERE I_Student_Detail_ID = @iStudentDetailID
	AND I_Course_ID = @iCourseID
	AND I_Term_ID = @iTermID
	AND I_Module_ID = @iModuleID
	AND I_Session_ID IN (SELECT SessionID FROM @tblSessions)
	AND I_Session_ID = SessionID
	)
	
	UPDATE @tblSessionAttendance SET TimeSlot =
	(SELECT CT.S_TimeSlot_Code FROM dbo.T_Student_Attendance_Details SAD
	 INNER JOIN dbo.T_Center_TimeSlot CT
	 ON CT.I_TimeSlot_ID = SAD.I_TimeSlot_ID
	 WHERE I_Student_Detail_ID = @iStudentDetailID
	 AND I_Course_ID = @iCourseID
	 AND I_Term_ID = @iTermID
	 AND I_Module_ID = @iModuleID
	 AND I_Session_ID IN (SELECT SessionID FROM @tblSessions)
	 AND I_Session_ID = SessionID
	)
	
	SELECT * FROM @tblSessionAttendance

END
