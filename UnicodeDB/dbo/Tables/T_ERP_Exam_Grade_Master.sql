CREATE TABLE [dbo].[T_ERP_Exam_Grade_Master] (
    [inExamGradeID]      INT            IDENTITY (1, 1) NOT NULL,
    [inExamGradeHederId] INT            NULL,
    [stSymbol]           NVARCHAR (MAX) NOT NULL,
    [stName]             NVARCHAR (MAX) NULL,
    [inLowerLimit]       INT            NOT NULL,
    [inUpperLimit]       INT            NOT NULL,
    [stRemarks]          NVARCHAR (MAX) NULL,
    [inCreatedBy]        INT            NULL,
    [dtCreatedDate]      DATETIME       CONSTRAINT [DF__T_ERP_Exa__Dt_Cr__0DB0D528] DEFAULT (getdate()) NULL,
    [dtModifiedDate]     DATETIME       NULL,
    [inModifiedBy]       INT            NULL,
    [IsActive]           BIT            NULL,
    CONSTRAINT [PK__T_ERP_Ex__E6D5CB4B8C6C2EC2] PRIMARY KEY CLUSTERED ([inExamGradeID] ASC)
);

