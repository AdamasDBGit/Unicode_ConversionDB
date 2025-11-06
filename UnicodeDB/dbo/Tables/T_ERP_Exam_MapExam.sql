CREATE TABLE [dbo].[T_ERP_Exam_MapExam] (
    [inMapExamId]            INT              IDENTITY (1, 1) NOT NULL,
    [unMapExamId]            UNIQUEIDENTIFIER CONSTRAINT [DF__T_ERP_Exa__unMap__0DF0CC4A] DEFAULT (newid()) NULL,
    [inExamScheduleDetailId] INT              NULL,
    [inCreatedBy]            INT              NULL,
    [inModifiedBy]           INT              NULL,
    [dtCreatedDate]          DATETIME         NULL,
    [dtModifiedDate]         DATETIME         NULL,
    CONSTRAINT [PK__T_ERP_Ex__750889A9D650B02C] PRIMARY KEY CLUSTERED ([inMapExamId] ASC)
);

