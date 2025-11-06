CREATE TABLE [ECOMMERCE].[T_Coupon_Master] (
    [CouponID]              INT             IDENTITY (1, 1) NOT NULL,
    [CouponCode]            VARCHAR (MAX)   NOT NULL,
    [CouponName]            VARCHAR (MAX)   NOT NULL,
    [CouponDesc]            VARCHAR (MAX)   NULL,
    [BrandID]               INT             NOT NULL,
    [DiscountSchemeID]      INT             NULL,
    [CouponCategoryID]      INT             NULL,
    [CouponType]            INT             NULL,
    [CouponCount]           INT             NULL,
    [AssignedCount]         INT             NULL,
    [StatusID]              INT             NULL,
    [ValidFrom]             DATETIME        NULL,
    [ValidTo]               DATETIME        NULL,
    [GreaterThanAmount]     DECIMAL (14, 2) NULL,
    [CustomerID]            VARCHAR (MAX)   NULL,
    [CampaignDiscountMapID] INT             NULL,
    [PerStudentCount]       INT             CONSTRAINT [DF__T_Coupon___PerSt__35DDF6BC] DEFAULT ((1)) NULL,
    [IsPrivate]             BIT             DEFAULT ('FALSE') NULL
);

