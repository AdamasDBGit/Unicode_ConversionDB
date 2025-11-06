CREATE TABLE [dbo].[Tbl_KPMG_StockDetails] (
    [Fld_KPMG_StockDet_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Stock_Id]       INT            NOT NULL,
    [Fld_KPMG_Barcode]        NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_isIssued]       INT            CONSTRAINT [DF_Tbl_KPMG_StockDetails_Fld_KPMG_isIssued] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_Status]         INT            CONSTRAINT [DF_Tbl_KPMG_StockDetails_Fld_KPMG_Status] DEFAULT ((1)) NOT NULL,
    [Fld_KPMG_OracleMoLineId] NVARCHAR (255) CONSTRAINT [DF__Tbl_KPMG___Fld_K__2D8A0CC1] DEFAULT ('') NULL,
    [Fld_KPMG_Date]           DATETIME       CONSTRAINT [DF_Tbl_KPMG_StockDetails_Fld_KPMG_Date] DEFAULT (getdate()) NOT NULL
);

