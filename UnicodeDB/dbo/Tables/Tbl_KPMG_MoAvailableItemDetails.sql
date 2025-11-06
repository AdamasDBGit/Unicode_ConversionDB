CREATE TABLE [dbo].[Tbl_KPMG_MoAvailableItemDetails] (
    [Fld_KPMG_MoItem_Id] INT            NOT NULL,
    [Fld_KPMG_MoAvlId]   INT            NULL,
    [Fld_KPMG_ItemCode]  NVARCHAR (255) NULL,
    [Fld_KPMG_Quantity]  INT            NULL,
    CONSTRAINT [pk_Fld_KPMG_MoItem_Id_Tbl_KPMG_MoAvailableItemDetails] PRIMARY KEY CLUSTERED ([Fld_KPMG_MoItem_Id] ASC)
);

