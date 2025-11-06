--exec [uspERPGetStudentAttendanceData] 105531,null
CREATE PROCEDURE [dbo].[uspERPGetStudentMonthAttendanceData]
(
  @iStudentDetailID int = null,
  @iSessionID int = null,
  @iMonthID int 
)
AS
BEGIN
SELECT 
	
	MONTH(TEAEH.Dt_Date) as MonthID,
	DateName( month , DateAdd( month , MONTH(TEAEH.Dt_Date) , 0 ) - 1 ) MonthName,
	
	TEAEH.Dt_Date Date,
	AED.I_IsPresent Status,
	TSM.S_Subject_Name SubjectName,
	TFM.S_Faculty_Name,
	TERSD.I_Period_No PeriodNo,
	TERSD.T_FromSlot Start,
	TERSD.T_ToSlot EndTime
	FROM 
	T_Student_Class_Section TSCS 
	inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID 
	inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID 
	inner join T_Student_Detail TSD on TSD.I_Student_Detail_ID = TSCS.I_Student_Detail_ID
	left join T_ERP_Attendance_Entry_Detail as AED ON TSCS.I_Student_Detail_ID = AED.I_Student_Detail_ID 
	left join T_ERP_Attendance_Entry_Header TEAEH ON TEAEH.I_Attendance_Entry_Header_ID = AED.I_Attendance_Entry_Header_ID 
	left join T_ERP_Student_Class_Routine TESCR On TESCR.I_Student_Class_Routine_ID = TEAEH.I_Student_Class_Routine_ID
	inner join T_Faculty_Master TFM ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID
	left join T_ERP_Routine_Structure_Detail TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	left join T_ERP_Routine_Structure_Header  TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID 
		AND TSCS.I_School_Session_ID = TERSH.I_School_Session_ID 
		AND TERSH.I_Class_ID = TSGC.I_Class_ID 
		AND TERSH.I_School_Group_ID = TSGC.I_School_Group_ID
	left join T_Subject_Master TSM ON TESCR.I_Subject_ID = TSM.I_Subject_ID

	WHERE (TSCS.I_School_Session_ID=@iSessionID) 
	AND (TSCS.I_Student_Detail_ID=@iStudentDetailID ) 
	AND MONTH(TEAEH.Dt_Date) = @iMonthID
END
