CREATE TABLE [dbo].[T_Student_Status_Master] (
    [I_Student_Status_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Student_Status]    NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL
);

