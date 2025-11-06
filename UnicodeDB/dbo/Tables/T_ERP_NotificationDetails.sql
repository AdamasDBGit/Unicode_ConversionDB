CREATE TABLE [dbo].[T_ERP_NotificationDetails] (
    [Notification_DetID]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [Notification_ID]              BIGINT         NULL,
    [Notification_ApplicableForID] INT            NULL,
    [Notification_ApplicableID]    INT            NULL,
    [Notification_ClassGroupID]    INT            NULL,
    [Notification_ClassID]         INT            NULL,
    [Notification_StreamID]        INT            NULL,
    [Notification_SectionID]       INT            NULL,
    [Notification_StudentID]       INT            NULL,
    [Notification_DeliveryMethod]  INT            NULL,
    [Notification_Attachments]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_T_ERP_NotificationDetails] PRIMARY KEY CLUSTERED ([Notification_DetID] ASC)
);

