CREATE TYPE [dbo].[UT_NotificationComponents] AS TABLE (
    [Notification_ID]              INT            NULL,
    [Notification_ApplicableForID] INT            NULL,
    [Notification_ApplicableID]    INT            NULL,
    [Notification_ClassGroupID]    INT            NULL,
    [Notification_ClassID]         INT            NULL,
    [Notification_StreamID]        INT            NULL,
    [Notification_SectionID]       INT            NULL,
    [Notification_StudentID]       INT            NULL,
    [Notification_DeliveryMethod]  INT            NULL,
    [Notification_Attachments]     NVARCHAR (MAX) NULL);

