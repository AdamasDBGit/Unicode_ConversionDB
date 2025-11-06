CREATE TABLE [dbo].[Tbl_KPMG_SM_Issue] (
    [Fld_KPMG_SMIssue_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Barcode]          NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_ItemCode]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_IssueDate]        DATETIME       CONSTRAINT [DF_Tbl_KPMG_SM_Issue_Fld_KPMG_IssueDate] DEFAULT (getdate()) NOT NULL,
    [Fld_KPMG_StudentId]        INT            NOT NULL,
    [Fld_KPMG_I_Installment_No] INT            CONSTRAINT [DF_Tbl_KPMG_SM_Issue_Fld_KPMG_I_Installment_No] DEFAULT ((1)) NOT NULL,
    [Fld_KPMG_Context]          NVARCHAR (255) NULL,
    CONSTRAINT [pk_Tbl_KPMG_SM_Issue_Fld_KPMG_SMIssue_Id] PRIMARY KEY CLUSTERED ([Fld_KPMG_SMIssue_Id] ASC)
);

