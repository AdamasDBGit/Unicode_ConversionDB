CREATE TABLE [dbo].[T_Exam_MapExamDetails] (
    [inMapExamDetailId]      INT              IDENTITY (1, 1) NOT NULL,
    [unMapExamMapDetailId]   UNIQUEIDENTIFIER CONSTRAINT [DF__T_Exam_Ma__unMap__63066E45] DEFAULT (newid()) NULL,
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
    CONSTRAINT [PK__T_Exam_M__5614327259996AB1] PRIMARY KEY CLUSTERED ([inMapExamDetailId] ASC)
);

