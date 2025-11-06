CREATE TABLE [dbo].[Tbl_KPMG_PoDetails_KP] (
    [Fld_KPMG_PoPr_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_PO_Id]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_PR_Id]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Item_Id]       NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Qty]           INT            NOT NULL,
    [Fld_KPMG_PO_Date]       DATETIME       NOT NULL,
    [Fld_KPMG_Delivery_Date] DATETIME       NOT NULL,
    [Fld_KPMG_Status]        INT            NOT NULL,
    [OraclePoId]             NVARCHAR (MAX) NULL
);

