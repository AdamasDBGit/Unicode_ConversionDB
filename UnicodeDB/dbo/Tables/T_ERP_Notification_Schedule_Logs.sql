CREATE TABLE [dbo].[T_ERP_Notification_Schedule_Logs] (
    [inNotificationLogsID]     INT              IDENTITY (1, 1) NOT NULL,
    [unNotificationLogsID]     UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inNotificationScheduleID] INT              NULL,
    [stStudentId]              NVARCHAR (200)   NULL,
    [stStudentName]            NVARCHAR (200)   NULL,
    [stTeacherId]              NVARCHAR (200)   NULL,
    [stTeacherName]            NVARCHAR (200)   NULL,
    [inUserId]                 INT              NULL,
    [stUserName]               NVARCHAR (200)   NULL,
    [inTemplateId]             INT              NULL,
    [stTemplateTitle]          NVARCHAR (200)   NULL,
    [stSMSTemplateMessage]     NVARCHAR (MAX)   NULL,
    [stPushTemplateMessage]    NVARCHAR (MAX)   NULL,
    [stEmailSubject]           NVARCHAR (200)   NULL,
    [stEmailTemplateMessage]   NVARCHAR (MAX)   NULL,
    [stNotificationStatus]     NVARCHAR (MAX)   NULL,
    [stErrorMessage]           NVARCHAR (MAX)   NULL,
    [stRenderMessageBody]      NVARCHAR (MAX)   NULL,
    [dtCreatedDate]            DATETIME         NULL,
    [inCreatedBy]              INT              NULL,
    [inDeliveryChannelId]      INT              NULL,
    [stPushTitle]              NVARCHAR (100)   NULL,
    [inSendStatus]             INT              NULL,
    [stParentToken]            NVARCHAR (200)   NULL,
    [inReadStatus]             INT              DEFAULT ((0)) NOT NULL,
    [stParentName]             NVARCHAR (100)   NULL,
    [inParentMasterID]         INT              NULL,
    [st_firebasetoken]         NVARCHAR (200)   NULL,
    PRIMARY KEY CLUSTERED ([inNotificationLogsID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_TERP_Notif_Sched_Logs_ScheduleID]
    ON [dbo].[T_ERP_Notification_Schedule_Logs]([inNotificationScheduleID] ASC)
    INCLUDE([stStudentId], [stStudentName], [inUserId], [stUserName]);

