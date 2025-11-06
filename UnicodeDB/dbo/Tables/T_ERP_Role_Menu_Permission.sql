CREATE TABLE [dbo].[T_ERP_Role_Menu_Permission] (
    [I_Role_Menu_PermissionID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Role_ID]                INT      NULL,
    [I_Menu_ID]                INT      NULL,
    [Is_Grant_View]            BIT      NULL,
    [Is_Grant_Edit]            BIT      NULL,
    [I_CreatedBy]              INT      NULL,
    [Dt_CreatedAt]             DATETIME CONSTRAINT [DF__T_ERP_Rol__Dt_Cr__5789CEA1] DEFAULT (getdate()) NULL,
    [Dt_ModifiedAt]            DATETIME NULL,
    [I_ModifiedBy]             INT      NULL,
    [Is_Active]                BIT      CONSTRAINT [DF__T_ERP_Rol__Is_Ac__587DF2DA] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Ro__7566E71BFC207DE7] PRIMARY KEY CLUSTERED ([I_Role_Menu_PermissionID] ASC)
);

