CREATE TABLE [dbo].[Tbl_KPMG_PoDetailItems] (
    [Fld_KPMG_PoDetail_Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_PoPr_Id]             INT            NOT NULL,
    [Fld_KPMG_Barcode]             NVARCHAR (MAX) NULL,
    [Fld_KPMG_Status]              INT            CONSTRAINT [DF_Tbl_KPMG_PoDetailItems_Fld_KPMG_Status] DEFAULT ((0)) NOT NULL,
    [OracleLinieId]                NVARCHAR (MAX) NULL,
    [Fld_KPMG_OracleTransactionId] NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_Tbl_KPMG_PoDetailItems_Fld_KPMG_PoPr_Id] PRIMARY KEY CLUSTERED ([Fld_KPMG_PoDetail_Id] ASC)
);

