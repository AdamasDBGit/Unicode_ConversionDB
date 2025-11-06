CREATE Proc [dbo].[ERP_Usp_Holiday_Flag](
@InputDate date,
@BrandID int
)
As 
Begin
--Declare @BrandID int
--,@InputDate date
--SET @InputDate='2024-03-13'
--SET @BrandID=107


;WITH HDateRanges AS (
    SELECT
        Dt_StartDate,
        Dt_EndDate,
        ROW_NUMBER() OVER (ORDER BY Dt_StartDate) AS HolidayID
    FROM
        T_Event where I_Event_Category_ID=2 and I_Brand_ID=@BrandID
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
	If Exists(
	Select * from #Holiday_DayCount where DateRange=@InputDate
	)
	Begin
	Select 'A Holiday' as Day
	End
	Else
	Begin
	Select 'Working day' as Day
	End

	drop table #Holiday_DayCount
	End
