CREATE PROCEDURE [dbo].[RoutineSlotGenerate] 
-- =============================================
-- Author: Tridip Chatterjee
-- Create date: 26-09-2023
-- Description: Generating Slots
-- =============================================
-- Add the parameters for the stored procedure here
@RoutineHeaderID INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering
    SET NOCOUNT ON;

    -- **Creating Temp Table For Arrange Period and Day Wise ID**
    BEGIN
        CREATE TABLE #PeriodAndDay(I_Day_ID INT, Period_NO INT);

        WITH Period AS (
            SELECT COUNT = 1
            UNION ALL
            SELECT COUNT = COUNT + 1
            FROM Period 
            WHERE COUNT < (SELECT I_Total_Periods 
                           FROM T_Erp_Routine_Structure_Header 
                           WHERE I_Routine_Structure_Header_ID = @RoutineHeaderID)
        )
        INSERT INTO #PeriodAndDay(I_Day_ID, Period_NO) -- *** Inserting Values ***
        SELECT 
            Findday.I_Day_ID,
            COUNT AS Period_No  
        FROM Period
        CROSS JOIN (
            SELECT I_Day_ID, T_Start_Slot 
            FROM T_Week_Day_Master
            CROSS JOIN T_Erp_Routine_Structure_Header 
            WHERE I_Day_ID != 1 
              AND I_Routine_Structure_Header_ID = @RoutineHeaderID
        ) Findday
        ORDER BY Findday.I_Day_ID, COUNT;
    END

    -- **Creating Slot Table and Generating Time Slots**
    BEGIN
        CREATE TABLE #Slot (
            Period_No INT PRIMARY KEY, 
            Start_Slot TIME, 
            End_Slot TIME
        );

        DECLARE @A TIME, @B TIME, @W INT, @loop INT;

        SET @loop = (SELECT I_Total_Periods 
                     FROM T_Erp_Routine_Structure_Header  
                     WHERE I_Routine_Structure_Header_ID = @RoutineHeaderID);

        SET @W = 1;

        -- Initial Start Time
        SET @B = (SELECT T_Start_Slot 
                  FROM T_Erp_Routine_Structure_Header 
                  WHERE I_Routine_Structure_Header_ID = @RoutineHeaderID);

        WHILE (@W <= @loop)
        BEGIN
            -- Calculate End Time for the Slot
            SET @A = (SELECT CAST(DATEADD(SECOND, 
                        DATEDIFF(SECOND, 0, T_Duration) + DATEDIFF(SECOND, 0, T_Period_Gap), 
                        CAST(@B AS DATETIME)) AS TIME)
                      FROM T_Erp_Routine_Structure_Header 
                      WHERE I_Routine_Structure_Header_ID = @RoutineHeaderID);

            -- Insert the Slot
            INSERT INTO #Slot(Period_No, Start_Slot, End_Slot)
            SELECT @W, @B AS Start_Slot, @A AS End_Slot;

            -- Update Start Time for Next Slot
            SET @B = @A;
            SET @W = @W + 1;
        END
    END

    -- **Final Output**
    SELECT 
        #PeriodAndDay.I_Day_ID,
        #Slot.Period_No,
        #Slot.Start_Slot AS Start_Slot,
        #Slot.End_Slot AS End_Slot 
    FROM #Slot
    INNER JOIN #PeriodAndDay 
        ON #Slot.Period_No = #PeriodAndDay.Period_NO;

    -- Drop Temporary Tables
    DROP TABLE #PeriodAndDay;
    DROP TABLE #Slot;
END
