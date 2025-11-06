CREATE TABLE [dbo].[Oracle_Reports] (
    [ID]                         INT             IDENTITY (1, 1) NOT NULL,
    [Start_Date]                 DATE            NULL,
    [End_Date]                   DATE            NULL,
    [Is_Synced_Started]          BIT             NULL,
    [Sync_StartDate]             DATE            NULL,
    [Is_Sync_Complete]           BIT             NULL,
    [Sync_By]                    INT             NULL,
    [Reports_for_Sync_Reconcile] NVARCHAR (1000) NULL,
    [Is_Reconcile_Checked]       BIT             NULL,
    [Reconcile_Checked_By]       INT             NULL,
    [Reconcile_Check_Date]       DATE            NULL,
    [Is_GLPush_Done]             BIT             NULL,
    [GLPush_Date]                DATE            NULL,
    [GLPush_By]                  INT             NULL,
    [GST_Reports]                NVARCHAR (MAX)  NULL,
    [Action]                     INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

