













CREATE VIEW [dbo].[GetAttendanceDataTeacherwise]
AS

select ATTN.I_Center_ID,ATTN.S_Center_Name,ATTN.I_Course_ID,ATTN.S_Course_Name,ATTN.I_Batch_ID,
REPLACE(REPLACE(REPLACE(ATTN.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') as S_Batch_Name,
(ATTN.Age/30) as Age,
ISNULL(ATTN.ActualFaculty,'-') as ActualFaculty,
ISNULL(ATTN.SubjectName,'N/A') as SubjectName,
ATTN.ClassType,ATTN.RangeType,
ISNULL(TADMM.IsExamBatch,'-') As IsExamBatch,
ISNULL(TADMM.IsFocusedBatch,'-') As IsFocusedBatch,
ISNULL(TADMM.IsMergedBatch,'-') As IsMergedBatch,
ATTN.IsScheduledClass,
--REPLACE(REPLACE(REPLACE(ATTN.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '')+' ('+ATTN.S_Center_Name+')' as BatchFilter,
SUM(ATTN.Attended) as Attended,
SUM(ATTN.BatchStrength) AS BatchStrength,
(CAST(SUM(ATTN.Attended) AS DECIMAL(14,2))/CAST(SUM(ATTN.BatchStrength) AS DECIMAL(14,2))) as AttnPercentage
from
(


--DTD DATA

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
DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()) as Age,
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END AS ScheduledFaculty,
AF.ActualFaculty as ActualFaculty,
TESM.S_Skill_Desc as SubjectName,
ISNULL(T2.ATTENDED,0) AS Attended,
COUNT(DISTINCT TSD.S_Student_ID) as BatchStrength,
'DTD' as RangeType
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
(A.Dt_Schedule_Date>=DATEADD(d,-2,CONVERT(DATE,GETDATE())) and A.Dt_Schedule_Date<=DATEADD(d,-2,CONVERT(DATE,GETDATE())))
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and (TTM.Dt_Schedule_Date>=DATEADD(d,-2,CONVERT(DATE,GETDATE())) and TTM.Dt_Schedule_Date<=DATEADD(d,-2,CONVERT(DATE,GETDATE())) )
--and TSBM.I_Batch_ID=10055
and TCHND.I_Brand_ID=109 and TSD.I_Status=1
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
DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()),
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END,
AF.ActualFaculty,
TESM.S_Skill_Desc,
ISNULL(T2.ATTENDED,0)

UNION ALL


--MTD DATA

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
DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()) as Age,
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END AS ScheduledFaculty,
AF.ActualFaculty as ActualFaculty,
TESM.S_Skill_Desc as SubjectName,
ISNULL(T2.ATTENDED,0) AS Attended,
COUNT(DISTINCT TSD.S_Student_ID) as BatchStrength,
'MTD' as RangeType
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
(
MONTH(A.Dt_Schedule_Date)=MONTH(DATEADD(d,-2,CONVERT(DATE,GETDATE()))) 
and YEAR(A.Dt_Schedule_Date)=YEAR(DATEADD(d,-2,CONVERT(DATE,GETDATE())))
and CONVERT(DATE,A.Dt_Schedule_Date)<=DATEADD(d,-2,CONVERT(DATE,GETDATE()))
)
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and (
MONTH(TTM.Dt_Schedule_Date)=MONTH(DATEADD(d,-2,CONVERT(DATE,GETDATE()))) 
and YEAR(TTM.Dt_Schedule_Date)=YEAR(DATEADD(d,-2,CONVERT(DATE,GETDATE())))
and CONVERT(DATE,TTM.Dt_Schedule_Date)<=DATEADD(d,-2,CONVERT(DATE,GETDATE()))
)
--and TSBM.I_Batch_ID=10055
and TCHND.I_Brand_ID=109 and TSD.I_Status=1
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
DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()),
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END,
AF.ActualFaculty,
TESM.S_Skill_Desc,
ISNULL(T2.ATTENDED,0)

UNION ALL

--YTD

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
DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()) as Age,
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END AS ScheduledFaculty,
AF.ActualFaculty as ActualFaculty,
TESM.S_Skill_Desc as SubjectName,
ISNULL(T2.ATTENDED,0) AS Attended,
COUNT(DISTINCT TSD.S_Student_ID) as BatchStrength,
'YTD' as RangeType
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
(A.Dt_Schedule_Date>=DATEADD(dd, 0,
                           DATEDIFF(dd, 0,
                                    DATEADD(mm,
                                            -( ( ( 12 + DATEPART(m, DATEADD(d,-2,GETDATE())) )
                                                 - 4 ) % 12 ), DATEADD(d,-2,GETDATE()))
                                    - DATEPART(d,
                                               DATEADD(mm,
                                                       -( ( ( 12 + DATEPART(m,
                                                              DATEADD(d,-2,GETDATE())) ) - 4 )
                                                          % 12 ), DATEADD(d,-2,GETDATE())))
                                    + 1))
									and A.Dt_Schedule_Date<=DATEADD(d,-2,CONVERT(DATE,GETDATE())))
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and (TTM.Dt_Schedule_Date>=DATEADD(dd, 0,
                           DATEDIFF(dd, 0,
                                    DATEADD(mm,
                                            -( ( ( 12 + DATEPART(m, DATEADD(d,-2,GETDATE())) )
                                                 - 4 ) % 12 ), DATEADD(d,-2,GETDATE()))
                                    - DATEPART(d,
                                               DATEADD(mm,
                                                       -( ( ( 12 + DATEPART(m,
                                                              DATEADD(d,-2,GETDATE())) ) - 4 )
                                                          % 12 ), DATEADD(d,-2,GETDATE())))
                                    + 1))
									and TTM.Dt_Schedule_Date<=DATEADD(d,-2,CONVERT(DATE,GETDATE())))
--and TSBM.I_Batch_ID=10055
and TCHND.I_Brand_ID=109 and TSD.I_Status=1
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
DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()),
CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END,
AF.ActualFaculty,
TESM.S_Skill_Desc,
ISNULL(T2.ATTENDED,0)


) ATTN
LEFT JOIN T_AttendanceDataMapping_Manual TADMM on UPPER(ATTN.S_Center_Name)=UPPER(TADMM.Centre)
												and UPPER(ATTN.S_Batch_Name)=UPPER(TADMM.Batch)
WHERE ATTN.I_Batch_ID NOT IN
(
	select BatchID from T_Batch_Exceptions 
)
group by ATTN.I_Center_ID,ATTN.S_Center_Name,ATTN.I_Course_ID,ATTN.S_Course_Name,ATTN.I_Batch_ID,
REPLACE(REPLACE(REPLACE(ATTN.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''),
(ATTN.Age/30),
ISNULL(ATTN.ActualFaculty,'-'),
ISNULL(ATTN.SubjectName,'N/A'),
ATTN.ClassType,ATTN.RangeType,ISNULL(TADMM.IsExamBatch,'-'),ISNULL(TADMM.IsFocusedBatch,'-'),
ISNULL(TADMM.IsMergedBatch,'-'),
ATTN.IsScheduledClass
--order by ATTN.I_Center_ID,ATTN.S_Center_Name,ATTN.I_Batch_ID,ATTN.S_Batch_Name,ATTN.ClassType,ATTN.RangeType