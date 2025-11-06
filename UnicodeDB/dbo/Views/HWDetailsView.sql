




CREATE VIEW [dbo].[HWDetailsView]
AS
select TX.S_Center_Name,TX.S_Course_Name,TX.I_Batch_ID,TX.S_Batch_Name,(TX.Age/30) as Age,
TX.S_Session_Name,
DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2) as ScheduleMonth,
DATENAME(d,TX.Dt_Schedule_Date)+'-'+DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2) AS ScheduledDate,
ATN.BatchStrength,ATN.Attended,TX.HWSubmitCount, 
(CAST(SUM(ATN.Attended) AS DECIMAL(14,2))/CAST(SUM(ATN.BatchStrength) AS DECIMAL(14,2))) as AttnPercentage,
CASE WHEN CAST(SUM(ATN.Attended) AS DECIMAL(14,2))>0 THEN (CAST(SUM(TX.HWSubmitCount) AS DECIMAL(14,2))/CAST(SUM(ATN.Attended) AS DECIMAL(14,2)))
ELSE 0 END as HWPercentage,
'D14' as RangeType
from
(
	select TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()) as Age,
	TSM.I_Session_ID,
	TSM.S_Session_Name,TTTM.Dt_Schedule_Date,COUNT(DISTINCT TSD.S_Student_ID) AS HWSubmitCount
	from T_TimeTable_Master TTTM
	inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TTTM.I_Center_ID
	inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTTM.I_Batch_ID
	inner join T_Session_Master TSM on TTTM.I_session_ID=TSM.I_Session_ID
	inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
	LEFT join EXAMINATION.T_Homework_Master THM on THM.I_session_ID=TTTM.I_Session_ID and THM.I_Batch_ID=TTTM.I_Batch_ID
	LEFT JOIN EXAMINATION.T_Homework_Submission THS on THM.I_Homework_ID=THS.I_Homework_ID and THS.I_Status=1
	LEFT JOIN T_Student_Detail TSD on THS.I_Student_Detail_ID=TSD.I_Student_Detail_ID and THS.I_Status=1
	where TCHND.I_Brand_ID=109 --and TSBM.S_Batch_Code='GCGEN2021063'
	and 
	(TTTM.Dt_Schedule_Date>=DATEADD(d,-14,CONVERT(DATE,GETDATE()))
	--TTTM.Dt_Schedule_Date>=DATEADD(dd, 0,
 --                          DATEDIFF(dd, 0,
 --                                   DATEADD(mm,
 --                                           -( ( ( 12 + DATEPART(m, DATEADD(d,-14,GETDATE())) )
 --                                                - 4 ) % 12 ), DATEADD(d,-14,GETDATE()))
 --                                   - DATEPART(d,
 --                                              DATEADD(mm,
 --                                                      -( ( ( 12 + DATEPART(m,
 --                                                             DATEADD(d,-14,GETDATE())) ) - 4 )
 --                                                         % 12 ), DATEADD(d,-14,GETDATE())))
 --                                   + 1))
									and TTTM.Dt_Schedule_Date<=DATEADD(d,-14,CONVERT(DATE,GETDATE())))
	group by TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()),
	TSM.I_Session_ID,TSM.S_Session_Name,TTTM.Dt_Schedule_Date
) TX
LEFT JOIN
(
select
TTM.I_TimeTable_ID,
TSBM.I_Batch_ID,
TSM.I_Session_ID,
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
inner JOIN T_Session_Master TSM on TTM.I_Session_ID=TSM.I_Session_ID
inner JOIN T_EOS_Skill_Master TESM on TSM.I_Skill_ID=TESM.I_Skill_ID
left join
(
select A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name,COUNT(DISTINCT TSA.I_Student_Detail_ID) as ATTENDED 
from T_Student_Attendance TSA
inner join T_TimeTable_Master A on TSA.I_TimeTable_ID=A.I_TimeTable_ID and A.I_Batch_ID is not null
inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and TCHND.I_Brand_ID=109 and TSD.I_Status=1
group by
TTM.I_TimeTable_ID,
TSBM.I_Batch_ID,
TSM.I_Session_ID,
ISNULL(T2.ATTENDED,0)
) ATN ON TX.I_Session_ID=ATN.I_Session_ID and TX.I_Batch_ID=ATN.I_Batch_ID
group by TX.S_Center_Name,TX.S_Course_Name,TX.I_Batch_ID,TX.S_Batch_Name,(TX.Age/30),TX.S_Session_Name,
DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2),
DATENAME(d,TX.Dt_Schedule_Date)+'-'+DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2),
ATN.BatchStrength,ATN.Attended,TX.HWSubmitCount

UNION ALL


select TX.S_Center_Name,TX.S_Course_Name,TX.I_Batch_ID,TX.S_Batch_Name,(TX.Age/30) as Age,
TX.S_Session_Name,
DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2) as ScheduleMonth,
DATENAME(d,TX.Dt_Schedule_Date)+'-'+DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2) AS ScheduledDate,
ATN.BatchStrength,ATN.Attended,TX.HWSubmitCount, 
(CAST(SUM(ATN.Attended) AS DECIMAL(14,2))/CAST(SUM(ATN.BatchStrength) AS DECIMAL(14,2))) as AttnPercentage,
CASE WHEN CAST(SUM(ATN.Attended) AS DECIMAL(14,2))>0 THEN (CAST(SUM(TX.HWSubmitCount) AS DECIMAL(14,2))/CAST(SUM(ATN.Attended) AS DECIMAL(14,2)))
ELSE 0 END as HWPercentage,
'YTD' as RangeType
from
(
	select TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()) as Age,
	TSM.I_Session_ID,
	TSM.S_Session_Name,TTTM.Dt_Schedule_Date,COUNT(DISTINCT TSD.S_Student_ID) AS HWSubmitCount
	from T_TimeTable_Master TTTM
	inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TTTM.I_Center_ID
	inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTTM.I_Batch_ID
	inner join T_Session_Master TSM on TTTM.I_session_ID=TSM.I_Session_ID
	inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
	LEFT join EXAMINATION.T_Homework_Master THM on THM.I_session_ID=TTTM.I_Session_ID and THM.I_Batch_ID=TTTM.I_Batch_ID
	LEFT JOIN EXAMINATION.T_Homework_Submission THS on THM.I_Homework_ID=THS.I_Homework_ID and THS.I_Status=1
	LEFT JOIN T_Student_Detail TSD on THS.I_Student_Detail_ID=TSD.I_Student_Detail_ID and THS.I_Status=1
	where TCHND.I_Brand_ID=109 --and TSBM.S_Batch_Code='GCGEN2021063'
	and 
	(--TTTM.Dt_Schedule_Date>=DATEADD(d,-14,CONVERT(DATE,GETDATE()))
	TTTM.Dt_Schedule_Date>=DATEADD(dd, 0,
                           DATEDIFF(dd, 0,
                                    DATEADD(mm,
                                            -( ( ( 12 + DATEPART(m, DATEADD(d,-14,GETDATE())) )
                                                 - 4 ) % 12 ), DATEADD(d,-14,GETDATE()))
                                    - DATEPART(d,
                                               DATEADD(mm,
                                                       -( ( ( 12 + DATEPART(m,
                                                              DATEADD(d,-14,GETDATE())) ) - 4 )
                                                          % 12 ), DATEADD(d,-14,GETDATE())))
                                    + 1))
									and TTTM.Dt_Schedule_Date<=DATEADD(d,-14,CONVERT(DATE,GETDATE())))
	group by TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()),
	TSM.I_Session_ID,TSM.S_Session_Name,TTTM.Dt_Schedule_Date
) TX
LEFT JOIN
(
select
TTM.I_TimeTable_ID,
TSBM.I_Batch_ID,
TSM.I_Session_ID,
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
inner JOIN T_Session_Master TSM on TTM.I_Session_ID=TSM.I_Session_ID
inner JOIN T_EOS_Skill_Master TESM on TSM.I_Skill_ID=TESM.I_Skill_ID
left join
(
select A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name,COUNT(DISTINCT TSA.I_Student_Detail_ID) as ATTENDED 
from T_Student_Attendance TSA
inner join T_TimeTable_Master A on TSA.I_TimeTable_ID=A.I_TimeTable_ID and A.I_Batch_ID is not null
inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and TCHND.I_Brand_ID=109 and TSD.I_Status=1
group by
TTM.I_TimeTable_ID,
TSBM.I_Batch_ID,
TSM.I_Session_ID,
ISNULL(T2.ATTENDED,0)
) ATN ON TX.I_Session_ID=ATN.I_Session_ID and TX.I_Batch_ID=ATN.I_Batch_ID
group by TX.S_Center_Name,TX.S_Course_Name,TX.I_Batch_ID,TX.S_Batch_Name,(TX.Age/30),TX.S_Session_Name,
DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2),
DATENAME(d,TX.Dt_Schedule_Date)+'-'+DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2),
ATN.BatchStrength,ATN.Attended,TX.HWSubmitCount


UNION ALL


select TX.S_Center_Name,TX.S_Course_Name,TX.I_Batch_ID,TX.S_Batch_Name,(TX.Age/30) as Age,
TX.S_Session_Name,
DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2) as ScheduleMonth,
DATENAME(d,TX.Dt_Schedule_Date)+'-'+DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2) AS ScheduledDate,
ATN.BatchStrength,ATN.Attended,TX.HWSubmitCount, 
(CAST(SUM(ATN.Attended) AS DECIMAL(14,2))/CAST(SUM(ATN.BatchStrength) AS DECIMAL(14,2))) as AttnPercentage,
CASE WHEN CAST(SUM(ATN.Attended) AS DECIMAL(14,2))>0 THEN (CAST(SUM(TX.HWSubmitCount) AS DECIMAL(14,2))/CAST(SUM(ATN.Attended) AS DECIMAL(14,2)))
ELSE 0 END as HWPercentage,
'MTD' as RangeType
from
(
	select TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()) as Age,
	TSM.I_Session_ID,
	TSM.S_Session_Name,TTTM.Dt_Schedule_Date,COUNT(DISTINCT TSD.S_Student_ID) AS HWSubmitCount
	from T_TimeTable_Master TTTM
	inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TTTM.I_Center_ID
	inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTTM.I_Batch_ID
	inner join T_Session_Master TSM on TTTM.I_session_ID=TSM.I_Session_ID
	inner join T_Course_Master TCM on TSBM.I_Course_ID=TCM.I_Course_ID
	LEFT join EXAMINATION.T_Homework_Master THM on THM.I_session_ID=TTTM.I_Session_ID and THM.I_Batch_ID=TTTM.I_Batch_ID
	LEFT JOIN EXAMINATION.T_Homework_Submission THS on THM.I_Homework_ID=THS.I_Homework_ID and THS.I_Status=1
	LEFT JOIN T_Student_Detail TSD on THS.I_Student_Detail_ID=TSD.I_Student_Detail_ID and THS.I_Status=1
	where TCHND.I_Brand_ID=109 --and TSBM.S_Batch_Code='GCGEN2021063'
	and 
	(--TTTM.Dt_Schedule_Date>=DATEADD(d,-14,CONVERT(DATE,GETDATE()))
		MONTH(TTTM.Dt_Schedule_Date)=MONTH(DATEADD(d,-14,CONVERT(DATE,GETDATE()))) 
		and YEAR(TTTM.Dt_Schedule_Date)=YEAR(DATEADD(d,-14,CONVERT(DATE,GETDATE())))
		and CONVERT(DATE,TTTM.Dt_Schedule_Date)<=DATEADD(d,-14,CONVERT(DATE,GETDATE()))
	)
	group by TCHND.I_Center_ID,TCHND.S_Center_Name,TCM.I_Course_ID,TCM.S_Course_Name,TSBM.I_Batch_ID,TSBM.S_Batch_Name,
	DATEDIFF(d,ISNULL(TSBM.Dt_MBatchStartDate,TSBM.Dt_BatchStartDate),GETDATE()),
	TSM.I_Session_ID,TSM.S_Session_Name,TTTM.Dt_Schedule_Date
) TX
LEFT JOIN
(
select
TTM.I_TimeTable_ID,
TSBM.I_Batch_ID,
TSM.I_Session_ID,
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
inner JOIN T_Session_Master TSM on TTM.I_Session_ID=TSM.I_Session_ID
inner JOIN T_EOS_Skill_Master TESM on TSM.I_Skill_ID=TESM.I_Skill_ID
left join
(
select A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name,COUNT(DISTINCT TSA.I_Student_Detail_ID) as ATTENDED 
from T_Student_Attendance TSA
inner join T_TimeTable_Master A on TSA.I_TimeTable_ID=A.I_TimeTable_ID and A.I_Batch_ID is not null
inner join T_Student_Batch_Master B on A.I_Batch_ID=B.I_Batch_ID
group by A.I_TimeTable_ID,A.I_Batch_ID,B.S_Batch_Name--,CONVERT(DATE,A.Dt_Schedule_Date)
) T2 on TTM.I_TimeTable_ID=T2.I_TimeTable_ID --and T1.AttendanceDate=T2.AttendedDate
where 
TTM.I_Status=1 --and TSD.I_Student_Detail_ID=95552
and TCHND.I_Brand_ID=109 and TSD.I_Status=1
group by
TTM.I_TimeTable_ID,
TSBM.I_Batch_ID,
TSM.I_Session_ID,
ISNULL(T2.ATTENDED,0)
) ATN ON TX.I_Session_ID=ATN.I_Session_ID and TX.I_Batch_ID=ATN.I_Batch_ID
group by TX.S_Center_Name,TX.S_Course_Name,TX.I_Batch_ID,TX.S_Batch_Name,(TX.Age/30),TX.S_Session_Name,
DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2),
DATENAME(d,TX.Dt_Schedule_Date)+'-'+DATENAME(m,TX.Dt_Schedule_Date)+'-'+SUBSTRING(DATENAME(yyyy,TX.Dt_Schedule_Date),3,2),
ATN.BatchStrength,ATN.Attended,TX.HWSubmitCount