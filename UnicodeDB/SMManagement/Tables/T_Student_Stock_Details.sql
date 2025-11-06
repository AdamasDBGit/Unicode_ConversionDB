CREATE TABLE [SMManagement].[T_Student_Stock_Details] (
    [StudentStockDetailsID]       INT           IDENTITY (1, 1) NOT NULL,
    [StudentDetailID]             INT           NULL,
    [StockID]                     INT           NULL,
    [StudentEligibilityDetailsID] INT           NULL,
    [Barcode]                     VARCHAR (MAX) NULL,
    [TrackingID]                  VARCHAR (MAX) NULL,
    [CreatedBy]                   VARCHAR (MAX) NULL,
    [CreatedOn]                   DATETIME      NULL,
    [UpdatedBy]                   VARCHAR (MAX) NULL,
    [UpdatedOn]                   DATETIME      NULL
);

