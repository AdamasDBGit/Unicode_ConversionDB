CREATE TABLE [dbo].[T_ERP_NotificationPriority] (
    [I_NotificationPriority_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_NotificationPriority_Name] NVARCHAR (MAX) NOT NULL,
    [Is_Active]                   BIT            CONSTRAINT [DF_T_ERP_NotificationPriority_Is_Active] DEFAULT ((1)) NOT NULL,
    [I_Status]                    BIT            CONSTRAINT [DF_T_ERP_NotificationPriority_I_Status] DEFAULT ((0)) NOT NULL,
    [I_CreatedBy]                 INT            NULL,
    [Dtt_CreatedAt]               DATETIME       CONSTRAINT [DF_T_ERP_NotificationPriority_Dtt_CreatedAt] DEFAULT (getdate()) NULL,
    [IUpdatedBy]                  INT            NULL,
    [Dtt_UpdatedAt]               DATETIME       CONSTRAINT [DF_T_ERP_NotificationPriority_Dtt_UpdatedAt] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_T_ERP_NotificationPriority] PRIMARY KEY CLUSTERED ([I_NotificationPriority_ID] ASC)
);

