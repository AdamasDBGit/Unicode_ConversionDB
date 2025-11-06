--exec [uspERPGetStudentAttendanceData] 121551,null
CREATE PROCEDURE [dbo].[uspERPGetStudentAttendanceData]
(
  @iStudentDetailID int = null,
  @iSessionID int = null
)
AS
BEGIN
DECLARE @iBrandID int;
set @iBrandID = (select top 1 I_Brand_ID from T_Student_Parent_Maps where I_Student_Detail_ID = @iStudentDetailID)
if(@iSessionID is null)
BEGIN
set @iSessionID = (Select top 1 I_School_Session_ID  from T_School_Academic_Session_Master where I_Brand_ID = @iBrandID and I_Status=1 and I_Current_Session=1 order by I_School_Session_ID desc)
END
-- yearly attendance
SELECT
    max(TC.S_Class_Name) AS Class,
    ISNULL(TS.S_Section_Name,'') Section,
	COUNT(AED.I_IsPresent) AS TotalClasses,
	TSCS.I_School_Session_ID,
	SUM(CASE WHEN AED.I_IsPresent = 1 THEN 1 ELSE 0 END) AS Present,
	CAST(ROUND(100.0 * SUM(CASE WHEN AED.I_IsPresent = 1 THEN 1 ELSE 0 END) / COUNT(AED.I_IsPresent), 2)  as decimal(18,0)) AS SessionPresentPercentage,
	100-CAST(ROUND(100.0 * SUM(CASE WHEN AED.I_IsPresent = 1 THEN 1 ELSE 0 END) / COUNT(AED.I_IsPresent), 2)  as decimal(18,0)) SessionAbsentPercentage

	FROM 
	T_Student_Class_Section TSCS 
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID 
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID 
	inner join T_Student_Detail TSD on TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Attendance_Entry_Detail as AED ON TSCS.I_Student_Detail_ID = AED.I_Student_Detail_ID 
	left join T_ERP_Attendance_Entry_Header TEAEH ON TEAEH.I_Attendance_Entry_Header_ID = AED.I_Attendance_Entry_Header_ID 
	left join T_ERP_Student_Class_Routine TESCR On TESCR.I_Student_Class_Routine_ID = TEAEH.I_Student_Class_Routine_ID
	left join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	left join T_ERP_Routine_Structure_Header  TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID 
		AND TSCS.I_School_Session_ID = TERSH.I_School_Session_ID 
		AND TERSH.I_Class_ID = TSGC.I_Class_ID 
		AND TERSH.I_School_Group_ID = TSGC.I_School_Group_ID
	left join T_Subject_Master TSM ON TESCR.I_Subject_ID = TSM.I_Subject_ID
	left join T_Section TS ON TS.I_Section_ID = TSCS.I_Section_ID

	WHERE (TSCS.I_School_Session_ID=ISNULL(@iSessionID,TSCS.I_School_Session_ID)) 
	AND (TSCS.I_Student_Detail_ID=@iStudentDetailID )
	GROUP BY 
	TSCS.I_Brand_ID
	,TSCS.I_Student_Detail_ID
	, TSCS.I_School_Session_ID
	, TSGC.I_School_Group_ID
	,TSGC.I_Class_ID
	,TS.S_Section_Name
	-- daily attendance
	SELECT 
	TEAEH.Dt_Date Date,
	AED.I_IsPresent Present
	FROM 
	T_Student_Class_Section TSCS 
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID 
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID 
	inner join T_Student_Detail TSD on TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Attendance_Entry_Detail as AED ON TSCS.I_Student_Detail_ID = AED.I_Student_Detail_ID 
	left join T_ERP_Attendance_Entry_Header TEAEH ON TEAEH.I_Attendance_Entry_Header_ID = AED.I_Attendance_Entry_Header_ID 
	left join T_ERP_Student_Class_Routine TESCR On TESCR.I_Student_Class_Routine_ID = TEAEH.I_Student_Class_Routine_ID
	left join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	left join T_ERP_Routine_Structure_Header  TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID 
		AND TSCS.I_School_Session_ID = TERSH.I_School_Session_ID 
		AND TERSH.I_Class_ID = TSGC.I_Class_ID 
		AND TERSH.I_School_Group_ID = TSGC.I_School_Group_ID
	left join T_Subject_Master TSM ON TESCR.I_Subject_ID = TSM.I_Subject_ID

	WHERE (TSCS.I_School_Session_ID=ISNULL(@iSessionID,TSCS.I_School_Session_ID)) 
	AND (TSCS.I_Student_Detail_ID=@iStudentDetailID ) 
	AND CAST(TEAEH.Dt_Date as date) = CAST(getdate() as date)
	-- month attendance
	SELECT 
	TSCS.I_Brand_ID AS BrandId,
	TSCS.I_Student_Detail_ID AS StudentID,	
	max(TSCS.S_Student_ID) AS StudentErpID,
	max(ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '')) AS StudentName,
	max(TC.S_Class_Name) AS Class,
	TSCS.I_School_Session_ID AS SchoolSectionID,
	TSGC.I_School_Group_ID AS SchoolGroupID,
	TSGC.I_Class_ID AS CLassID,
	MONTH(TEAEH.Dt_Date) as MonthID,
	DateName( month , DateAdd( month , MONTH(TEAEH.Dt_Date) , 0 ) - 1 ) MonthName,
	COUNT(AED.I_IsPresent) AS TotalClasses,
	SUM(CASE WHEN AED.I_IsPresent = 1 THEN 1 ELSE 0 END) AS Attendance

 

	FROM 
	T_Student_Class_Section TSCS 
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID 
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID 
	inner join T_Student_Detail TSD on TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Attendance_Entry_Detail as AED ON TSCS.I_Student_Detail_ID = AED.I_Student_Detail_ID 
	left join T_ERP_Attendance_Entry_Header TEAEH ON TEAEH.I_Attendance_Entry_Header_ID = AED.I_Attendance_Entry_Header_ID 
	left join T_ERP_Student_Class_Routine TESCR On TESCR.I_Student_Class_Routine_ID = TEAEH.I_Student_Class_Routine_ID
	left join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	left join T_ERP_Routine_Structure_Header  TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID 
		AND TSCS.I_School_Session_ID = TERSH.I_School_Session_ID 
		AND TERSH.I_Class_ID = TSGC.I_Class_ID 
		AND TERSH.I_School_Group_ID = TSGC.I_School_Group_ID
	left join T_Subject_Master TSM ON TESCR.I_Subject_ID = TSM.I_Subject_ID

	WHERE (TSCS.I_School_Session_ID=ISNULL(@iSessionID,TSCS.I_School_Session_ID)) 
	AND (TSCS.I_Student_Detail_ID=@iStudentDetailID ) 
	GROUP BY 
	TSCS.I_Brand_ID
	,TSCS.I_Student_Detail_ID
	, TSCS.I_School_Session_ID
	, TSGC.I_School_Group_ID
	,TSGC.I_Class_ID
	,MONTH(TEAEH.Dt_Date)
	--session
	Select I_School_Session_ID SessionID,S_Label SessionName from T_School_Academic_Session_Master where I_Brand_ID = @iBrandID and I_Status=1
END
