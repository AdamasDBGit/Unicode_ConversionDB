CREATE TABLE [dbo].[Tbl_KPMG_StudentInstallment] (
    [StudentId]         INT      NULL,
    [BranchId]          INT      NULL,
    [InstallmentNo]     INT      NULL,
    [InstallmentPaid]   CHAR (1) NULL,
    [IsMoveOrderCreted] CHAR (1) CONSTRAINT [DF__Tbl_KPMG___IsMov__5B3BC8D8] DEFAULT ('N') NULL,
    [MoveOrderId]       INT      NULL,
    [InvoiceParentId]   INT      CONSTRAINT [DF__Tbl_KPMG___Invoi__5C2FED11] DEFAULT ((0)) NULL
);

