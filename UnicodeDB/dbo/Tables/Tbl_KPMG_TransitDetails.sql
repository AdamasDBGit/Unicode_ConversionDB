CREATE TABLE [dbo].[Tbl_KPMG_TransitDetails] (
    [Fld_KPMG_TransitDetails] INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Transist_Id]    INT            NOT NULL,
    [Fld_KPMG_Barcode]        NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_Status]         INT            CONSTRAINT [DF_Tbl_KPMG_TransitDetails_Fld_KPMG_Status] DEFAULT ((0)) NOT NULL,
    [Fld_KPMG_Remarks]        NVARCHAR (MAX) NULL
);

