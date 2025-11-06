CREATE TABLE [SelfService].[T_Invoice_Payment_Details] (
    [InvoicePaymentID]      INT             IDENTITY (1, 1) NOT NULL,
    [OnlinePaymentID]       INT             NOT NULL,
    [InvoiceNo]             VARCHAR (MAX)   NULL,
    [InvoiceChildDetailIDs] VARCHAR (MAX)   NULL,
    [Amount]                DECIMAL (14, 2) NULL,
    [Tax]                   DECIMAL (14, 2) NULL,
    [TotalAmount]           DECIMAL (14, 2) NULL,
    [StatusID]              INT             NULL
);

