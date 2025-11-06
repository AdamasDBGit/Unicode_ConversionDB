CREATE TABLE [SMManagement].[T_StockvsPhysical_Temp] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [ItemCode]        VARCHAR (MAX) NULL,
    [ItemDescription] VARCHAR (MAX) NULL,
    [Barcode]         VARCHAR (MAX) NULL,
    [StockID]         INT           NULL,
    [StatusID]        INT           NULL
);

