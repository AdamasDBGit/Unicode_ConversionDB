CREATE TABLE [dbo].[T_Student_Module_Detail] (
    [I_Student_Module_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Term_ID]                  INT            NOT NULL,
    [I_Module_ID]                INT            NOT NULL,
    [I_Course_ID]                INT            NOT NULL,
    [I_Student_Detail_ID]        INT            NOT NULL,
    [I_Is_Completed]             BIT            NULL,
    [S_Crtd_By]                  NVARCHAR (MAX) NULL,
    [S_Upd_By]                   NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                 DATETIME       NULL,
    [Dt_Upd_On]                  DATETIME       NULL,
    [I_Batch_ID]                 INT            NULL,
    CONSTRAINT [PK_T_Student_Module_Detail] PRIMARY KEY CLUSTERED ([I_Student_Module_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Module_ID_Module_Details]
    ON [dbo].[T_Student_Module_Detail]([I_Module_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [index_Student_ID_Module_Details]
    ON [dbo].[T_Student_Module_Detail]([I_Student_Detail_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [index_Term_ID_Module_Details]
    ON [dbo].[T_Student_Module_Detail]([I_Term_ID] ASC);

