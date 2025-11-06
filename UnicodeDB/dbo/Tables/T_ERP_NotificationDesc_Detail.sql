CREATE TABLE [dbo].[T_ERP_NotificationDesc_Detail] (
    [Notification_DescDetID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [Notification_ID]        BIGINT         NULL,
    [Notification_DescDet]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_NotificationDesc_Detail] PRIMARY KEY CLUSTERED ([Notification_DescDetID] ASC)
);

