CREATE TABLE [ECOMMERCE].[T_Campaign_Discount_Map] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [CampaignID]      INT             NULL,
    [FromMarks]       DECIMAL (14, 2) NULL,
    [ToMarks]         DECIMAL (14, 2) NULL,
    [DiscountID]      INT             NULL,
    [ValidFrom]       DATETIME        NULL,
    [ValidTo]         DATETIME        NULL,
    [StatusID]        INT             CONSTRAINT [DF__T_Campaig__Statu__4F9DC8BF] DEFAULT ((1)) NULL,
    [CreatedOn]       DATETIME        NULL,
    [CreatedBy]       VARCHAR (MAX)   NULL,
    [UpdatedOn]       DATETIME        NULL,
    [UpdatedBy]       VARCHAR (MAX)   NULL,
    [CouponName]      VARCHAR (MAX)   NULL,
    [CouponPrefix]    VARCHAR (MAX)   NULL,
    [CouponTypeID]    INT             NULL,
    [CouponCount]     INT             NULL,
    [GenerationCount] INT             NULL,
    [MessageDesc]     VARCHAR (MAX)   CONSTRAINT [DF__T_Campaig__Messa__58330EC0] DEFAULT ('') NULL,
    [SMSTypeID]       INT             NULL,
    CONSTRAINT [PK__T_Campai__3214EC27CAB7B484] PRIMARY KEY CLUSTERED ([ID] ASC)
);

