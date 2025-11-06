
--EXEC ERP_Usp_Get_TotalSubject_Allocation 25

CREATE  Proc [dbo].[ERP_Usp_Get_TotalSubject_Allocation](
@Routine_Structure_Header_ID int
)
As 
Begin
		-------Fetch Weekly  Subject Allocation Count---------------
	--Declare @Routine_Structure_Header_ID int =4	
SELECT RSD.I_Routine_Structure_Header_ID, 
--SCR.I_Student_Class_Routine_ID,
--SCR.I_Routine_Structure_Detail_ID,
SCR.I_Subject_ID,
Count(SCR.I_Subject_ID) as AllocatedSubjectCount,
SBM.S_Subject_Name,
--SCR.S_Class_Type,
--RSD.I_Period_No,
--RSD.I_Day_ID,
--WDM.S_Day_Name
 RSH.I_School_Session_ID
--,SBM.I_TotalNoOfClasses
Into #WK_SubjectGroupAllocationCount

from T_ERP_Student_Class_Routine SCR
Inner Join T_ERP_Routine_Structure_Detail RSD 
on SCR.I_Routine_Structure_Detail_ID=RSD.I_Routine_Structure_Detail_ID
Left Join T_Subject_Master SBM on SBM.I_Subject_ID=SCR.I_Subject_ID
Left Join T_Week_Day_Master WDM on WDM.I_Day_ID=RSD.I_Day_ID
Inner Join T_ERP_Routine_Structure_Header RSH 
on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
where RSD.I_Routine_Structure_Header_ID=@Routine_Structure_Header_ID
and SBM.S_Subject_Name is not null
Group By rsd.I_Routine_Structure_Header_ID,SBM.S_Subject_Name,RSD.I_Day_ID,WDM.S_Day_Name,
SCR.I_Subject_ID,RSH.I_School_Session_ID
Order by WDM.S_Day_Name

Select I_Routine_Structure_Header_ID,
I_Subject_ID,S_Subject_Name,I_School_Session_ID,
SUM(AllocatedSubjectCount) as AllocatedSubjectCount
Into #WK_SubjectAllocationCount
from #WK_SubjectGroupAllocationCount
Group by I_Routine_Structure_Header_ID,
I_Subject_ID,S_Subject_Name,I_School_Session_ID
--Drop table #WK_SubjectAllocationCount
--drop table #WK_SubjectGroupAllocationCount
--Select * from #WK_SubjectAllocationCount
-----Fetch Session Date-------------
Declare @SessionID int
SET @SessionID=(Select top 1 I_School_Session_ID from #WK_SubjectAllocationCount)
--Select @SessionID
-----------Day Wise Count -------------------

DECLARE @StartDate DATE = (Select Convert(date,Dt_Session_Start_Date )
from T_School_Academic_Session_Master where I_School_Session_ID=@SessionID)
DECLARE @EndDate DATE =( Select Convert(date,Dt_Session_End_Date )
from T_School_Academic_Session_Master where I_School_Session_ID=@SessionID)
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
		--Select @TotalWkCount

----------------Holiday Count---------------------
;WITH HDateRanges AS (
    SELECT
        Dt_StartDate,
        Dt_EndDate,
        ROW_NUMBER() OVER (ORDER BY Dt_StartDate) AS HolidayID
    FROM
        T_Event where I_Event_Category_ID=2
)

SELECT
    HolidayID,
    DateRange,
	DATENAME(WEEKDAY, DateRange) AS DayName,
    COUNT(*) AS DayCount
	Into #Holiday_DayCount
FROM
    HDateRanges
CROSS APPLY
    (SELECT TOP (DATEDIFF(DAY, Dt_StartDate, Dt_EndDate) + 1)
         DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, Dt_StartDate) AS DateRange
     FROM
         master.dbo.spt_values) AS Dates
GROUP BY
    HolidayID, DateRange
ORDER BY
    HolidayID, DateRange;

	select COUNT([DayName]) as HolidayCount, [DayName] as Holiday_Name 
		Into #HolidayFinalCount
	from #Holiday_DayCount

	group by [DayName]
	Declare @TotalHolidayCount int=(
	select SUM(holidaycount) from #HolidayFinalCount)
	--Select @TotalHolidayCount
	--select * from #Holiday_DayCount



-------------End---------------------------------------------------

		Select distinct T1.I_Routine_Structure_Header_ID,T1.I_Subject_ID,T1.S_Subject_Name,
		T1.AllocatedSubjectCount as WeeklyAllocatedcount
		,Isnull((T1.AllocatedSubjectCount*@TotalWkCount),0) as Total_Yearly_Allocated
		,isnull(@TotalHolidayCount,0) as HolidayCount
		,Isnull((T1.AllocatedSubjectCount*@TotalWkCount),0)-(isnull(@TotalHolidayCount,0)) 
		as Actual_Subject_Allocation
		
		from #WK_SubjectAllocationCount  T1



Drop Table #DayCount
Drop table #WK_SubjectAllocationCount
drop table #DaywiseCount
drop table #Holiday_DayCount
drop table #HolidayFinalCount
drop table #WK_SubjectGroupAllocationCount
End
