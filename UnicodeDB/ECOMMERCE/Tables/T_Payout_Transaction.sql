CREATE TABLE [ECOMMERCE].[T_Payout_Transaction] (
    [PayoutTransactionID] INT             IDENTITY (1, 1) NOT NULL,
    [TransactionNo]       VARCHAR (MAX)   NOT NULL,
    [TransactionDate]     DATETIME        NULL,
    [TransactionSource]   VARCHAR (MAX)   NULL,
    [TransactionMode]     VARCHAR (MAX)   NULL,
    [TransactionStatus]   VARCHAR (MAX)   NULL,
    [TransactionAmount]   DECIMAL (14, 2) NULL,
    [TransactionTax]      DECIMAL (14, 2) NULL,
    [FeeScheduleID]       INT             NULL,
    [IsCompleted]         BIT             NULL,
    [CreatedOn]           DATETIME        NULL,
    [CreatedBy]           VARCHAR (MAX)   NULL,
    [UpdatedOn]           DATETIME        NULL,
    [UpdatedBy]           VARCHAR (MAX)   NULL,
    [CompletedOn]         DATETIME        NULL,
    [StatusID]            INT             NULL,
    [ReceiptHeaderID]     INT             NULL,
    [CustomerID]          VARCHAR (MAX)   NULL
);

