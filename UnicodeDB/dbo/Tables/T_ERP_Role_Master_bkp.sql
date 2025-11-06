CREATE TABLE [dbo].[T_ERP_Role_Master_bkp] (
    [I_Role_ID]   INT            NOT NULL,
    [S_Role_Code] NVARCHAR (100) NULL,
    [S_Role_Desc] NVARCHAR (MAX) NULL,
    [I_Status]    INT            NULL,
    [S_Crtd_By]   INT            NULL,
    [S_Upd_By]    INT            NULL,
    [Dt_Crtd_On]  DATETIME       NULL,
    [Dt_Upd_On]   DATETIME       NULL,
    [I_Brand_ID]  INT            NULL,
    [Role_Group]  NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([I_Role_ID] ASC)
);

