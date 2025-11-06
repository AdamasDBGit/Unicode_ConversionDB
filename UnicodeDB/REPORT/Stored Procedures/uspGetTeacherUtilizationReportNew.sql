CREATE PROCEDURE [REPORT].[uspGetTeacherUtilizationReportNew]
(
@BrandID INT,
@sHierarchyListID VARCHAR(MAX),
@dtStartDate DATETIME,
@dtEndDate DATETIME
)
as
begin

create table #CentreAllottment
(
CentreID int,
CenterName Varchar(max),
AllottedClass int
)

insert into #CentreAllottment
 select 2,'Coochbehar',6
insert into #CentreAllottment
 select 3,'Siliguri',5
insert into #CentreAllottment
 select 4,'Malda',6
insert into #CentreAllottment
 select 5,'Berhampore',6
insert into #CentreAllottment
 select 7,'Asansol',6
insert into #CentreAllottment
 select 8,'Kharagpur',6
insert into #CentreAllottment
 select 9,'Tamluk',6
insert into #CentreAllottment
 select 10,'Howrah Maidan',6
insert into #CentreAllottment
 select 11,'Durgapur',6
insert into #CentreAllottment
 select 12,'Burdwan',6
insert into #CentreAllottment
 select 14,'Midnapore',6
insert into #CentreAllottment
 select 15,'Behala',6
insert into #CentreAllottment
 select 16,'Sonarpur',6
insert into #CentreAllottment
 select 17,'Barasat',5
insert into #CentreAllottment
 select 18,'Sealdah',5
insert into #CentreAllottment
 select 19,'Belghoria (HO)',5
insert into #CentreAllottment
 select 87,'RICE_Barasat',6


select F1.Dt_Schedule_Date,ScheduledDay,F1.I_Center_ID,F1.S_Center_Name,
F1.ScheduledFaculty,F1.AllottedClass,F1.ScheduledClassCount,F1.ActualClassCount,
ROUND((CAST(F1.ScheduledClassCount AS DECIMAL(14,2))/CAST(F1.AllottedClass AS DECIMAL(14,2)))*100,0) as PercUtilization
from
(
	select FMASTER.Dt_Schedule_Date,FMASTER.ScheduledDay,FMASTER.I_Center_ID,FMASTER.S_Center_Name,CA.AllottedClass,
	FMASTER.ScheduledFaculty,SUM(ISNULL(FMASTER.ClassScheduled,0)) as ScheduledClassCount,
	SUM(ISNULL(FMASTER.ClassTaken,0)) as ActualClassCount
	from 
	(
		select T1.I_Center_ID,T1.S_Center_Name,T1.Dt_Schedule_Date,DATENAME(DW,T1.Dt_Schedule_Date) as ScheduledDay,ScheduledFaculty,ActualFaculty,
		CASE WHEN T1.ScheduledFaculty=ISNULL(T1.ActualFaculty,'') THEN 1 ELSE 0 END as ClassTaken,
		1 as ClassScheduled
		--(CAST(CASE WHEN T1.ScheduledFaculty=ISNULL(T1.ActualFaculty,'') THEN 1 ELSE 0 END as DECIMAL(14,2))/1)*100 as PercUtilization
		from
		(
			select TCHND.I_Center_ID,TCHND.S_Center_Name,TTM.Dt_Schedule_Date,
			CASE WHEN SF.ScheduledFaculty is null THEN AF.ActualFaculty ELSE SF.ScheduledFaculty END AS ScheduledFaculty,
			AF.ActualFaculty as ActualFaculty,
			CASE WHEN TTM.I_Session_ID is null THEN TTM.S_Session_Topic ELSE TESM.S_Skill_Desc END AS SubjectName
			from T_TimeTable_Master TTM
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
			inner join T_Center_Hierarchy_Name_Details TCHND on TCHND.I_Center_ID=TTM.I_Center_ID
			where
			TCHND.I_Center_ID in (select FG.centerID from fnGetCentersForReports(@sHierarchyListID,@BrandID) FG)
			and (TTM.Dt_Schedule_Date>=@dtStartDate and TTM.Dt_Schedule_Date<DATEADD(d,1,@dtEndDate))
		) T1
		where T1.ScheduledFaculty is not null
	) FMASTER
	INNER JOIN #CentreAllottment CA on CA.CentreID=FMASTER.I_Center_ID
	group by FMASTER.Dt_Schedule_Date,FMASTER.ScheduledDay,FMASTER.I_Center_ID,FMASTER.S_Center_Name,CA.AllottedClass,
	FMASTER.ScheduledFaculty
) F1
order by F1.Dt_Schedule_Date,F1.S_Center_Name,F1.ScheduledFaculty


drop table #CentreAllottment

end
