CREATE PROCEDURE [dbo].[StudentAttendanceChecker] 
@RoutineID int,
@Date datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
--insert into #tempAttendance
declare @isAttendanceTaken int
DECLARE @PresentCount INT;
WITH RoutineDetails AS (
    SELECT 
        t2.I_Period_No, 
        t2.I_Day_ID, 
        t2.I_Routine_Structure_Detail_ID,
        t2.I_Routine_Structure_Header_ID
    FROM 
        T_ERP_Student_Class_Routine t1
    INNER JOIN 
        T_ERP_Routine_Structure_Detail t2 
    ON 
        t1.I_Routine_Structure_Detail_ID = t2.I_Routine_Structure_Detail_ID
    WHERE 
        t1.I_Student_Class_Routine_ID = @RoutineID
)
SELECT 
    @PresentCount = COUNT(t5.I_IsPresent)
FROM 
    RoutineDetails t1 
INNER JOIN 
    T_ERP_Routine_Structure_Detail t2 
ON 
    t2.I_Day_ID = t1.I_Day_ID 
    AND t1.I_Routine_Structure_Header_ID = t2.I_Routine_Structure_Header_ID
INNER JOIN 
    T_ERP_Student_Class_Routine t3 
ON 
    t3.I_Routine_Structure_Detail_ID = t2.I_Routine_Structure_Detail_ID
INNER JOIN 
    T_ERP_Attendance_Entry_Header t4 
ON 
    t4.I_Student_Class_Routine_ID = t3.I_Student_Class_Routine_ID
INNER JOIN 
    T_ERP_Attendance_Entry_Detail t5 
ON 
t5.I_Attendance_Entry_Header_ID = t4.I_Attendance_Entry_Header_ID
WHERE 
    t2.I_Period_No = 1 
    AND t5.I_IsPresent = 1
	and t4.Dt_Date=@Date;
set @isAttendanceTaken= 
CASE WHEN 
    ( SELECT COUNT(*) FROM T_ERP_Attendance_Entry_Header AS TEAEH WHERE TEAEH.I_Student_Class_Routine_ID = @RoutineID AND Dt_Date = @Date
    ) > 0 THEN 1 ELSE 0 END
--select @isAttendanceTaken
SELECT 
	 TC.S_Class_Name
	,TERSD.T_FromSlot
     ,TERSD.T_ToSlot
	 ,TERSD.I_Period_No
	 ,TS.S_Section_Name
     ,TERSH.I_Stream_ID
     ,STE.S_Stream
	 ,TSM.I_Subject_ID
     ,TSM.S_Subject_Name
	 ,TFM.I_Faculty_Master_ID
	 ,TFM.S_Faculty_Name
	 ,TSD.I_Student_Detail_ID
	 ,concat (TSD.S_First_Name,' ',isnull(TSD.S_Middle_Name,''),' ',TSD.S_Last_Name) as Name
	 ,TSD.I_RollNo
	,ISNULL(TEAED.I_IsPresent,0) I_IsPresent
	,TEAEH.Dt_Date Date
	,ERD.S_Student_Photo as ImageUrl

	--TESCR.I_Student_Class_Routine_ID AS ClassRoutineID,
	--TERSD.I_Routine_Structure_Detail_ID AS RoutineStructureDetailID,
	--TERSH.I_Routine_Structure_Header_ID AS RoutineStructureHeaderID,
	----TERSH.I_Class_ID
	--TSGC.I_School_Group_Class_ID AS SchoolGroupClassID,
	--TSCS.I_Student_Detail_ID AS StudentDetailID,
	--ISNULL(TSD.S_First_Name,'')+' '+ISNULL(TSD.S_Middle_Name,'')+' '+ISNULL(TSD.S_Last_Name,'') AS StudentName,
	--TSCS.S_Class_Roll_No AS StudentRollNo,
	--TSD.S_Student_ID AS StudentID,
	--ISNULL(TEAED.I_IsPresent, 0) AS IsPresent 

	into #tempAttendance
	FROM T_ERP_Student_Class_Routine TESCR
	inner join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	inner join T_ERP_Routine_Structure_Header TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_ID = TERSH.I_School_Group_ID
	inner join T_School_Group TSG ON TSG.I_School_Group_ID = TSGC.I_School_Group_ID
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID and TC.I_Class_ID=TERSH.I_Class_ID
	inner join T_Student_Class_Section TSCS ON TSCS.I_School_Session_ID = TERSH.I_School_Session_ID AND TSCS.I_School_Group_Class_ID = TSGC.I_School_Group_Class_ID --AND (TSCS.I_Section_ID = TERSH.I_Section_ID OR TSCS.I_Section_ID is null)-- AND (TSCS.I_Stream_ID = TERSH.I_Stream_ID OR TSCS.I_Stream_ID is null)
	AND ((TSCS.I_Section_ID = TERSH.I_Section_ID) OR (TSCS.I_Section_ID IS NULL AND TERSH.I_Section_ID IS NULL))
	AND ((TSCS.I_Stream_ID = TERSH.I_Stream_ID) OR (TSCS.I_Stream_ID IS NULL AND TERSH.I_Stream_ID IS NULL))
	inner join T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Student_Subject TESS ON TESS.I_Subject_ID = TESCR.I_Subject_ID and TSD.I_Student_Detail_ID=TESS.I_Student_Detail_ID
	
	left join T_Section TS on TS.I_Section_ID=TERSH.I_Section_ID
    left Join T_Stream STE on STE.I_Stream_ID=TERSH.I_Stream_ID
	left join T_Subject_Master TSM  ON TESCR.I_Subject_ID=TSM.I_Subject_ID 
	Left Join T_Faculty_Master TFM on 
	TFM.I_Faculty_Master_ID=TESCR.I_Faculty_Master_ID
	left join T_ERP_Attendance_Entry_Header TEAEH on 
	TEAEH.I_Student_Class_Routine_ID=TESCR.I_Student_Class_Routine_ID and CAST(TEAEH.Dt_Date AS DATE) = CAST(@Date AS DATE)
	left join T_ERP_Attendance_Entry_Detail TEAED ON TEAED.I_Student_Detail_ID = TSCS.I_Student_Detail_ID AND TEAED.I_Attendance_Entry_Header_ID=TEAEH.I_Attendance_Entry_Header_ID
	JOIN dbo.T_Enquiry_Regn_Detail as ERD on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID

	WHERE (TESCR.I_Student_Class_Routine_ID = @RoutineID) 
	if(@isAttendanceTaken=0)
	BEGIN
	CREATE TABLE #previousTempAttendance (
    I_Attendance_Entry_Detail_ID int
	,I_Attendance_Entry_Header_ID int
	,I_Student_Detail_ID int
	,I_IsPresent int
);
	INSERT INTO #previousTempAttendance 
    EXEC ERP_Usp_get_Previous_StudAttendance @Date,@RoutineID;

	update #tempAttendance 
	set #tempAttendance.I_IsPresent = #previousTempAttendance.I_IsPresent
	from  #tempAttendance inner join #previousTempAttendance  on #previousTempAttendance.I_Student_Detail_ID = #tempAttendance.I_Student_Detail_ID
	DROP TABLE #previousTempAttendance;

	END
	
	
	select *,@PresentCount PresentCount from #tempAttendance order by Name asc
	--select * from #previousTempAttendance
	DROP TABLE #tempAttendance;
	

END
