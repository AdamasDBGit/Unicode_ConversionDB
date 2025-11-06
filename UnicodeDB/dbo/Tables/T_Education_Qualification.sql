CREATE TABLE [dbo].[T_Education_Qualification] (
    [I_Education_Qualification_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [S_Education_Qualification_Description] NVARCHAR (MAX) NULL,
    [I_Status]                              INT            NULL,
    [S_Crtd_By]                             NVARCHAR (MAX) NULL,
    [S_Upd_By]                              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                            DATETIME       NULL,
    [Dt_Upd_On]                             DATETIME       NULL,
    [I_Brand_ID]                            INT            NULL
);

