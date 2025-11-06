CREATE TABLE [dbo].[T_Term_Eval_Strategy] (
    [I_Term_Strategy_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [I_Course_ID]           INT            NULL,
    [I_Term_ID]             INT            NULL,
    [I_Exam_Component_ID]   INT            NULL,
    [I_Exam_Type_Master_ID] INT            NULL,
    [I_TotMarks]            INT            NULL,
    [N_Weightage]           NUMERIC (8, 2) NULL,
    [S_Remarks]             NVARCHAR (MAX) NULL,
    [I_IsPSDate]            BIT            NULL,
    [I_Template_ID]         INT            NULL,
    [I_Status]              INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    [I_Exam_Duration]       INT            NULL,
    CONSTRAINT [PK__T_Term_Eval_Stra__3D5E1FD2] PRIMARY KEY CLUSTERED ([I_Term_Strategy_ID] ASC)
);

