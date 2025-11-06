CREATE TABLE [dbo].[T_ERP_NotificationApplicableTo] (
    [I_NotificationApplicableTo_ID]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [I_NotificationApplicable_ID]     BIGINT         NULL,
    [S_NotificationApplicableTo_Name] NVARCHAR (MAX) NULL,
    [Is_Active]                       BIT            NULL,
    [I_Status]                        BIT            NULL,
    [I_CreatedBy]                     INT            NULL,
    [Dtt_CreatedAt]                   DATETIME       NULL,
    [I_UpdatedBy]                     INT            NULL,
    [Dtt_UpdatedAt]                   DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_NotificationApplicableTo] PRIMARY KEY CLUSTERED ([I_NotificationApplicableTo_ID] ASC)
);

