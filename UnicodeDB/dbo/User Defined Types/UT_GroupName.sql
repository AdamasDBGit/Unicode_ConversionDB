CREATE TYPE [dbo].[UT_GroupName] AS TABLE (
    [ComponentID]    INT            NOT NULL,
    [ExamScheduleID] INT            NOT NULL,
    [GroupName]      NVARCHAR (100) NOT NULL);

