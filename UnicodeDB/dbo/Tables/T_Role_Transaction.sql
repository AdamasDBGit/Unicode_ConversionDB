CREATE TABLE [dbo].[T_Role_Transaction] (
    [I_Role_Transaction_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Transaction_ID]      INT            NULL,
    [I_Role_ID]             INT            NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [I_Status]              INT            NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK__T_Role_Transacti__57A8CD11] PRIMARY KEY CLUSTERED ([I_Role_Transaction_ID] ASC)
);

