CREATE PROCEDURE [dbo].[uspGetTimeTableMonthwiseCompletion] --[dbo].[uspGetTimeTableMonthwiseCompletion] 794,12,2012
    (
      @ICenterID INT ,
      @month INT ,
      @year INT
    )
AS 
    BEGIN TRY
		
		DECLARE @NoOfRooms INT,@NoOfTimeSlots INT  
        SELECT  @NoOfRooms = COUNT(*)  
        FROM    dbo.T_Room_Master AS TRM  
        WHERE   I_Centre_Id = @ICenterID and I_Status=1
		
		SELECT @NoOfTimeSlots = COUNT(*)
		FROM dbo.T_Center_Timeslot_Master AS TCTM
		WHERE I_Center_ID = @ICenterID AND I_Status = 1
		
		SELECT T1.ScheduleDate,CASE WHEN COUNT(I_TimeTable_ID) = @NoOfRooms*@NoOfTimeSlots THEN 2  
                     WHEN COUNT(I_TimeTable_ID) > 0 THEN 1  
                     ELSE 0   
                END AS IsTimeTableAdded  FROM 
        (SELECT  CAST(CAST(@year AS VARCHAR) + '-' + CAST(@Month AS VARCHAR)
                + '-01' AS DATETIME) + Number AS ScheduleDate
        FROM    master..spt_values
        WHERE   type = 'P'
                AND ( CAST(CAST(@year AS VARCHAR) + '-'
                      + CAST(@Month AS VARCHAR) + '-01' AS DATETIME) + Number ) < DATEADD(mm,
                                                              1,
                                                              CAST(CAST(@year AS VARCHAR)
                                                              + '-'
                                                              + CAST(@Month AS VARCHAR)
                                                              + '-01' AS DATETIME))) T1
		LEFT OUTER JOIN dbo.T_TimeTable_Master AS TTTM   
		ON T1.ScheduleDate = TTTM.Dt_Schedule_Date                                                           
		AND I_Status = 1
		AND I_Center_ID = @ICenterID
		AND I_Session_ID is not null
		GROUP BY T1.ScheduleDate
		ORDER BY T1.ScheduleDate
		
    END TRY                      
    BEGIN CATCH                      
 --Error occurred:                        
        ROLLBACK TRANSACTION T1                     
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT                      
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()                      
                      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                      
    END CATCH
