CREATE TABLE [dbo].[T_ERP_Exam_Type_Master] (
    [inExamTypeID]   INT              IDENTITY (1, 1) NOT NULL,
    [stExamTypeName] NVARCHAR (MAX)   NULL,
    [inTYPE]         INT              NULL,
    [unTypeId]       UNIQUEIDENTIFIER NULL,
    [inBrandID]      INT              NULL,
    [IsMainExam]     BIT              CONSTRAINT [DF__T_ERP_Exa__IsMai__4CE222FC] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_ERP_Exam_Type_Master] PRIMARY KEY CLUSTERED ([inExamTypeID] ASC)
);

