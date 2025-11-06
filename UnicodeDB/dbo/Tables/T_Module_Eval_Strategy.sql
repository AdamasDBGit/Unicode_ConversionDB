CREATE TABLE [dbo].[T_Module_Eval_Strategy] (
    [I_Module_Strategy_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Course_ID]          INT            NULL,
    [I_Term_ID]            INT            NULL,
    [I_Module_ID]          INT            NULL,
    [I_Exam_Component_ID]  INT            NULL,
    [I_TotMarks]           INT            NULL,
    [N_Weightage]          NUMERIC (8, 2) NULL,
    [S_Remarks]            NVARCHAR (MAX) NULL,
    [I_Status]             INT            NULL,
    [S_Crtd_By]            NVARCHAR (MAX) NULL,
    [S_Upd_By]             NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]           DATETIME       NULL,
    [Dt_Upd_On]            DATETIME       NULL,
    [I_Exam_Duration]      INT            NULL,
    CONSTRAINT [PK__T_Module_Eval_St__3B75D760] PRIMARY KEY CLUSTERED ([I_Module_Strategy_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Component_ID_Module_Eval_Strategy]
    ON [dbo].[T_Module_Eval_Strategy]([I_Exam_Component_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [index_Course_ID_Module_Eval_Strategy]
    ON [dbo].[T_Module_Eval_Strategy]([I_Course_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [index_Term_ID_Module_Eval_Strategy]
    ON [dbo].[T_Module_Eval_Strategy]([I_Term_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [NCI_I_Status]
    ON [dbo].[T_Module_Eval_Strategy]([I_Status] ASC);

