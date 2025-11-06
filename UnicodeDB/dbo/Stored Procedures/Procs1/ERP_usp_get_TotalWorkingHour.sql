--EXEC ERP_usp_get_TotalWorkingHour 107,2  
CREATE Proc [dbo].[ERP_usp_get_TotalWorkingHour]
(
    @BrandID int,
    @SessionID int
)
As
Begin
    --Declare @BrandID int,@SessionID int  

    --SET @BrandID = 107
    --SET @SessionID = 2
    --select * from T_School_Academic_Session_Master  
    DECLARE @StartDate DATE = (
                                  Select Convert(date, Dt_Session_Start_Date)
                                  from T_School_Academic_Session_Master
                                  where I_Brand_ID = @BrandID
                                        and I_School_Session_ID = @SessionID
                              )
    DECLARE @EndDate DATE = (
                                Select Convert(date, Dt_Session_End_Date)
                                from T_School_Academic_Session_Master
                                where I_Brand_ID = @BrandID
                                      and I_School_Session_ID = @SessionID
                            )
    --Select @StartDate,@EndDate  

    ;
    WITH DateRange
    AS (SELECT @StartDate AS Date
        UNION ALL
        SELECT DATEADD(DAY, 1, Date)
        FROM DateRange
        WHERE Date < @EndDate
       )
    SELECT Date,
           DATENAME(WEEKDAY, Date) AS DayName
    Into #DayCount
    FROM DateRange

    --LEFT JOIN   
    --    YourTable ON YourTable.DateColumn = Date  
    GROUP BY Date
    ORDER BY Date
    option (maxrecursion 0)

    --Select * from #DayCount  
    Declare @TotalDaycount Int
    SET @TotalDaycount =
    (
        Select COUNT([DayName]) as TotalDaycount
        --Into #DaywiseCount  
        from #DayCount
    )
    --group by [DayName]  
    --select * from #DaywiseCount  
    Select @TotalDaycount As TotalDayCount
    Declare @TotalWeekCount int
    SET @TotalWeekCount = @TotalDaycount / 7
    Select @TotalWeekCount As TotalWeekCount
    ------Holiday Count-----------------  
    ;
    WITH HDateRanges
    AS (SELECT Dt_StartDate,
               Dt_EndDate,
               ROW_NUMBER() OVER (ORDER BY Dt_StartDate) AS HolidayID
        FROM T_Event
        where I_Event_Category_ID = 2
              and I_Brand_ID = @BrandID
       )
    SELECT HolidayID,
           DateRange,
           DATENAME(WEEKDAY, DateRange) AS DayName,
           COUNT(*) AS DayCount
    Into #Holiday_DayCount
    FROM HDateRanges
        CROSS APPLY
    (
        SELECT TOP (DATEDIFF(DAY, Dt_StartDate, Dt_EndDate) + 1)
            DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, Dt_StartDate) AS DateRange
        FROM master.dbo.spt_values
    ) AS Dates
    GROUP BY HolidayID,
             DateRange
    ORDER BY HolidayID,
             DateRange;

    Declare @HolidayCount int
    SET @HolidayCount =
    (
        select COUNT(t.[DayName])
        from #Holiday_DayCount t
            Inner Join T_Week_Day_Master a
                on a.S_Day_Name = t.[DayName]
        where a.I_Day_ID NOT IN (
                                    Select I_Day_ID
                                    from T_Weekly_Off_Master
                                    where I_Brand_ID = @BrandID
                                          and I_School_session_ID = @SessionID
                                          and I_WeekOff = 1
                                )
    )

    Select @HolidayCount As TotalHoliDayCount

    -------------Week Off Count-----------------  
    Declare @WKOffDayCount int,
            @Total_WKOffDayCount int
    SET @WKOffDayCount =
    (
        select COUNT(i_day_ID) * @TotalWeekCount
        from T_Weekly_Off_Master
        where I_Brand_ID = @BrandID
              and I_School_session_ID = @SessionID
              and I_WeekOff = 1
    )
    SET @Total_WKOffDayCount = @WKOffDayCount
    Select @WKOffDayCount As TotalWeekOffCount
    Declare @TotalWorkingDay int,
            @Weeknumber int
    SET @TotalWorkingDay = @TotalDaycount - (@HolidayCount + @WKOffDayCount)
    --Select @TotalWorkingDay as TotalWorkingDays  
    SET @Weeknumber = CEILING(@TotalWorkingDay / 7)
    SElect @TotalWorkingDay As TotalWorkingDays,
           @Weeknumber as NumberOfAvailble_Week
    drop table #DayCount
    drop table #Holiday_DayCount
End
--drop table #DaywiseCount  
