CREATE TABLE [dbo].[T_ERP_NotificationType] (
    [I_NotificationType_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_NotificationType_Name] NVARCHAR (MAX) NOT NULL,
    [Is_Active]               BIT            CONSTRAINT [DF_T_ERP_NotificationType_Is_Active] DEFAULT ((1)) NULL,
    [I_Status]                BIT            CONSTRAINT [DF_T_ERP_NotificationType_I_Status] DEFAULT ((0)) NULL,
    [I_CreatedBy]             INT            NULL,
    [Dtt_CreatedAt]           DATETIME       CONSTRAINT [DF_T_ERP_NotificationType_Dtt_CreatedAt] DEFAULT (getdate()) NULL,
    [I_UpdatedBy]             INT            NULL,
    [Dtt_UpdatedAt]           DATETIME       CONSTRAINT [DF_T_ERP_NotificationType_Dtt_UpdatedAt] DEFAULT (getdate()) NULL,
    [inBrandId]               INT            NULL,
    [IsDefaultProvided]       BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_T_ERP_NotificationType] PRIMARY KEY CLUSTERED ([I_NotificationType_ID] ASC)
);

