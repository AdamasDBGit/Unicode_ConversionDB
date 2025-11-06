CREATE TABLE [dbo].[T_ERP_Exam_MapExamDetails] (
    [inMapExamDetailId]      INT              IDENTITY (1, 1) NOT NULL,
    [unMapExamMapDetailId]   UNIQUEIDENTIFIER CONSTRAINT [DF__T_ERP_Exa__unMap__355F9F26] DEFAULT (newid()) NULL,
    [inMapExamId]            INT              NULL,
    [inExamScheduleDetailId] INT              NULL,
    [inMapWithExamId]        INT              NULL,
    [dcFullMarks]            DECIMAL (18, 2)  NULL,
    [dcAvgClassMarks]        DECIMAL (18, 2)  NULL,
    [dcWeightageInMainExam]  DECIMAL (18, 2)  NULL,
    [inCreatedBy]            INT              NULL,
    [inModifiedBy]           INT              NULL,
    [dtCreatedDate]          DATETIME         NULL,
    [dtModifiedDate]         DATETIME         NULL,
    [inClassId]              INT              NULL,
    [inSubjectId]            INT              NULL,
    [inSubjectTypeID]        INT              NULL,
    [inSubjectComponentID]   INT              NULL,
    [inSectionId]            INT              NULL,
    [inStreamId]             INT              NULL,
    CONSTRAINT [PK__T_ERP_Ex__56143272921BBB00] PRIMARY KEY CLUSTERED ([inMapExamDetailId] ASC)
);

