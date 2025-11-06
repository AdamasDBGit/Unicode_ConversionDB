CREATE TABLE [ECOMMERCE].[T_Transaction_Product_Subscription_Details] (
    [SubscriptionDetailID]       INT             IDENTITY (1, 1) NOT NULL,
    [TransactionProductDetailID] INT             NULL,
    [SubscriptionPlanID]         VARCHAR (MAX)   NULL,
    [AuthKey]                    VARCHAR (MAX)   NULL,
    [BillingPeriod]              DECIMAL (14, 2) NULL,
    [BillingStartDate]           DATETIME        NULL,
    [BillingEndDate]             DATETIME        NULL,
    [TotalBillingAmount]         DECIMAL (14, 2) NULL,
    [StatusID]                   INT             NULL,
    [SubscriptionStatus]         VARCHAR (MAX)   NULL,
    [SubscriptionLink]           VARCHAR (MAX)   NULL
);

