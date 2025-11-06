CREATE TABLE [SMManagement].[T_Stock_Master] (
    [StockID]         INT           IDENTITY (1, 1) NOT NULL,
    [ItemCode]        VARCHAR (16)  NULL,
    [ItemDescription] VARCHAR (100) NULL,
    [BarcodePrefix]   VARCHAR (10)  NULL,
    [BarcodeSerial]   VARCHAR (10)  NULL,
    [Barcode]         VARCHAR (20)  NULL,
    [PR]              VARCHAR (20)  NULL,
    [PO]              VARCHAR (20)  NULL,
    [GRN]             VARCHAR (20)  NULL,
    [StatusID]        INT           NULL,
    [ItemType]        INT           NULL,
    [IsScheduled]     BIT           NULL,
    [ItemCount]       INT           NULL,
    [BrandID]         INT           NULL,
    [CreatedBy]       VARCHAR (50)  NULL,
    [CreatedOn]       DATETIME      NULL,
    [UpdatedBy]       VARCHAR (50)  NULL,
    [UpdatedOn]       DATETIME      NULL,
    [LocationID]      INT           NULL
);

