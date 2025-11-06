CREATE TABLE [dbo].[T_ERP_NotificationMaster] (
    [Notification_ID]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [Notification_AcademicSessionID] INT            NULL,
    [Notification_Title]             NVARCHAR (255) NULL,
    [Notification_Desc]              NVARCHAR (MAX) NULL,
    [Notification_Type]              INT            NULL,
    [Notification_BrandID]           INT            NULL,
    [Notification_EventID]           INT            NULL,
    [Notification_PriorityID]        INT            NULL,
    [Notification_Date]              DATETIME       NULL,
    [Notification_Time]              TIME (7)       NULL,
    [Created_By]                     INT            NULL,
    [Created_Date]                   DATETIME       NULL,
    [Updated_By]                     INT            NULL,
    [Updated_Date]                   DATETIME       NULL,
    [IssActive]                      BIT            NULL,
    [Is_Deleted]                     BIT            NULL,
    [Is_All]                         BIT            NULL,
    [Is_Student]                     BIT            NULL,
    [Is_Teacher]                     BIT            NULL,
    CONSTRAINT [PK_T_ERP_NotificationMaster] PRIMARY KEY CLUSTERED ([Notification_ID] ASC)
);

