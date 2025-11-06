CREATE TABLE [ECOMMERCE].[T_Product_Config] (
    [ProductConfigID]      INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]            INT           NOT NULL,
    [ConfigID]             INT           NOT NULL,
    [ConfigValue]          VARCHAR (MAX) NULL,
    [ConfigDisplayName]    VARCHAR (MAX) NULL,
    [StatusID]             INT           NULL,
    [SubHeaderID]          INT           NULL,
    [SubHeaderDisplayName] VARCHAR (MAX) NULL,
    [HeaderID]             INT           NULL,
    [HeaderDisplayName]    VARCHAR (MAX) NULL
);

