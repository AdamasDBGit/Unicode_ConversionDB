CREATE TYPE [dbo].[UT_Exam_ExamMappingType] AS TABLE (
    [inMapExamId]            INT             NULL,
    [inExamScheduleDetailId] INT             NULL,
    [inMapWithExamId]        INT             NULL,
    [dcFullMarks]            DECIMAL (18, 2) NULL,
    [dcAvgClassMarks]        DECIMAL (18, 2) NULL,
    [dcWeightageInMainExam]  DECIMAL (18, 2) NULL,
    [inClassId]              INT             NULL,
    [inSubjectId]            INT             NULL,
    [inSubjectTypeID]        INT             NULL,
    [inSubjectComponentID]   INT             NULL,
    [inSectionId]            INT             NULL,
    [inStreamId]             INT             NULL);

