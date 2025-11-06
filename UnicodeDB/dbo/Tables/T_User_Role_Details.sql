CREATE TABLE [dbo].[T_User_Role_Details] (
    [I_User_Role_Detail_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Role_ID]             INT            NULL,
    [I_User_ID]             INT            NULL,
    [I_Status]              INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK__T_User_Role_Deta__656C112C] PRIMARY KEY CLUSTERED ([I_User_Role_Detail_ID] ASC)
);

