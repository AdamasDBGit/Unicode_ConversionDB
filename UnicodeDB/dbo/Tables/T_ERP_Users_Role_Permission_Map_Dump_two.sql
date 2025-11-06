CREATE TABLE [dbo].[T_ERP_Users_Role_Permission_Map_Dump_two] (
    [I_Users_Role_Permission_MapID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [I_User_Id]                     INT            NULL,
    [Role_Id]                       INT            NULL,
    [Permission_ID]                 INT            NULL,
    [User_Group_ID]                 INT            NULL,
    [Brand_ID]                      INT            NULL,
    [Is_Active]                     BIT            NULL,
    [I_Created_By]                  INT            NULL,
    [I_Modified_By]                 INT            NULL,
    [dt_Created_Dt]                 DATETIME       NULL,
    [Dt_Modified_Dt]                DATETIME       NULL,
    [PermisionUnique]               NVARCHAR (MAX) NULL
);

