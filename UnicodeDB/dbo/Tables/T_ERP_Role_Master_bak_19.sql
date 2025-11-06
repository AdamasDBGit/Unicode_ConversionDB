CREATE TABLE [dbo].[T_ERP_Role_Master_bak_19] (
    [I_Role_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Role_Code] NVARCHAR (MAX) NULL,
    [S_Role_Desc] NVARCHAR (MAX) NULL,
    [I_Status]    INT            NULL,
    [S_Crtd_By]   INT            NULL,
    [S_Upd_By]    INT            NULL,
    [Dt_Crtd_On]  DATETIME       NULL,
    [Dt_Upd_On]   DATETIME       NULL,
    [I_Brand_ID]  INT            NULL,
    [Role_Group]  NVARCHAR (MAX) NULL
);

