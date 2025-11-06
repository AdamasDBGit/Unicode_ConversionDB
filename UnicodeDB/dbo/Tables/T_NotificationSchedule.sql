CREATE TABLE [dbo].[T_NotificationSchedule] (
    [I_NotificationSchedule_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [S_Title]                    NVARCHAR (50)  NULL,
    [S_MessageBody]              NVARCHAR (MAX) NOT NULL,
    [I_NotificationTemplate_ID]  INT            NULL,
    [I_NotificationType_ID]      INT            NULL,
    [I_NotificationGroupType_ID] INT            NOT NULL,
    [Dt_ScheduleDateTime]        DATETIME       NULL,
    [Dt_CreatedAt]               DATETIME       NULL,
    [S_CreatedBy]                NVARCHAR (50)  NULL,
    CONSTRAINT [PK_T_NotificationSchedule] PRIMARY KEY CLUSTERED ([I_NotificationSchedule_ID] ASC)
);

