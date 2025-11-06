CREATE PROCEDURE [dbo].[usp_ERP_GetFacultySubjectMatrix]  
 -- Add the parameters for the stored procedure here  
 (  
  @RHeaderId int  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
Declare @SchoolGroupID int, @ClassID int, @SessionID int
select top 1 @SchoolGroupID=I_School_Group_ID, @SessionID=I_School_Session_ID,@ClassID= I_Class_ID 
from T_ERP_Routine_Structure_Header where I_Routine_Structure_Header_ID = @RHeaderId

select distinct TESCR.I_Subject_ID,
TSm.S_Subject_Name
--into #subjectData
from T_ERP_Student_Class_Routine TESCR
inner join T_ERP_Routine_Structure_Detail TERSD on TESCR.I_Routine_Structure_Detail_ID = TERSD.I_Routine_Structure_Detail_ID
inner join T_Subject_Master TSM on TESCR.I_Subject_ID = TSM.I_Subject_ID
where TERSD.I_Routine_Structure_Header_ID = @RHeaderId and TESCR.I_Faculty_Master_ID IS NOT NULL and TESCR.I_Faculty_Master_ID <> 0
 
--Select @SessionID  
-----------Day Wise Count -------------------  
DECLARE @StartDate DATE = (Select Convert(date,Dt_Session_Start_Date )  
FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 and I_School_Session_ID=@SessionID)  
DECLARE @EndDate DATE =( Select Convert(date,Dt_Session_End_Date )  
FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 and I_School_Session_ID=@SessionID)  
--Select @StartDate,@EndDate  
;WITH DateRange AS (  
    SELECT @StartDate AS Date  
    UNION ALL  
    SELECT DATEADD(DAY, 1, Date)  
    FROM DateRange  
    WHERE Date < @EndDate  
)  
SELECT   
    Date,DATENAME(WEEKDAY, Date) AS DayName  
Into #DayCount  
FROM   
    DateRange  
--LEFT JOIN   
--    YourTable ON YourTable.DateColumn = Date  
GROUP BY   
    Date  
ORDER BY   
    Date  
  option (maxrecursion 0)  
  Select COUNT([DayName]) as Daycount,[DayName] as Day_Name   
  Into #DaywiseCount  
  from #DayCount  
  group by [DayName]  
  Declare @TotalWkCount int =(  
    Select top 1 Daycount from #DaywiseCount  
  )
select 
count(TESCR.I_Subject_ID) SubjectWkCount,
count(TESCR.I_Subject_ID)*@TotalWkCount as SubjectTotalCount ,
TERSD.I_Routine_Structure_Header_ID RHeaderID,
TESCR.I_Faculty_Master_ID FacultyID,
TFM.S_Faculty_Name,
TESCR.I_Subject_ID SubjectID,
TSM.S_Subject_Name

from T_ERP_Routine_Structure_Detail TERSD
left join T_ERP_Student_Class_Routine TESCR on TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID 
inner join T_Faculty_Master TFM on TESCR.I_Faculty_Master_ID = TFM.I_Faculty_Master_ID
inner join T_Subject_Master TSM on TESCR.I_Subject_ID = TSM.I_Subject_ID
--right join #subjectData t1 on t1.I_Subject_ID = TESCR.I_Subject_ID
where I_Routine_Structure_Header_ID = @RHeaderId and TESCR.I_Faculty_Master_ID IS NOT NULL
Group by TESCR.I_Faculty_Master_ID, I_Routine_Structure_Header_ID,
TESCR.I_Subject_ID, TFM.S_Faculty_Name, TSM.S_Subject_Name
--drop table #subjectData
drop table #DayCount
drop table #DaywiseCount

END 
