CREATE TABLE [dbo].[T_Online_Payment_Audit] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [BrandName]         NVARCHAR (MAX)  NULL,
    [StudentID]         NVARCHAR (MAX)  NULL,
    [ReceiptDate]       DATETIME        NULL,
    [CentreID]          INT             NULL,
    [PaymentDetailsXML] XML             NULL,
    [ReceiptAmount]     NUMERIC (18, 2) NULL,
    [ReceiptTaxAmount]  NUMERIC (18, 2) NULL,
    [ReceiptType]       INT             NULL,
    [TransactionCode]   NVARCHAR (MAX)  NULL,
    [ExtReceiptNo]      NVARCHAR (MAX)  NULL,
    [SourceName]        NVARCHAR (MAX)  NULL,
    [CreatedOn]         DATETIME        NULL
);

