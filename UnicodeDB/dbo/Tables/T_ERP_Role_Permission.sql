CREATE TABLE [dbo].[T_ERP_Role_Permission] (
    [I_Role_Permission_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Role_ID]            INT      NOT NULL,
    [I_Menu_Permission_ID] INT      NOT NULL,
    [I_CreatedBy]          INT      NULL,
    [Dt_CreatedAt]         DATETIME CONSTRAINT [DF__T_ERP_Rol__Dt_Cr__40A66949] DEFAULT (getdate()) NULL,
    [Dt_ModifiedAt]        DATETIME NULL,
    [I_ModifiedBy]         INT      NULL,
    [Is_Active]            BIT      CONSTRAINT [DF__T_ERP_Rol__Is_Ac__419A8D82] DEFAULT ((1)) NULL
);

