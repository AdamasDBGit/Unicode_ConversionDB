CREATE TYPE [dbo].[UT_PeriodDetails] AS TABLE (
    [PeriodNumber] INT      NOT NULL,
    [DayID]        INT      NOT NULL,
    [StartTime]    TIME (0) NOT NULL,
    [EndTime]      TIME (0) NOT NULL,
    [IsBreak]      INT      NOT NULL);

