CREATE TYPE [dbo].[drop] AS TABLE (
    [ID]                 INT IDENTITY (1, 1) NOT NULL,
    [SubjectID]          INT NULL,
    [MonthNo]            INT NULL,
    [DayNo]              INT NULL,
    [SubjectStructureID] INT NULL,
    [CreatedBy]          INT NULL);

