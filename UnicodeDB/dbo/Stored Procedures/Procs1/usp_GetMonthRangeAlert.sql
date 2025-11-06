CREATE PROCEDURE [dbo].[usp_GetMonthRangeAlert]
    @BrandID INT,
    @StartMonth INT,
    @EndMonth INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SessionStartDate DATE, @SessionEndDate DATE;
    DECLARE @SelectedMonthCount INT, @ValidMonthCount INT;
    DECLARE @StartMonthName NVARCHAR(max), @EndMonthName NVARCHAR(max);
    DECLARE @FirstValidMonthName NVARCHAR(max), @LastValidMonthName NVARCHAR(max);
    DECLARE @Message NVARCHAR(max);

    -- 1. Get current academic session
    SELECT 
        @SessionStartDate = Dt_Session_Start_Date,
        @SessionEndDate = Dt_Session_End_Date
    FROM T_School_Academic_Session_Master
    WHERE I_Brand_ID = @BrandID AND I_Current_Session = 1;

    IF @SessionStartDate IS NULL OR @SessionEndDate IS NULL
    BEGIN
        RAISERROR('No current academic session found for this brand.', 16, 1);
        RETURN;
    END

    -- 2. Set default EndMonth to March
    IF @EndMonth IS NULL
        SET @EndMonth = 3;

    -- 3. Month names
    SET @StartMonthName = DATENAME(MONTH, DATEFROMPARTS(2000, @StartMonth, 1));
    SET @EndMonthName = DATENAME(MONTH, DATEFROMPARTS(2000, @EndMonth, 1));

    -- 4. Generate full month range from StartMonth to EndMonth (wrapping across year if needed)
    DECLARE @SelectedMonths TABLE (MonthStart DATE);

    DECLARE @StartYear INT = YEAR(@SessionStartDate);
    DECLARE @Month INT = @StartMonth;
    DECLARE @Year INT = @StartYear;

    -- If StartMonth is before session, align year
    IF @StartMonth < MONTH(@SessionStartDate)
        SET @Year = @Year + 1;

    DECLARE @LoopEnd BIT = 0;
    WHILE @LoopEnd = 0
    BEGIN
        INSERT INTO @SelectedMonths VALUES (DATEFROMPARTS(@Year, @Month, 1));

        IF @Month = @EndMonth
            SET @LoopEnd = 1;

        SET @Month = @Month + 1;
        IF @Month > 12
        BEGIN
            SET @Month = 1;
            SET @Year = @Year + 1;
        END
    END

    -- 5. Count selected months
    SELECT @SelectedMonthCount = COUNT(*) FROM @SelectedMonths;

    -- 6. Filter those that are within the academic session
    DECLARE @ValidMonths TABLE (MonthStart DATE);

    INSERT INTO @ValidMonths
    SELECT MonthStart FROM @SelectedMonths
    WHERE MonthStart BETWEEN @SessionStartDate AND @SessionEndDate;

    SELECT 
        @ValidMonthCount = COUNT(*),
        @FirstValidMonthName = DATENAME(MONTH, MIN(MonthStart)),
        @LastValidMonthName = DATENAME(MONTH, MAX(MonthStart))
    FROM @ValidMonths;

    -- 7. Build final message
    SET @Message = N'?? You''ve selected ' + @StartMonthName + N'–' + @EndMonthName + 
                   N' (' + CAST(@SelectedMonthCount AS NVARCHAR) + N' months), but the academic session ends in ' +
                   DATENAME(MONTH, @SessionEndDate) + N'. Only ' + @FirstValidMonthName + N'–' + @LastValidMonthName +
                   N' (' + CAST(@ValidMonthCount AS NVARCHAR) + N' months) will be considered in this session; create carefully to align with the academic session.';

    -- 8. Return result
    SELECT 
        @StartMonth AS StartMonth,
        @EndMonth AS EndMonth,
        @Message AS WarningMessage;
END
