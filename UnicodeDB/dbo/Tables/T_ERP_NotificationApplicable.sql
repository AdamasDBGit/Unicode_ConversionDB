CREATE TABLE [dbo].[T_ERP_NotificationApplicable] (
    [I_NotificationApplicable_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_NotificationApplicable_Name] NVARCHAR (MAX) NULL,
    [Is_Active]                     BIT            CONSTRAINT [DF_T_ERP_NotificationApplicable_Is_Active] DEFAULT ((1)) NULL,
    [I_Status]                      BIT            CONSTRAINT [DF_T_ERP_NotificationApplicable_I_Status] DEFAULT ((0)) NULL,
    [I_CreatedBy]                   INT            NULL,
    [Dtt_CreatedAt]                 DATETIME       CONSTRAINT [DF_T_ERP_NotificationApplicable_Dtt_CreatedAt] DEFAULT (getdate()) NULL,
    [I_UpdatedBy]                   INT            NULL,
    [Dtt_UpdatedAt]                 DATETIME       CONSTRAINT [DF_T_ERP_NotificationApplicable_Dtt_UpdatedAt] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_T_ERP_NotificationApplicable] PRIMARY KEY CLUSTERED ([I_NotificationApplicable_ID] ASC)
);

