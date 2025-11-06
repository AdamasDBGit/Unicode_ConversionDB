CREATE TABLE [dbo].[Tbl_KPMG_LoadAmount] (
    [Amount_Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Branch_Id] INT            CONSTRAINT [DF_Tbl_KPMG_LoadAmount_Fld_KPMG_To_Center] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_Itemcode]  NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Amount]    INT            CONSTRAINT [DF_Table_1_Fld_KPMG_MoItem_Id] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_Mo_Id]     INT            CONSTRAINT [DF_Tbl_KPMG_LoadAmount_Fld_KPMG_Mo_Id] DEFAULT ((0)) NOT NULL,
    [AllotedDate]        DATETIME       CONSTRAINT [DF_Tbl_KPMG_LoadAmount_AllotedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Tbl_KPMG_LoadAmount] PRIMARY KEY CLUSTERED ([Amount_Id] ASC)
);

