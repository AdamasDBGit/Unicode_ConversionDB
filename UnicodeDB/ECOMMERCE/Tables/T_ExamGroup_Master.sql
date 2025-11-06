CREATE TABLE [ECOMMERCE].[T_ExamGroup_Master] (
    [ExamGroupID]     INT           IDENTITY (1, 1) NOT NULL,
    [ExamGroupDesc]   VARCHAR (MAX) NULL,
    [StatusID]        INT           NULL,
    [BrandID]         INT           NULL,
    [ExamGroupDetail] VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_ExamGr__90AC4314C77DF6E4] PRIMARY KEY CLUSTERED ([ExamGroupID] ASC)
);

