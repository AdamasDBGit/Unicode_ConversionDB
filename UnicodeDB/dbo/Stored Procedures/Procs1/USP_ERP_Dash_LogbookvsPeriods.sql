    
--EXEC USP_ERP_Dash_LogbookvsPeriods 35,'2024-04-05','2024-04-26',107    
CREATE Proc [dbo].[USP_ERP_Dash_LogbookvsPeriods] (      
@SessionID int,@Startdate date,@enddate date,@brandID int      
)      
as       
begin      
--dECLARE @SessionID int,@Startdate date,@enddate date,@brandID int      
--SET @Startdate='2024-04-05'      
--SET @enddate='2024-04-26'      
--SET @SessionID=35      
--SET @brandID=107      
;WITH DateRangeCTE AS (    
    SELECT @Startdate AS DateValue    
    UNION ALL    
    SELECT DATEADD(DAY, 1, DateValue)    
    FROM DateRangeCTE    
    WHERE DateValue < @enddate    
)    
SELECT DateValue    
Into #Dt_Range    
FROM DateRangeCTE;    
    
select RSH.I_Total_Periods ,AEH.I_Student_Class_Routine_ID      
,RSH.I_Routine_Structure_Header_ID,RSD.I_Routine_Structure_Detail_ID      
, AEH.Dt_Date      
Into #tempRoutine      
--,RSH.I_Routine_Structure_Header_ID      
from T_ERP_Attendance_Entry_Header AEH       
Inner Join T_ERP_Student_Class_Routine SCR       
on SCR.I_Student_Class_Routine_ID=AEH.I_Student_Class_Routine_ID      
Inner Join T_ERP_Routine_Structure_Detail RSD       
ON RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID      
Inner Join T_ERP_Routine_Structure_Header RSH       
ON RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID      
Inner Join T_School_Academic_Session_Master ASM on ASM.I_School_Session_ID=RSH.I_School_Session_ID      
where AEH.Dt_Date between @Startdate and @enddate       
and RSH.I_School_Session_ID=@SessionID and ASM.I_Brand_ID=@brandID      
group by  AEH.Dt_Date,AEH.I_Student_Class_Routine_ID,RSH.I_Routine_Structure_Header_ID,      
RSD.I_Routine_Structure_Detail_ID,RSH.I_Total_Periods      
order by AEH.Dt_Date      
--select * from #tempRoutine    
    
--select * from T_ERP_Student_Class_Routine where I_Student_Class_Routine_ID in(433,434,436)    
--select * from T_ERP_Routine_Structure_Header where I_Routine_Structure_Header_ID=42    
      
Declare @TotalClass int      
select    
dtr.DateValue,    
CASE     
        WHEN COUNT(DISTINCT I_Total_Periods) > 1     
        THEN Isnull(SUM(I_Total_Periods) ,0)    
        ELSE Isnull(MAX(I_Total_Periods),0) End as       
totalClass      
--,temp1.Dt_Date       
,FORMAT(temp1.Dt_Date, 'yyyy-MM-dd') AS Dt_Date      
,FORMAT(dtr.DateValue, 'MM/dd') AS date      
,Isnull(Tset.LogbookCount  ,0) as LogbookCount    
from #Dt_Range Dtr    
Left Join  #tempRoutine temp1  On Dtr.DateValue=temp1.Dt_Date    
Left Join     
(select ISNUll(count(I_Teacher_Time_Plan_ID),0) as LogbookCount,    
convert(date,t.Dt_Date) Dt_date  from #tempRoutine t      
Left Join T_ERP_Teacher_Time_Plan Logb       
on t.I_Student_Class_Routine_ID=Logb.I_Student_Class_Routine_ID      
and t.Dt_Date=Logb.Dt_Class_Date      
Group By t.Dt_Date      
)Tset on Tset.Dt_date=convert(date,temp1.Dt_Date)      
group by temp1.Dt_Date,Dtr.DateValue    
,Tset.LogbookCount      
order by Dtr.DateValue    
End
