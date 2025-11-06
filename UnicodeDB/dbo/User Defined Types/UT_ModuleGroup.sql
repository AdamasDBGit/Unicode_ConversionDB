CREATE TYPE [dbo].[UT_ModuleGroup] AS TABLE (
    [ComponentID]    INT            NOT NULL,
    [ModuleID]       INT            NOT NULL,
    [ExamScheduleID] INT            NOT NULL,
    [GroupName]      NVARCHAR (100) NOT NULL);

