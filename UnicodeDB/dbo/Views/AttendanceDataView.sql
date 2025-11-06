CREATE VIEW [dbo].[AttendanceDataView] AS

select T1.*,ISNULL(T2.AttendedStudents,0) as AttendedStudents,T1.S_Center_Name as Centre,DATEDIFF(m,T1.Dt_BatchStartDate,GETDATE()) as Age,YEAR(T1.Dt_Schedule_Date) as AttendanceYear,
MONTH(T1.Dt_Schedule_Date) as AttendanceMonth
from
(
select A.I_TimeTable_ID,A.Dt_Schedule_Date,B.S_Center_Name,C.S_Batch_Name,C.Dt_BatchStartDate,ISNULL(E.S_Skill_Desc,'NA') as SubjectName,
H.S_First_Name+' '+ISNULL(H.S_Middle_Name,'')+' '+H.S_Last_Name as FacultyName,
COUNT(DISTINCT F.I_Student_ID) as BatchStrength
from T_TimeTable_Master A
inner join T_Center_Hierarchy_Name_Details B on A.I_Center_ID=B.I_Center_ID
inner join T_Student_Batch_Master C on A.I_Batch_ID=C.I_Batch_ID
left join T_Session_Master D on A.I_Session_ID=D.I_Session_ID
left join T_EOS_Skill_Master E on D.I_Skill_ID=E.I_Skill_ID
left join T_Student_Batch_Details F on A.I_Batch_ID=F.I_Batch_ID and F.I_Status=1
inner join T_TimeTable_Faculty_Map G on A.I_TimeTable_ID=G.I_TimeTable_ID and G.B_Is_Actual=1
inner join T_Employee_Dtls H on G.I_Employee_ID=H.I_Employee_ID
where A.I_Status=1 and A.Dt_Schedule_Date>='2021-01-01'
group by A.I_TimeTable_ID,A.Dt_Schedule_Date,B.S_Center_Name,C.S_Batch_Name,C.Dt_BatchStartDate,ISNULL(E.S_Skill_Desc,'NA'),
H.S_First_Name+' '+ISNULL(H.S_Middle_Name,'')+' '+H.S_Last_Name
) T1
left join
(
select TTM.I_Batch_ID,Dt_Schedule_Date,TTM.I_TimeTable_ID,COUNT(DISTINCT TSA.I_Student_Detail_ID) as AttendedStudents 
from T_TimeTable_Master TTM
inner join T_Student_Attendance TSA on TTM.I_TimeTable_ID=TSA.I_TimeTable_ID
where TTM.I_Status=1 and TTM.Dt_Schedule_Date>='2021-01-01'
group by TTM.I_Batch_ID,Dt_Schedule_Date,TTM.I_TimeTable_ID
) T2 on T1.I_TimeTable_ID=T2.I_TimeTable_ID