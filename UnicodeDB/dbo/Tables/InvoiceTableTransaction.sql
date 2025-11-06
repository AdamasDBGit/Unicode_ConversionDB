CREATE TABLE [dbo].[InvoiceTableTransaction] (
    [TransactionNo]   NVARCHAR (MAX) NULL,
    [FeeScheduleID]   INT            NULL,
    [InvoiceDetailID] INT            NULL,
    [ReceiptDetailID] INT            NULL,
    [AmountPaid]      DECIMAL (8, 2) NULL,
    [Dt_Created]      DATETIME       NULL
);

