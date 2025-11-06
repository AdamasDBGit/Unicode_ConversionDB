CREATE TABLE [dbo].[T_User_Type_Master] (
    [I_User_Type_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_User_Type_Code] NVARCHAR (MAX) NULL,
    [S_User_Type_Desc] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_User_Type_Mast__0A9E6132] PRIMARY KEY CLUSTERED ([I_User_Type_ID] ASC)
);

