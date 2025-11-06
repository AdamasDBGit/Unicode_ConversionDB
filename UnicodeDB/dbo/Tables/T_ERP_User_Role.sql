CREATE TABLE [dbo].[T_ERP_User_Role] (
    [I_User_Role_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_User_ID]      INT      NOT NULL,
    [I_Role_ID]      INT      NOT NULL,
    [I_CreatedBy]    INT      NULL,
    [Dt_CreatedAt]   DATETIME CONSTRAINT [DF__T_ERP_Use__Dt_Cr__428EB1BB] DEFAULT (getdate()) NULL,
    [Dt_ModifiedAt]  DATETIME NULL,
    [I_ModifiedBy]   INT      NULL,
    [Is_Active]      BIT      CONSTRAINT [DF__T_ERP_Use__Is_Ac__4382D5F4] DEFAULT ((1)) NULL
);

