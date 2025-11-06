CREATE TABLE [SelfService].[T_OnAccount_Due] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [BrandID]             INT             NULL,
    [CenterID]            INT             NULL,
    [I_Student_Detail_ID] INT             NOT NULL,
    [OnAccReceiptTypeID]  INT             NULL,
    [Amount]              DECIMAL (14, 2) NULL,
    [Tax]                 DECIMAL (14, 2) NULL,
    [TotalAmount]         DECIMAL (14, 2) NULL,
    [DueOn]               DATETIME        NULL,
    [PaidOn]              DATETIME        NULL,
    [ReceiptHeaderID]     INT             NULL,
    [StatusID]            INT             NULL,
    [InvoiceNo]           VARCHAR (MAX)   NULL
);

