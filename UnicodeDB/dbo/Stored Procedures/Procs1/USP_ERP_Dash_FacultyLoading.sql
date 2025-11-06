--exec USP_ERP_Dash_FacultyLoading 107,35
CREATE Proc [dbo].[USP_ERP_Dash_FacultyLoading](    
@BrandID int    
,@sessionID int=null    
)    
as begin   
----Current Date Time  
DECLARE @currentDateTime DATETIME = GETDATE();        
DECLARE @currentDate DATE = CAST(@currentDateTime AS DATE);        
DECLARE @currentTime TIME(0) = CAST(@currentDateTime AS TIME);        
        
SELECT Convert(varchar(20),@currentDate) AS CurrentDate, CONVERT(varchar(10), @currentTime) AS CurrentTime;    
  
---------------  
Declare @totalclassToday int,@TakenClassToday int    
select @totalclassToday=count(RSD.I_Routine_Structure_Detail_ID)    
    
from T_ERP_Routine_Structure_Detail RSD    
Inner Join T_ERP_Student_Class_Routine SCR     
on SCR.I_Routine_Structure_Detail_ID=RSD.I_Routine_Structure_Detail_ID    
Inner Join T_Week_Day_Master WDM on WDM.I_Day_ID=RSD.I_Day_ID    
Inner Join T_ERP_Routine_Structure_Header RSH     
on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID    
Inner Join T_School_Academic_Session_Master ASM     
on ASM.I_School_Session_ID=RSH.I_School_Session_ID    
    
where  WDM.S_Day_Name=DATENAME(WEEKDAY, GETDATE())  and RSH.I_School_Session_ID=@sessionID    
and ASM.I_Brand_ID=@BrandID    
    
select @TakenClassToday=count(RSD.I_Routine_Structure_Detail_ID)    
    
from T_ERP_Routine_Structure_Detail RSD    
Inner Join T_ERP_Student_Class_Routine SCR     
on SCR.I_Routine_Structure_Detail_ID=RSD.I_Routine_Structure_Detail_ID    
Inner Join T_Week_Day_Master WDM on WDM.I_Day_ID=RSD.I_Day_ID    
Inner Join T_ERP_Routine_Structure_Header RSH     
on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID    
Inner Join T_School_Academic_Session_Master ASM     
on ASM.I_School_Session_ID=RSH.I_School_Session_ID     
Inner join T_ERP_Attendance_Entry_Header AEH     
on AEH.I_Student_Class_Routine_ID=SCR.I_Student_Class_Routine_ID    
    
where  WDM.S_Day_Name=DATENAME(WEEKDAY, GETDATE())  and RSH.I_School_Session_ID=@sessionID    
and ASM.I_Brand_ID=@BrandID and convert(date,AEH.Dt_Date)=CONVERT(date,getdate())    
Select @totalclassToday as TodaysTotalClass,@TakenClassToday Todays_takenClass    
-----------------------Log added Today----------------------  
CREATE table #RoutineWiseLogBook  
 (  
 BrandID int,  
 BrandName varchar(max),  
 RoutineStructureHeaderID INT,  
 TotalNoofPeriods INT,  
 RoutineSlotStart time,  
 RoutineDuration time,  
 PeriodGap time,  
 SchoolGroupID INT,  
 SchoolGroupName varchar(max),  
 ClassID INT,  
 ClassName varchar(max),  
 SectionID INT,  
 SectionName varchar(max),  
 SubjectID int,  
 SubjectName varchar(max),  
 RoutineStructureDetailID INT,  
 PeriodNo INT,  
 PeriodStart time,  
 PeriodEnd time,  
 ClassDayID INT,  
 ClassDayName varchar(max),  
 StudentClassRoutineID INT,  
 )  
  
 insert into #RoutineWiseLogBook  
 select   
 BM.I_Brand_ID as BrandID,  
 BM.S_Brand_Name as BrandName,  
 RSH.I_Routine_Structure_Header_ID as RoutineStructureHeaderID,  
 RSH.I_Total_Periods as TotalNoofPeriods,  
 RSH.T_Start_Slot as RoutineSlotStart,  
 RSH.T_Duration as RoutineDuration,  
 RSH.T_Period_Gap as PeriodGap,  
 ISNULL(SG.I_School_Group_ID,0) as SchoolGroupID,  
 ISNULL(SG.S_School_Group_Name,'NA') as SchoolGroupName,  
 ISNULL(C.I_Class_ID,0) as ClassID,  
 ISNULL(C.S_Class_Name,'NA') as ClassName,  
 ISNULL(S.I_Section_ID,0) as SectionID,  
 ISNULL(S.S_Section_Name,'--') as SectionName,  
 SM.I_Subject_ID as SubjectID,  
 SM.S_Subject_Name as SubjectName,  
 RSD.I_Routine_Structure_Detail_ID as RoutineStructureDetailID,  
 RSD.I_Period_No as PeriodNo,  
 RSD.T_FromSlot as PeriodStart,  
 RSD.T_ToSlot as PeriodEnd,  
 WDM.I_Day_ID as ClassDayID,  
 WDM.S_Day_Name as ClassDayName,  
 SCR.I_Student_Class_Routine_ID as StudentClassRoutineID  
   
 from  
 T_ERP_Routine_Structure_Header as RSH  
 inner join  
 T_ERP_Routine_Structure_Detail as RSD on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID  
 inner join  
 T_ERP_Student_Class_Routine as SCR on SCR.I_Routine_Structure_Detail_ID=RSD.I_Routine_Structure_Detail_ID  
 inner join  
 T_School_Group SG on SG.I_School_Group_ID=RSH.I_School_Group_ID  
 inner join  
 T_School_Group_Class as SGC on SGC.I_School_Group_ID=SG.I_School_Group_ID and SGC.I_Class_ID=RSH.I_Class_ID  
 inner join  
 T_Class as C on C.I_Class_ID=SGC.I_Class_ID and C.I_Class_ID=RSH.I_Class_ID  
 inner join  
 T_Week_Day_Master as WDM on WDM.I_Day_ID=RSD.I_Day_ID  
 inner join  
 T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID  
 inner join  
 T_Brand_Master as BM on BM.I_Brand_ID=SM.I_Brand_ID  
 left join  
 T_Section as S on S.I_Section_ID=RSH.I_Section_ID  
  
 where  RSH.I_School_Session_ID=@sessionID  
   
 and SM.I_Brand_ID=@brandID   
 And WDM.S_Day_Name=DATENAME(WEEKDAY, GETDATE())   
 --drop table #RoutineWiseLogBook  
 --select * from #RoutineWiseLogBook  
 select maintemp.PeriodNo  
 --, Maintemp.ClassName,Maintemp.SectionName,Maintemp.SubjectName  
 --,case when Att.Dt_Date is not null   
 --then  1 else 0 end as Isattendance  
 --,Logbook.LookBookID,Logbook.ClassExecutedDate,Logbook.CompletionPercentage  
 ,Case when  I_Teacher_Time_Plan_ID Is not null Then 1 else 0 end as Logid  
 --,Case When  CRW.Dt_Date IS not null Then 1 Else 0 end Classwork  
 --, 0 as Homework  
 Into #CountLog  
 from #RoutineWiseLogBook Maintemp  
 Left Join T_ERP_Attendance_Entry_Header Att   
 on Att.I_Student_Class_Routine_ID=Maintemp.StudentClassRoutineID  
 and  convert(date,Dt_Date)=CONVERT(date,getdate())  
  --Left join  
  -- (  
  -- select TTP.I_Teacher_Time_Plan_ID as LookBookID,  
  -- TTP.Dt_Plan_Date as ClassDate,SSP.I_Subject_Structure_Plan_ID as SubjectStructurePlanID,  
  -- TTP.I_Student_Class_Routine_ID as StudentClassRoutineID,SSP.I_Day_No as LessionPlanDayNo,  
  -- SSP.I_Month_No as LessionPlanMonthno,SSPER.I_Completion_Percentage as CompletionPercentage,SSPER.S_Remarks as Remarks  
  -- ,SSPER.Dt_ExecutedAt as ClassExecutedDate  
  -- from T_ERP_Teacher_Time_Plan as TTP   
  -- inner join  
  -- T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID  
  -- inner join  
  -- T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID  
  -- left join  
  -- T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER   
  -- on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID  
     
  -- ) as Logbook on   
  -- Logbook.StudentClassRoutineID=Maintemp.StudentClassRoutineID  
     
  Left Join T_ERP_Teacher_Time_Plan TTP   
  ON TTP.I_Student_Class_Routine_ID=Maintemp.StudentClassRoutineID  
  and convert(date,TTP.Dt_Class_Date)=CONVERT(date,getdate())  
  Left Join T_ERP_Student_Class_Routine_Work CRW   
  on CRW.I_Student_Class_Routine_ID=Maintemp.StudentClassRoutineID  
  and Convert(Date,CRW.Dt_Date)=Convert(date,GETDATE())  
 order by Maintemp.PeriodNo,Maintemp.ClassID  
  
 Declare @TotalPeriod int,@TotalLog int  
  
 SET @TotalPeriod= (select COUNT(PeriodNo) from #CountLog)  
 SET @TotalLog =(select COUNT(Logid) from #CountLog where Logid =1)  
 Select @TotalPeriod as TotalPeriod ,@TotalLog TotalLogged  
 drop table #RoutineWiseLogBook  
 drop table #CountLog  

 ---------Top 5 Active Notification for Faculty   
Declare @NotificationTitle nvarchar(255),@NotificationDesc nvarchar(max)        

select ROW_NUMBER() OVER(ORDER BY NotificationTitle ASC) Sl_No,NotificationTitle,NotificationDesc,ApplicationForName from
(        
select ROW_NUMBER() OVER(ORDER BY nm.Notification_Title ASC) Sl_No, nm.Notification_Title as NotificationTitle, nm.Notification_Desc as NotificationDesc
,(case when nd.Notification_ApplicableForID=napl.I_NotificationApplicable_ID then napl.S_NotificationApplicable_Name else 'All' end) ApplicationForName
from T_ERP_NotificationMaster nm
inner join T_ERP_NotificationDetails nd on nm.Notification_ID=nd.Notification_ID
inner join T_School_Academic_Session_Master asm on nm.Notification_AcademicSessionID=asm.I_School_Session_ID
left join T_ERP_NotificationApplicable napl on nd.Notification_ApplicableForID=napl.I_NotificationApplicable_ID
left join T_Event_Category tec on nm.Notification_EventID=tec.I_Event_Category_ID
left join T_ERP_NotificationPriority np on nm.Notification_PriorityID=np.I_NotificationPriority_ID
left join T_ERP_NotificationDelivery ndm on nm.Notification_PriorityID=ndm.I_NotificationDelivery_ID
where nm.Notification_AcademicSessionID=@sessionID and nm.Notification_BrandID=@BrandID 
and ((napl.S_NotificationApplicable_Name like 'Academic%') OR (napl.S_NotificationApplicable_Name like '%Teacher%'))
--and nd.Notification_ApplicableForID=0
and nm.Notification_Date >= GETDATE() 
and nm.Is_Deleted=0

UNION ALL

select ROW_NUMBER() OVER(ORDER BY nm.Notification_Title ASC) Sl_No, nm.Notification_Title as NotificationTitle, nm.Notification_Desc as NotificationDesc
,(case when nd.Notification_ApplicableForID=napl.I_NotificationApplicable_ID then napl.S_NotificationApplicable_Name else 'All' end) ApplicationForName
from T_ERP_NotificationMaster nm
inner join T_ERP_NotificationDetails nd on nm.Notification_ID=nd.Notification_ID
inner join T_School_Academic_Session_Master asm on nm.Notification_AcademicSessionID=asm.I_School_Session_ID
--left join T_ERP_NotificationApplicable napl on nd.Notification_ApplicableForID=napl.I_NotificationApplicable_ID
left join T_ERP_NotificationApplicable napl on nd.Notification_ApplicableForID=0
left join T_Event_Category tec on nm.Notification_EventID=tec.I_Event_Category_ID
left join T_ERP_NotificationPriority np on nm.Notification_PriorityID=np.I_NotificationPriority_ID
left join T_ERP_NotificationDelivery ndm on nm.Notification_PriorityID=ndm.I_NotificationDelivery_ID
where nm.Notification_AcademicSessionID=@sessionID and nm.Notification_BrandID=@BrandID 
and ((napl.S_NotificationApplicable_Name like 'Academic%') OR (napl.S_NotificationApplicable_Name like '%Teacher%'))
--and nd.Notification_ApplicableForID=0
and nm.Notification_Date >= GETDATE() 
and nm.Is_Deleted=0
) as TeacherNotification


  
End 