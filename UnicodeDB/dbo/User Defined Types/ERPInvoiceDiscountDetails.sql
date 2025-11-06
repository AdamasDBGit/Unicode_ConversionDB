CREATE TYPE [dbo].[ERPInvoiceDiscountDetails] AS TABLE (
    [InvoiceHeaderID] INT            NULL,
    [S_invoice_No]    VARCHAR (MAX)  NULL,
    [Discount_Amount] DECIMAL (8, 2) NULL,
    [Discount_Rate]   INT            NULL,
    [InvoiceDetailID] INT            NULL);

