CREATE TABLE [dbo].[Tbl_KPMG_StockMaster_MigrationBackup] (
    [Fld_KPMG_Stock_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Branch_Id]      INT            NOT NULL,
    [Fld_KPMG_FromBranch_Id]  INT            NOT NULL,
    [Fld_KPMG_ItemCode]       NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_LastRecvDate]   DATETIME       NOT NULL,
    [Fld_KPMG_Mo_Id]          INT            NOT NULL,
    [Fld_KPMG_IsMo]           INT            NOT NULL,
    [Fld_KPMG_OracleMoNumber] NVARCHAR (255) NULL
);

