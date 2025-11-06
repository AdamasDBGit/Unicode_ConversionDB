CREATE TABLE [ECOMMERCE].[T_Transaction_Product_Details] (
    [TransactionProductDetailID] INT             IDENTITY (1, 1) NOT NULL,
    [TransactionPlanDetailID]    INT             NOT NULL,
    [ProductID]                  INT             NULL,
    [ProductCenterID]            INT             NULL,
    [ProductFeePlanID]           INT             NULL,
    [CouponCode]                 VARCHAR (MAX)   NULL,
    [CenterID]                   INT             NULL,
    [FeePlanID]                  INT             NULL,
    [DiscountSchemeID]           INT             NULL,
    [PaymentModeID]              INT             NULL,
    [BatchID]                    INT             NULL,
    [AmountPaid]                 DECIMAL (14, 2) NULL,
    [TaxPaid]                    DECIMAL (14, 2) NULL,
    [CanBeProcessed]             INT             NULL,
    [IsCompleted]                BIT             NULL,
    [CompletedOn]                DATETIME        NULL,
    [FeeScheduleID]              INT             NULL,
    [StudentID]                  VARCHAR (MAX)   NULL,
    [ReceiptHeaderID]            INT             NULL
);

