CREATE TABLE [dbo].[Tbl_KPMG_PoDetailItems_KP] (
    [Fld_KPMG_PoDetail_Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_PoPr_Id]             INT            NOT NULL,
    [Fld_KPMG_Barcode]             NVARCHAR (MAX) NULL,
    [Fld_KPMG_Status]              INT            NOT NULL,
    [OracleLinieId]                NVARCHAR (MAX) NULL,
    [Fld_KPMG_OracleTransactionId] NVARCHAR (MAX) NULL
);

