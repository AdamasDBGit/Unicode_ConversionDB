CREATE TABLE [ECOMMERCE].[T_Campaign_Coupon_Details] (
    [ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [CamapaignID]           INT             NULL,
    [CampaignDiscountMapID] INT             NULL,
    [CouponID]              INT             NULL,
    [CustomerID]            VARCHAR (MAX)   NULL,
    [MarksObtained]         DECIMAL (14, 2) NULL,
    [MessageDesc]           VARCHAR (MAX)   NULL,
    [CreatedOn]             DATETIME        NULL,
    [CreatedBy]             VARCHAR (MAX)   NULL,
    CONSTRAINT [PK__T_Campai__3214EC27A56F89CC] PRIMARY KEY CLUSTERED ([ID] ASC)
);

