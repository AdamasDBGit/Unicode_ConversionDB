CREATE TABLE [dbo].[T_ERP_NotificationDelivery] (
    [I_NotificationDelivery_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_NotificationDelivery_Name] NVARCHAR (MAX) NOT NULL,
    [Is_Active]                   BIT            CONSTRAINT [DF_T_ERP_NotificationDelivery_Is_Active] DEFAULT ((1)) NULL,
    [I_Status]                    BIT            CONSTRAINT [DF_T_ERP_NotificationDelivery_I_Status] DEFAULT ((0)) NULL,
    [I_CreatedBy]                 INT            NULL,
    [Dtt_CreatedAt]               DATETIME       CONSTRAINT [DF_T_ERP_NotificationDelivery_Dtt_CreatedAt] DEFAULT (getdate()) NULL,
    [I_UpdatedBy]                 INT            NULL,
    [Dtt_UpdatedAt]               DATETIME       CONSTRAINT [DF_T_ERP_NotificationDelivery_Dtt_UpdatedAt] DEFAULT (getdate()) NULL,
    [stCssClass]                  NVARCHAR (200) NULL,
    CONSTRAINT [PK_T_ERP_NotificationDelivery] PRIMARY KEY CLUSTERED ([I_NotificationDelivery_ID] ASC)
);

