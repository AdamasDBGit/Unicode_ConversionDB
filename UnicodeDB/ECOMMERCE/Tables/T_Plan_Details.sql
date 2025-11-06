CREATE TABLE [ECOMMERCE].[T_Plan_Details] (
    [PlanDetailID]     INT           IDENTITY (1, 1) NOT NULL,
    [PlanProductID]    INT           NOT NULL,
    [PaymentMode]      VARCHAR (MAX) NULL,
    [ProductFeePlanID] INT           NULL,
    [DiscountCouponID] INT           NULL,
    [StatusID]         INT           NULL
);

