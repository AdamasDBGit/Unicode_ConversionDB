CREATE TABLE [ECOMMERCE].[T_Category_Master] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [CategoryCode] VARCHAR (MAX) NOT NULL,
    [CategoryName] VARCHAR (MAX) NOT NULL,
    [CategoryDesc] VARCHAR (MAX) NULL,
    [StatusID]     INT           NULL,
    [BrandID]      INT           NOT NULL,
    [CreatedOn]    DATETIME      NULL,
    [CreatedBy]    VARCHAR (MAX) NULL,
    [UpdatedOn]    DATETIME      NULL,
    [UpdatedBy]    VARCHAR (MAX) NULL,
    [IsOnline]     BIT           NULL,
    [IsOffline]    BIT           NULL
);

