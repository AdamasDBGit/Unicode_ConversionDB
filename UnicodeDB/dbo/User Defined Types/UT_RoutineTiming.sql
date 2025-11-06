CREATE TYPE [dbo].[UT_RoutineTiming] AS TABLE (
    [PeriodNumber] INT      NOT NULL,
    [DayID]        INT      NOT NULL,
    [startTime]    TIME (0) NOT NULL,
    [endTime]      TIME (0) NOT NULL);

