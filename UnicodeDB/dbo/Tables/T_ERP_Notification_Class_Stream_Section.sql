CREATE TABLE [dbo].[T_ERP_Notification_Class_Stream_Section] (
    [inNotificationCSSID]      INT              IDENTITY (1, 1) NOT NULL,
    [unNotificationCSSID]      UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inNotificationScheduleID] INT              NULL,
    [inSchoolProgramId]        INT              NULL,
    [inClassId]                INT              NULL,
    [inStreamId]               INT              NULL,
    [inSectionId]              INT              NULL,
    PRIMARY KEY CLUSTERED ([inNotificationCSSID] ASC)
);

