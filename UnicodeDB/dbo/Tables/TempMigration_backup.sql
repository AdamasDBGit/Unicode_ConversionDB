CREATE TABLE [dbo].[TempMigration_backup] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [BranchID]    FLOAT (53)     NULL,
    [StudentID]   NVARCHAR (255) NULL,
    [SMBarcode]   NVARCHAR (255) NULL,
    [MoveOrderId] FLOAT (53)     NULL,
    [ItemCode]    FLOAT (53)     NULL,
    [Status]      NVARCHAR (255) NULL
);

