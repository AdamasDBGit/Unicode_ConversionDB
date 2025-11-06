CREATE TABLE [dbo].[Tbl_KPMG_PoDetails] (
    [Fld_KPMG_PoPr_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_PO_Id]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_PR_Id]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Item_Id]       NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Qty]           INT            NOT NULL,
    [Fld_KPMG_PO_Date]       DATETIME       CONSTRAINT [DF_Tbl_KPMG_PoDetails_Fld_KPMG_PO_Date] DEFAULT (getdate()) NOT NULL,
    [Fld_KPMG_Delivery_Date] DATETIME       CONSTRAINT [DF_Tbl_KPMG_PoDetails_Fld_KPMG_Delivery_Date] DEFAULT (getdate()+(15)) NOT NULL,
    [Fld_KPMG_Status]        INT            CONSTRAINT [DF_Tbl_KPMG_PoDetails_IsAccepted] DEFAULT ((0)) NOT NULL,
    [OraclePoId]             NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_Tbl_KPMG_PoDetails_Fld_KPMG_PoPr_Id] PRIMARY KEY CLUSTERED ([Fld_KPMG_PoPr_Id] ASC)
);

