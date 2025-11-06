CREATE PROCEDURE [dbo].[usp_ERP_GetWorkingDays]     
(   
@GroupID int,  
@ClassID int,  
@SessionID int ,
@brandID int
)      
AS    
Begin 
    BEGIN TRY    
	--select * from T_Event 
	--select * from 
	-- Declare @brandID int=107,@SessionID int=2
	 DECLARE @StartDate DATE = (  
                                  Select Convert(date, Dt_Session_Start_Date)  
                                  FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1  
                                  and I_Brand_ID = @BrandID  
                                        and I_School_Session_ID = @SessionID  
                              )  
    DECLARE @EndDate DATE = (  
                                Select Convert(date, Dt_Session_End_Date)  
                                FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1  
                                and I_Brand_ID = @BrandID  
                                      and I_School_Session_ID = @SessionID  
                            )  

 ;WITH DateRange  
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
  
    
    GROUP BY Date  
    ORDER BY Date  
    option (maxrecursion 0) 

	Declare @TotalDaycount Int  
    SET @TotalDaycount =  
    (  
        Select COUNT([DayName]) as TotalDaycount  
        --Into #DaywiseCount    
        from #DayCount  
    )  
	--select @TotalDaycount

	Declare @TotalWeekCount int  
    SET @TotalWeekCount = @TotalDaycount / 7  
   -- Select @TotalWeekCount As TotalWeekCount  

	select I_Class_ID,I_School_Group_ID, 
	COUNT(I_Event_Class_ID) as Event_Count ,@TotalDaycount as TotalDays,
	@TotalWeekCount as Total_WeekDays
	
	Into #FinalWorkingDays 
	from T_Event_Class EC 
	Inner Join T_Event E on E.I_Event_ID=EC.I_Event_ID
	where E.I_Event_Category_ID=2
	and EC.I_Class_ID=@ClassID and EC.I_School_Group_ID=@GroupID
	group by I_Class_ID,I_School_Group_ID

	select TotalDays-(Event_Count+Total_WeekDays) as WorkingCount ,
	I_Class_ID as CalssID,I_School_Group_ID as GroupID
	from #FinalWorkingDays
	Drop table #DayCount
	drop table #FinalWorkingDays

   -- SELECT 289 as WorkingCount ,1 CalssID,1 GroupID  
    END TRY      
      
    BEGIN CATCH      
--Error occurred:      
      
        DECLARE @ErrMsg Nnvarchar(max) ,      
            @ErrSeverity INT      
        SELECT  @ErrMsg = ERROR_MESSAGE() ,      
                @ErrSeverity = ERROR_SEVERITY()      
      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)      
    END CATCH 

	End
