CREATE TABLE [dbo].[Tbl_KPMG_SM_Map] (
    [Fld_KPMG_Map_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_ItemCode]   NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Barcode]    NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_CourseName] NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_PR]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_PO]         NVARCHAR (MAX) NULL,
    [Fld_KPMG_GrnNunber]  NVARCHAR (MAX) NOT NULL
);

