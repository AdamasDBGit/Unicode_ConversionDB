CREATE TABLE [ECOMMERCE].[PlanTypeMaster] (
    [PlanTypeID]   INT           IDENTITY (1, 1) NOT NULL,
    [PlanTypeName] VARCHAR (300) NOT NULL,
    [BrandID]      INT           NOT NULL,
    [StatusID]     BIT           NOT NULL
);

