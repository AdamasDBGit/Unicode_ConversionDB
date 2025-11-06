CREATE TABLE [dbo].[Tbl_KPMG_StockDetails_temp] (
    [Fld_KPMG_StockDet_Id]    INT            NOT NULL,
    [Fld_KPMG_Stock_Id]       INT            NOT NULL,
    [Fld_KPMG_Barcode]        NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_isIssued]       INT            NOT NULL,
    [Fld_KPMG_Status]         INT            NOT NULL,
    [Fld_KPMG_OracleMoLineId] NVARCHAR (255) NULL,
    [Fld_KPMG_Date]           DATETIME       NOT NULL
);

