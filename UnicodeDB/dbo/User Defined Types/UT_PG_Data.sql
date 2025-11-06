CREATE TYPE [dbo].[UT_PG_Data] AS TABLE (
    [PGDataSourceType]   VARCHAR (MAX)  NULL,
    [PayID]              VARCHAR (MAX)  NULL,
    [amount]             DECIMAL (8, 2) NULL,
    [status]             VARCHAR (MAX)  NULL,
    [order_id]           VARCHAR (MAX)  NULL,
    [invoice_id]         VARCHAR (MAX)  NULL,
    [amount_refunded]    DECIMAL (8, 2) NULL,
    [amount_transferred] DECIMAL (8, 2) NULL,
    [refund_status]      VARCHAR (MAX)  NULL,
    [captured]           BIT            NULL,
    [CreatedAt]          DATETIME       NULL);

