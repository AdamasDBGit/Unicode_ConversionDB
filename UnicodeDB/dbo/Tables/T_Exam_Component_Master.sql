CREATE TABLE [dbo].[T_Exam_Component_Master] (
    [I_Exam_Component_ID]   INT             IDENTITY (1, 1) NOT NULL,
    [I_Exam_Type_Master_ID] INT             NULL,
    [S_Component_Name]      NVARCHAR (MAX)  NULL,
    [I_Status]              INT             NULL,
    [S_Component_Type]      NVARCHAR (MAX)  NULL,
    [S_Crtd_By]             NVARCHAR (MAX)  NULL,
    [S_Upd_By]              NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]            DATETIME        NULL,
    [Dt_Upd_On]             DATETIME        NULL,
    [I_Brand_ID]            INT             NULL,
    [Dt_Admission_Test]     DATETIME        NULL,
    [I_Course_ID]           INT             NULL,
    [B_Is_Subject]          BIT             NULL,
    [N_CutOffPercentage]    DECIMAL (18, 2) NULL,
    [I_Weightage]           INT             NULL,
    [I_Sequence_No]         INT             NULL,
    [B_Exclude_In_Report]   BIT             NULL,
    CONSTRAINT [PK__T_Exam_Component__173876EA] PRIMARY KEY CLUSTERED ([I_Exam_Component_ID] ASC)
);

