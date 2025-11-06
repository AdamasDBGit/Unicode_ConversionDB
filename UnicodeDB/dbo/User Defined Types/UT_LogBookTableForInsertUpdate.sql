CREATE TYPE [dbo].[UT_LogBookTableForInsertUpdate] AS TABLE (
    [TeacherTimePlanID]         INT            NULL,
    [SubjectStructurePlanID]    INT            NOT NULL,
    [CompletionPercentage]      DECIMAL (4, 1) NOT NULL,
    [TotalCompletionPercentage] DECIMAL (4, 1) NOT NULL,
    [Remarks]                   VARCHAR (MAX)  NOT NULL,
    [LearningOutcomeAchieved]   VARCHAR (MAX)  NULL,
    [IsCompleted]               BIT            NULL);

