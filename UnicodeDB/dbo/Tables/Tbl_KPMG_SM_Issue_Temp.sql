CREATE TABLE [dbo].[Tbl_KPMG_SM_Issue_Temp] (
    [Fld_KPMG_SMIssue_Id]       INT            IDENTITY (1, 1) NOT NULL,
    [Fld_KPMG_Barcode]          NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_ItemCode]         NVARCHAR (MAX) NOT NULL,
    [Fld_KPMG_IssueDate]        DATETIME       NOT NULL,
    [Fld_KPMG_StudentId]        INT            NOT NULL,
    [Fld_KPMG_I_Installment_No] INT            NOT NULL,
    [Fld_KPMG_Context]          NVARCHAR (255) NULL
);

