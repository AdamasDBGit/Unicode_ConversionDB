CREATE Proc [dbo].[USP_ERP_Dash_Classtaken](    
@BrandID int    
,@sessionID int=null    
)    
as begin    
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
End
