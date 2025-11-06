CREATE TABLE [dbo].[Tbl_KPMG_MoAvailableItems] (
    [Fld_KPMG_MoAvlId]     INT IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Mo_Id]       INT NOT NULL,
    [Fld_KPMG_Mo_BranchId] INT NOT NULL,
    CONSTRAINT [pk_Fld_KPMG_MoAvlId_Tbl_KPMG_MoAvailableItems] PRIMARY KEY CLUSTERED ([Fld_KPMG_MoAvlId] ASC)
);

