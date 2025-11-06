CREATE TABLE [dbo].[ExternalPaymentdetails] (
    [id]                 NVARCHAR (MAX) NULL,
    [amount]             DECIMAL (8, 2) NULL,
    [status]             NVARCHAR (MAX) NULL,
    [order_id]           NVARCHAR (MAX) NULL,
    [invoice_id]         NVARCHAR (MAX) NULL,
    [amount_refunded]    DECIMAL (8, 2) NULL,
    [amount_transferred] DECIMAL (8, 2) NULL,
    [refund_status]      BIT            NULL,
    [captured]           BIT            NULL
);

