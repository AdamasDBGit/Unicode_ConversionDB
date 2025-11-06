

CREATE VIEW [dbo].[GetAttendanceDataD2]
AS
select CONVERT(DATE,TTM.Dt_Schedule_Date) as AttendanceDate,
TCHND.I_Center_ID,
TCHND.S_Center_Name,
TCM.I_Course_ID,
TCM.S_Course_Name,
TSBM.I_Batch_ID,
TSBM.S_Batch_Name,
TSBM.Dt_BatchStartDate,
TTM.I_TimeTable_ID,
CASE WHEN TTM.I_Session_ID is null THEN 'NO' else 'YES' end as IsScheduledClass,
CASE WHEN TTM.I_ClassType=1 THEN 'Offline'
	 WHEN TTM.I_ClassType=2 THEN 'Online'
	 WHEN TTM.I_ClassType=3 OR TTM.I_ClassType IS NULL THEN 'N/A'
END AS ClassType,
DATEDIFF(d,TSBM.Dt_BatchStartDate,TTM.Dt_Schedule_Date) as Age,
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END AS ScheduledFaculty,
AF.ActualFaculty as ActualFaculty,
--TESM.S_Skill_Desc,
ISNULL(T2.ATTENDED,0) AS Attended,
COUNT(DISTINCT TSD.S_Student_ID) as BatchStrength
from T_TimeTable_Master TTM
inner join T_Student_Batch_Master TSBM on TTM.I_Batch_ID=TSBM.I_Batch_ID
inner join T_Student_Batch_Details TSBD on TTM.I_Batch_ID=TSBD.I_Batch_ID and TSBD.I_Status in (1,0,2)
											and CONVERT(DATE,TSBD.Dt_Valid_From)<=CONVERT(DATE,TTM.Dt_Schedule_Date)
											and CONVERT(DATE,ISNULL(TSBD.Dt_Valid_To,GETDATE()))>=CONVERT(DATE,TTM.Dt_Schedule_Date)
inner join T_Student_Detail TSD on TSBD.I_Student_ID=TSD.I_Student_Detail_ID
inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TTM.I_Center_ID
inner join T_Course_Master TCM on TCM.I_Course_ID=TSBM.I_Course_ID
LEFT JOIN T_Session_Master TSM on TTM.I_Session_ID=TSM.I_Session_ID
LEFT JOIN T_EOS_Skill_Master TESM on TSM.I_Skill_ID=TESM.I_Skill_ID
LEFT JOIN
(
select A.I_TimeTable_ID,B.S_First_Name+' '+ISNULL(B.S_Middle_Name,'')+' '+B.S_Last_Name as ScheduledFaculty 
from T_TimeTable_Faculty_Map A
inner join T_Employee_Dtls B on A.I_Employee_ID=B.I_Employee_ID and A.B_Is_Actual=0
) SF on TTM.I_TimeTable_ID=SF.I_TimeTable_ID
LEFT JOIN
(
select A.I_TimeTable_ID,B.S_First_Name+' '+ISNULL(B.S_Middle_Name,'')+' '+B.S_Last_Name as ActualFaculty 
from T_TimeTable_Faculty_Map A
inner join T_Employee_Dtls B on A.I_Employee_ID=B.I_Employee_ID and A.B_Is_Actual=1
) AF on TTM.I_TimeTable_ID=AF.I_TimeTable_ID
left join
(
select A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name,COUNT(DISTINCT TSA.I_Student_Detail_ID) as ATTENDED 
from T_Student_Attendance TSA
inner join T_TimeTable_Master A on TSA.I_TimeTable_ID=A.I_TimeTable_ID and A.I_Batch_ID is not null
inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
where
(A.Dt_Schedule_Date>=DATEADD(d,-2,GETDATE()) and A.Dt_Schedule_Date<DATEADD(d,-1,GETDATE()))
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and (TTM.Dt_Schedule_Date>=DATEADD(d,-2,GETDATE()) and TTM.Dt_Schedule_Date<DATEADD(d,-1,GETDATE()) )
--and TSBM.I_Batch_ID=10055
and TCHND.I_Brand_ID=109
group by
CONVERT(DATE,TTM.Dt_Schedule_Date),
TCHND.I_Center_ID,
TCHND.S_Center_Name,
TCM.I_Course_ID,
TCM.S_Course_Name,
TSBM.I_Batch_ID,
TSBM.S_Batch_Name,
TSBM.Dt_BatchStartDate,
TTM.I_TimeTable_ID,
CASE WHEN TTM.I_Session_ID is null THEN 'NO' else 'YES' end,
CASE WHEN TTM.I_ClassType=1 THEN 'Offline'
	 WHEN TTM.I_ClassType=2 THEN 'Online'
	 WHEN TTM.I_ClassType=3 OR TTM.I_ClassType IS NULL THEN 'N/A'
END,
DATEDIFF(d,TSBM.Dt_BatchStartDate,TTM.Dt_Schedule_Date),
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END,
AF.ActualFaculty,
--TESM.S_Skill_Desc,
ISNULL(T2.ATTENDED,0)