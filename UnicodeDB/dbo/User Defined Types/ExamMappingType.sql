CREATE TYPE [dbo].[ExamMappingType] AS TABLE (
    [inMapExamId]            INT             NULL,
    [inExamScheduleDetailId] INT             NULL,
    [inMapWithExamId]        INT             NULL,
    [dcFullMarks]            DECIMAL (18, 2) NULL,
    [dcAvgClassMarks]        DECIMAL (18, 2) NULL,
    [dcWeightageInMainExam]  DECIMAL (18, 2) NULL,
    [inCreatedBy]            INT             NULL);

