CREATE TABLE [dbo].[T_ERP_Exam_Grade_Master_Header] (
    [inExamGradeHederId] INT            IDENTITY (1, 1) NOT NULL,
    [stGradeHederName]   NVARCHAR (MAX) NULL,
    [dtCreatedDate]      DATETIME       CONSTRAINT [DF__T_ERP_Exa__Dt_Cr__09E04444] DEFAULT (getdate()) NULL,
    [inCreatedBy]        INT            NULL,
    [IsActive]           BIT            CONSTRAINT [DF__T_ERP_Exa__Is_Ac__0AD4687D] DEFAULT ((1)) NULL,
    [dtModifiedDate]     DATETIME       NULL,
    [inModifiedBy]       INT            NULL,
    CONSTRAINT [PK__T_ERP_Ex__EE84DB2CCBA654AF] PRIMARY KEY CLUSTERED ([inExamGradeHederId] ASC)
);

