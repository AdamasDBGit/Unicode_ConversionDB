-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec [usp_ERP_GetAllClassWokByStudentID] 6101,3,'2024-04-16'
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllClassWokByStudentID] 
(
	-- Add the parameters for the stored procedure here
	@StudentDetailID INT = NULL,
	@DayID INT ,
	@Date datetime 
)
AS
BEGIN
	BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
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
	TESCR.I_Student_Class_Routine_ID AS StudentClassRoutineID,
	CASE WHEN 
    ( SELECT COUNT(*) FROM T_ERP_Attendance_Entry_Header AS TEAEH WHERE TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID
    ) > 0 THEN 1 ELSE 0 END AS IsAttendanceTaken,
	TFM.S_Faculty_Name TeacherName,
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
	INNER JOIN T_Student_Class_Section TSCS ON TSCS.I_School_Group_Class_ID = TSGS.I_School_Group_Class_ID
	LEFT JOIN T_Section TS ON TS.I_Section_ID = TERSH.I_Section_ID 
	left join T_ERP_Student_Class_Routine_Work TESCRW on 
	TESCRW.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID 
	and TESCRW.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID
	and CAST(TESCRW.Dt_Date as date) = CAST(@Date as date)

	WHERE 
	(TSCS.I_Student_Detail_ID = 6101 AND (TERSD.I_Day_ID =3 OR 3 IS NULL ) )
	GROUP BY 
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
	TESCRW.S_ClassWork
	--order by TERSD.I_Day_ID asc
	UNION ALL
	SELECT 
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
	null ClassWork

	--TWDM.S_Day_Name AS Day_Name
	

	FROM
	T_ERP_Routine_Structure_Detail TERSD 
	INNER JOIN T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	
	INNER JOIN T_School_Group TSG ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID
	INNER JOIN T_Class TC ON TC.I_Class_ID = TERSH.I_Class_ID
	INNER JOIN T_Week_Day_Master TWDM ON TWDM.I_Day_ID = TERSD.I_Day_ID
	INNER JOIN T_School_Group_Class TSGS ON TSGS.I_School_Group_ID = TSG.I_School_Group_ID and TSGS.I_Class_ID=TC.I_Class_ID
	INNER JOIN T_Student_Class_Section TSCS ON TSCS.I_School_Group_Class_ID = TSGS.I_School_Group_Class_ID
	LEFT JOIN T_Section TS ON TS.I_Section_ID = TERSH.I_Section_ID  

	WHERE 
	(TSCS.I_Student_Detail_ID = 6101 AND (TERSD.I_Day_ID =3 OR 3 IS NULL) AND TERSD.I_Is_Break=1)
	GROUP BY 
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
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message
	END CATCH
END
