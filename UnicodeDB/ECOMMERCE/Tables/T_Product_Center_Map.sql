CREATE TABLE [ECOMMERCE].[T_Product_Center_Map] (
    [ProductCentreID] INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]       INT           NOT NULL,
    [CenterID]        INT           NOT NULL,
    [StatusID]        INT           NOT NULL,
    [IsPublished]     BIT           NULL,
    [CreatedBy]       VARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME      NULL,
    [UpdatedBy]       VARCHAR (MAX) NULL,
    [UpdatedOn]       DATETIME      NULL
);

