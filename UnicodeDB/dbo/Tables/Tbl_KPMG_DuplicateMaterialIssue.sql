CREATE TABLE [dbo].[Tbl_KPMG_DuplicateMaterialIssue] (
    [Fld_KPMG_ReceiptNo]       NVARCHAR (255)  NULL,
    [Fld_KPMG_Student_Id]      INT             NULL,
    [Fld_KPMG_StudentBarCode]  NVARCHAR (255)  NULL,
    [Fld_KPMG_Price]           DECIMAL (10, 2) NULL,
    [Fld_KPMG_Tax]             DECIMAL (10, 2) NULL,
    [Fld_KPMG_Total]           DECIMAL (10, 2) NULL,
    [Fld_KPMG_Receipt_Date]    DATETIME        NULL,
    [Fld_Kpmg_ReIssuedBarCode] NVARCHAR (255)  NULL
);

