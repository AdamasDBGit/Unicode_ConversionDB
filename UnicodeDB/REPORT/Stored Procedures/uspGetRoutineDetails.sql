CREATE PROCEDURE [REPORT].[uspGetRoutineDetails]
(
@BrandID INT,
@sHierarchyListID VARCHAR(MAX),
@dtStartDate DATETIME,
@dtEndDate DATETIME
)
AS

begin

select TTTM.I_TimeTable_ID,TCHND.I_Center_ID,TCHND.S_Center_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
TTTM.Dt_Schedule_Date,TTTM.Dt_Actual_Date,
CONVERT(VARCHAR(10), CAST(TCTM.Dt_Start_Time AS TIME), 0)+' To '+CONVERT(VARCHAR(10), CAST(TCTM.Dt_End_Time AS TIME),0) as TimeSlot,
TTM.S_Term_Name,TMM.S_Module_Name,ISNULL(TSM.S_Session_Name,TTTM.S_Session_Topic) as SessionTopic,
CASE WHEN TTTM.I_Session_ID is not null THEN 'YES' ELSE 'NO' END as IsScheduled,
ISNULL(SF.ScheduledFaculty,AF.ActualFaculty) as ScheduledFaculty,AF.ActualFaculty,
CASE WHEN TTTM.I_SessionTopic_Completed_Status_ID=1 THEN 'YES' ELSE 'NO' END as IsSessionCompleted,
CASE WHEN TTTM.I_ClassType=1 THEN 'Offline'
	 WHEN TTTM.I_ClassType=2 THEN 'Online'
	 WHEN ISNULL(TTTM.I_ClassType,3)=3 THEN 'N/A'
END as ClassType,
CASE WHEN TTTM.I_Is_Complete=1 THEN 'YES' ELSE 'NO' END as IsAttendanceMarked
from T_TimeTable_Master TTTM
inner join T_Center_Hierarchy_Name_Details TCHND on TTTM.I_Center_ID=TCHND.I_Center_ID
inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTTM.I_Batch_ID
inner join T_Center_Timeslot_Master TCTM on TTTM.I_TimeSlot_ID=TCTM.I_TimeSlot_ID
left join T_Term_Master TTM on TTM.I_Term_ID=TTTM.I_Term_ID
left join T_Module_Master TMM on TTTM.I_Module_ID=TMM.I_Module_ID
left join T_Session_Master TSM on TSM.I_Session_ID=TTTM.I_Session_ID
LEFT JOIN
(
	select A.I_TimeTable_ID,B.S_First_Name+' '+ISNULL(B.S_Middle_Name,'')+' '+B.S_Last_Name as ScheduledFaculty 
	from T_TimeTable_Faculty_Map A
	inner join T_Employee_Dtls B on A.I_Employee_ID=B.I_Employee_ID and A.B_Is_Actual=0
) SF on TTTM.I_TimeTable_ID=SF.I_TimeTable_ID
LEFT JOIN
(
	select A.I_TimeTable_ID,B.S_First_Name+' '+ISNULL(B.S_Middle_Name,'')+' '+B.S_Last_Name as ActualFaculty 
	from T_TimeTable_Faculty_Map A
	inner join T_Employee_Dtls B on A.I_Employee_ID=B.I_Employee_ID and A.B_Is_Actual=1
) AF on TTTM.I_TimeTable_ID=AF.I_TimeTable_ID
where TCHND.I_Center_ID in (select FG.centerID from fnGetCentersForReports(@sHierarchyListID,@BrandID) FG) and 
(TTTM.Dt_Schedule_Date>=@dtStartDate and TTTM.Dt_Schedule_Date<DATEADD(d,1,@dtEndDate))
and TTTM.I_Status=1

end
