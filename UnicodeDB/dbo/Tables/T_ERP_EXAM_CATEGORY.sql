CREATE TABLE [dbo].[T_ERP_EXAM_CATEGORY] (
    [inExamCategoryId]   INT              IDENTITY (1, 1) NOT NULL,
    [inExamTypeID]       INT              NULL,
    [stExamCategoryName] NVARCHAR (MAX)   NULL,
    [inBrandID]          INT              NULL,
    [IsActive]           BIT              NULL,
    [dtCreatedDate]      DATETIME         CONSTRAINT [DF__T_ERP_EXA__Dt_Cr__4F347FC2] DEFAULT (getdate()) NULL,
    [inCreatedBy]        INT              NULL,
    [unCategoryId]       UNIQUEIDENTIFIER NULL,
    [inSchoolGroupID]    INT              NULL,
    [inSchoolSessionID]  INT              NULL,
    CONSTRAINT [PK_T_ERP_EXAM_CATEGORY] PRIMARY KEY CLUSTERED ([inExamCategoryId] ASC)
);

