CREATE TABLE [ECOMMERCE].[BKP_2023_JAN_Product_FeePlan] (
    [ProductFeePlanID]          INT           IDENTITY (1, 1) NOT NULL,
    [ProductCentreID]           INT           NOT NULL,
    [CourseFeePlanID]           INT           NOT NULL,
    [ProductFeePlanDisplayName] VARCHAR (MAX) NULL,
    [StatusID]                  INT           NULL,
    [IsPublished]               BIT           NULL,
    [ValidFrom]                 DATETIME      NULL,
    [ValidTo]                   DATETIME      NULL,
    [CreatedBy]                 VARCHAR (MAX) NULL,
    [CreatedOn]                 DATETIME      NULL,
    [UpdatedBy]                 VARCHAR (MAX) NULL,
    [UpdatedOn]                 DATETIME      NULL
);

