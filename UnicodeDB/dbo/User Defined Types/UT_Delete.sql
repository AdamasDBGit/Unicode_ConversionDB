CREATE TYPE [dbo].[UT_Delete] AS TABLE (
    [TeacherTimePlanID]         INT           NULL,
    [StudentClassRoutineID]     INT           NOT NULL,
    [SubjectID]                 INT           NOT NULL,
    [SubjectStructurePlanID]    INT           NOT NULL,
    [CompletionPercentage]      INT           NOT NULL,
    [TotalCompletionPercentage] INT           NOT NULL,
    [IsCompleted]               BIT           NULL,
    [DtClassDate]               DATETIME      NOT NULL,
    [FacultyID]                 INT           NULL,
    [UserID]                    INT           NULL,
    [sToken]                    VARCHAR (MAX) NULL);

