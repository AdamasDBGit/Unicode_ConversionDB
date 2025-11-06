CREATE TABLE [dbo].[T_Session_Type_Master] (
    [I_Session_Type_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Session_Type_Name] NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    CONSTRAINT [PK__T_Session_Type_M__0114F6F8] PRIMARY KEY CLUSTERED ([I_Session_Type_ID] ASC)
);

