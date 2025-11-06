CREATE TABLE [dbo].[T_ERP_UserGroup_Role_Brand_Map_Archbak] (
    [I_UserGroup_Role_Map_ID] INT  IDENTITY (1, 1) NOT NULL,
    [I_User_Group_Master_ID]  INT  NOT NULL,
    [I_Role_ID]               INT  NOT NULL,
    [I_Brand_ID]              INT  NOT NULL,
    [Is_Active]               BIT  NULL,
    [Dt_created_Dt]           DATE NULL,
    [I_Created_By]            INT  NULL
);

