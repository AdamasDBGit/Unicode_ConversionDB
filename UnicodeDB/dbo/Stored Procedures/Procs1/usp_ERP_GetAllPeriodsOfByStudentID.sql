CREATE PROCEDURE [dbo].[usp_ERP_GetAllPeriodsOfByStudentID] 
(
	-- Add the parameters for the stored procedure here
	@StudentDetailID INT = NULL,
	@DayID INT = NULL
)
AS
BEGIN
	BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @brandID int = (select top  1 TPM.I_Brand_ID from T_Student_Parent_Maps TSPM inner join T_Parent_Master TPM 
	ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
	where I_Student_Detail_ID=@StudentDetailID)
	DECLARE @sessionID int = (select top 1 I_School_Session_ID from T_School_Academic_Session_Master where I_Brand_ID=@brandID and I_Current_Session=1 order by I_School_Session_ID desc  )
	SELECT 
	--TERSD.I_Routine_Structure_Detail_ID,
	CONCAT(TERSD.T_FromSlot, ' - ', TERSD.T_ToSlot) AS TimeRange,
	TERSD.T_FromSlot AS StarTime,
	TERSD.T_ToSlot AS EndTime,
	TWDM.S_Day_Name AS DayName,
	TERSD.I_Period_No AS PeriodNo,
	TERSD.I_Is_Break AS IsBreak,
	TFM.S_Faculty_Name AS FacultyName,
	TSM.S_Subject_Name AS SubjectName,
	TSM.I_Subject_ID AS SubjectID,
	TSG.S_School_Group_Name AS SchoolGroup,
	TC.S_Class_Name AS ClassName,
	TERSD.I_Day_ID AS DayID,
	TS.S_Section_Name AS Section,
	TESCR.I_Student_Class_Routine_ID AS MergedStudentClassRoutineID,
	CASE WHEN 
    ( SELECT COUNT(*) FROM T_ERP_Attendance_Entry_Header AS TEAEH WHERE TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID
    ) > 0 THEN 1 ELSE 0 END AS IsAttendanceTaken,
	TFM.S_Faculty_Name TeacherName,
	TFM.I_Faculty_Master_ID,
	TESCRW.S_ClassWork ClassWork

	--TWDM.S_Day_Name AS Day_Name
	

	FROM
	T_ERP_Student_Class_Routine TESCR
	INNER JOIN T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	INNER JOIN T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	INNER JOIN T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID
	INNER JOIN T_Subject_Master TSM ON TSM.I_Subject_ID = TESCR.I_Subject_ID
	INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID
	INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID
	INNER JOIN T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID
	INNER JOIN T_School_Group_Class TSGS ON TSGS.I_School_Group_ID = TSG.I_School_Group_ID and TSGS.I_Class_ID=TC.I_Class_ID
	INNER JOIN T_Student_Class_Section TSCS ON TSCS.I_School_Group_Class_ID = TSGS.I_School_Group_Class_ID AND TSCS.I_Section_ID=TERSH.I_Section_ID
	INNER JOIN T_Section TS ON TS.I_Section_ID = TSCS.I_Section_ID  
	LEFT JOIN T_ERP_Student_Class_Routine_Work TESCRW ON TESCRW.I_Student_Class_Routine_ID=TESCR.I_Student_Class_Routine_ID
	
	WHERE 
	(TSCS.I_Student_Detail_ID = @StudentDetailID AND (TERSD.I_Day_ID =@DayID OR @DayID IS NULL ) ) AND TERSH.I_School_Session_ID=@sessionID
	GROUP BY 
	--TERSD.I_Routine_Structure_Detail_ID,
	TERSD.T_FromSlot, 
	TERSD.T_ToSlot,
	TFM.S_Faculty_Name, 
	TSM.S_Subject_Name, 
	TSG.S_School_Group_Name,
	TC.S_Class_Name,
	TERSD.I_Day_ID,
	TS.S_Section_Name,
	TWDM.S_Day_Name,
	TERSD.I_Period_No,
	TSM.I_Subject_ID,
	TESCR.I_Student_Class_Routine_ID,
	TERSD.I_Routine_Structure_Detail_ID,
	TERSD.I_Is_Break,
	TESCRW.S_ClassWork ,
	TFM.I_Faculty_Master_ID
	--order by TERSD.I_Day_ID asc
	UNION ALL
	SELECT 
	--TERSD.I_Routine_Structure_Detail_ID,
	CONCAT(TERSD.T_FromSlot, ' - ', TERSD.T_ToSlot) AS TimeRange,
	TERSD.T_FromSlot AS StarTime,
	TERSD.T_ToSlot AS EndTime,
	TWDM.S_Day_Name AS DayName,
	TERSD.I_Period_No AS PeriodNo,
	TERSD.I_Is_Break AS IsBreak,
	null AS FacultyName,
	null AS SubjectName,
	null AS SubjectID,
	TSG.S_School_Group_Name AS SchoolGroup,
	TC.S_Class_Name AS ClassName,
	TERSD.I_Day_ID AS DayID,
	TS.S_Section_Name AS Section,
	null AS StudentClassRoutineID,
	0 AS IsAttendanceTaken,
	null TeacherName,
	null ClassWork,
	null I_Faculty_Master_ID
	--TWDM.S_Day_Name AS Day_Name
	

	FROM
	T_ERP_Routine_Structure_Detail TERSD 
	INNER JOIN T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	
	INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID
	INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID
	INNER JOIN T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID
	INNER JOIN T_School_Group_Class TSGS ON TSGS.I_School_Group_ID = TSG.I_School_Group_ID and TSGS.I_Class_ID=TC.I_Class_ID
	INNER JOIN T_Student_Class_Section TSCS ON TSCS.I_School_Group_Class_ID = TSGS.I_School_Group_Class_ID AND TSCS.I_Section_ID=TERSH.I_Section_ID
	INNER JOIN T_Section TS ON TS.I_Section_ID = TSCS.I_Section_ID  

	WHERE 
	(TSCS.I_Student_Detail_ID = @StudentDetailID AND (TERSD.I_Day_ID =@DayID OR @DayID IS NULL) AND TERSD.I_Is_Break=1)  AND TERSH.I_School_Session_ID=@sessionID
	GROUP BY 
	--TERSD.I_Routine_Structure_Detail_ID,
	TERSD.T_FromSlot, 
	TERSD.T_ToSlot, 
	TSG.S_School_Group_Name,
	TC.S_Class_Name,
	TERSD.I_Day_ID,
	TS.S_Section_Name,
	TWDM.S_Day_Name,
	TERSD.I_Period_No,
	TERSD.I_Routine_Structure_Detail_ID,
	TERSD.I_Is_Break
	order by TERSD.I_Day_ID,TERSD.I_Period_No asc

	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message
	END CATCH
END
