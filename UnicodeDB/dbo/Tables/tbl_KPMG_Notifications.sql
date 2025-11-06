CREATE TABLE [dbo].[tbl_KPMG_Notifications] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [NotificationMessage] NVARCHAR (MAX) NULL,
    [TaskMessage]         NVARCHAR (MAX) NULL,
    [UniqueKey]           NVARCHAR (MAX) NULL,
    [BranchId]            INT            NULL,
    [ItemAmount]          NVARCHAR (MAX) NULL
);

