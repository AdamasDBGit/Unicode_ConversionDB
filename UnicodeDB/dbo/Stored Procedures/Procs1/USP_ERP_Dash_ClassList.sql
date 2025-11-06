   --EXEC USP_ERP_Dash_ClassList 107,35  
   CREATE Proc [dbo].[USP_ERP_Dash_ClassList](  
 @brandID int, @sessionID int  , @userID int=null
 )  

 
 --Declare @brandID int, @sessionID int  
 --SET @brandID=107  
 --SEt @sessionID=35  
 As  
 Declare @facultyID int = null
 Begin  
 --if(@userID is not null)
 --BEGIN
 set @facultyID = (select I_Faculty_Master_ID from T_Faculty_Master where I_User_ID = @userID)
 --END
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
 FacultyMasterID INT
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
 SCR.I_Student_Class_Routine_ID as StudentClassRoutineID  ,
 TEFS.I_Faculty_Master_ID FacultyMasterID
   
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
 left join 
 T_ERP_Faculty_Subject TEFS on TEFS.I_Subject_ID=SCR.I_Subject_ID --and (TEFS.I_Faculty_Master_ID=@facultyID or  TEFS.I_Faculty_Master_ID is null)
 inner join  
 T_Brand_Master as BM on BM.I_Brand_ID=SM.I_Brand_ID  
 left join  
 T_Section as S on S.I_Section_ID=RSH.I_Section_ID  
  
 where  RSH.I_School_Session_ID=@sessionID  
   
 and SM.I_Brand_ID=@brandID   
 And WDM.S_Day_Name=DATENAME(WEEKDAY, GETDATE())  
 and TEFS.I_Faculty_Master_ID = ISNULL(@facultyID,TEFS.I_Faculty_Master_ID)

 select Maintemp.FacultyMasterID, maintemp.RoutineStructureHeaderID,maintemp.StudentClassRoutineID,
 maintemp.PeriodNo,CONCAT((LEFT(Convert(varchar,Maintemp.PeriodStart),8)) ,'-',(LEFT(Convert(varchar,Maintemp.PeriodEnd),8))) As PeriodTiming , Maintemp.ClassName,Maintemp.SectionName,Maintemp.SubjectName,Maintemp.SubjectID,case when Att.Dt_Date is not null   
 then  1 else 0 end as Isattendance  
 --,Logbook.LookBookID,Logbook.ClassExecutedDate,Logbook.CompletionPercentage  
 ,Case when  I_Teacher_Time_Plan_ID Is not null Then 1 else 0 end as Logid  
 ,Case When  CRW.Dt_Date IS not null Then 1 Else 0 end Classwork  
 , 0 as Homework  
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
 --select * from #RoutineWiseLogBook  
 drop table #RoutineWiseLogBook  
  
 --select * from T_ERP_Teacher_Time_Plan  
 End  
   