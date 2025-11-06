CREATE TABLE [dbo].[T_NotificationTemplate] (
    [inNotificationTemplateID] INT            IDENTITY (1, 1) NOT NULL,
    [inNotificationTypeID]     INT            NULL,
    [inNotificationCategoryID] INT            NULL,
    [stTemplateTitle]          NVARCHAR (200) NULL,
    [stEmailSubject]           NVARCHAR (200) NULL,
    [stSMSTemplateMessage]     NVARCHAR (MAX) NULL,
    [stPushTemplateMessage]    NVARCHAR (MAX) NULL,
    [stEmailTemplateMessage]   NVARCHAR (MAX) NULL,
    [stDeliveryChannelID]      NVARCHAR (MAX) NOT NULL,
    [I_Deleted]                INT            NULL,
    [I_Status]                 INT            NULL,
    [I_IsApproved]             INT            NULL,
    [inCreatedBy]              INT            NULL,
    [dtCreatedDate]            DATETIME       NULL,
    [stPushTitle]              NVARCHAR (100) NULL,
    [inNotificationType]       INT            NULL,
    [inEvent]                  INT            NULL,
    PRIMARY KEY CLUSTERED ([inNotificationTemplateID] ASC)
);

