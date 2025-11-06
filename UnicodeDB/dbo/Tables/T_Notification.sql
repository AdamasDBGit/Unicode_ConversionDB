CREATE TABLE [dbo].[T_Notification] (
    [I_NotificationSchedule_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_NotificationTemplate_ID] INT            NOT NULL,
    [I_RecipientUserType]       INT            NOT NULL,
    [I_SenderUserType]          INT            NOT NULL,
    [I_Recipient_ID]            INT            NOT NULL,
    [I_Sender_ID]               INT            NOT NULL,
    [S_Url]                     NVARCHAR (MAX) NOT NULL,
    [S_Title]                   NVARCHAR (200) NOT NULL,
    [S_Message]                 NVARCHAR (MAX) NULL,
    [S_Type]                    NCHAR (10)     NULL,
    [I_IsSent]                  INT            NULL,
    [Dt_SentDate]               DATETIME       NULL,
    [I_NotificationState]       INT            NULL,
    [Is_IsTrash]                INT            NULL,
    [Dt_SeenDate]               DATETIME       NULL,
    [Dt_ReadDate]               DATETIME       NULL,
    [Dt_CreatedAt]              DATETIME       NULL,
    [S_CreatedBy]               NVARCHAR (50)  NULL,
    CONSTRAINT [PK_T_Notification] PRIMARY KEY CLUSTERED ([I_NotificationSchedule_ID] ASC)
);

