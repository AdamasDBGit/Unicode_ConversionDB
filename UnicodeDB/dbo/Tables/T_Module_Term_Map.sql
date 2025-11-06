CREATE TABLE [dbo].[T_Module_Term_Map] (
    [I_Module_Term_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Term_ID]        INT            NULL,
    [I_Module_ID]      INT            NULL,
    [I_Sequence]       INT            NULL,
    [C_Examinable]     CHAR (1)       NULL,
    [S_Crtd_By]        NVARCHAR (MAX) NULL,
    [S_Upd_By]         NVARCHAR (MAX) NULL,
    [Dt_Valid_From]    DATETIME       NULL,
    [Dt_Crtd_On]       DATETIME       NULL,
    [Dt_Valid_To]      DATETIME       NULL,
    [Dt_Upd_On]        DATETIME       NULL,
    [I_Status]         INT            NULL,
    [I_ModuleGroup_ID] INT            NULL,
    [N_Weightage]      NUMERIC (8, 2) NULL,
    [S_Remarks]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Module_Term_Ma__3DE8FB0E] PRIMARY KEY CLUSTERED ([I_Module_Term_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Term_ID_Module_Term]
    ON [dbo].[T_Module_Term_Map]([I_Term_ID] ASC);

