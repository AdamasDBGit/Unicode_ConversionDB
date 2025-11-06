CREATE TABLE [Role].[T_User_Roles] (
    [I_User_Role_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [S_Role_Name]        NVARCHAR (50)  NULL,
    [S_Role_Description] NVARCHAR (MAX) NULL,
    [I_Status]           INT            DEFAULT ((1)) NULL,
    [Dt_Created_At]      DATETIME       NULL,
    [S_Created_By]       NVARCHAR (50)  NULL
);

