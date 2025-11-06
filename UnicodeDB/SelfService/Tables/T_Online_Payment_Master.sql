CREATE TABLE [SelfService].[T_Online_Payment_Master] (
    [OnlinePaymentID]    INT             IDENTITY (1, 1) NOT NULL,
    [BrandID]            INT             NULL,
    [CenterID]           INT             NULL,
    [TransactionNo]      VARCHAR (MAX)   NULL,
    [TransactionDate]    DATETIME        NULL,
    [TransactionStatus]  VARCHAR (MAX)   NULL,
    [TransactionSource]  VARCHAR (MAX)   NULL,
    [TransactionMode]    VARCHAR (MAX)   NULL,
    [Amount]             DECIMAL (14, 2) NULL,
    [Tax]                DECIMAL (14, 2) NULL,
    [TotalAmount]        DECIMAL (14, 2) NULL,
    [InvoiceHeaderID]    INT             NULL,
    [OnAccReceiptTypeID] INT             NULL,
    [ReceiptHeaderID]    INT             NULL,
    [ReceiptDate]        DATETIME        NULL,
    [StatusID]           INT             NULL,
    [StudentID]          VARCHAR (MAX)   NULL,
    [OnAccDueID]         INT             NULL
);

