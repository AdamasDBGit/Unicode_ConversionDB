CREATE TYPE [dbo].[UT_SubjectStructurePlanDetailsForInsertUpdate] AS TABLE (
    [SubjectID]          INT NULL,
    [MonthNo]            INT NULL,
    [DayNo]              INT NULL,
    [SubjectStructureID] INT NULL,
    [IsEditable]         BIT NULL,
    [CreatedBy]          INT NULL);

