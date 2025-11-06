CREATE TABLE [dbo].[BKP_T_Student_Module_Detail_SEP] (
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
    [I_Batch_ID]                 INT            NULL
);

