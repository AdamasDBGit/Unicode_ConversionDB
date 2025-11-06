CREATE TABLE [dbo].[USP_ERP_SaveNotificationDetailsWithLogs_Debug] (
    [LogId]       INT            IDENTITY (1, 1) NOT NULL,
    [StepName]    NVARCHAR (200) NULL,
    [StepMessage] NVARCHAR (MAX) NULL,
    [CreatedOn]   DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([LogId] ASC)
);

