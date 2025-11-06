CREATE TABLE [ECOMMERCE].[T_Transaction_Plan_Details] (
    [TransactionPlanDetailID] INT             IDENTITY (1, 1) NOT NULL,
    [TransactionID]           INT             NOT NULL,
    [PlanID]                  INT             NOT NULL,
    [AmountPaid]              DECIMAL (14, 2) NULL,
    [TaxPaid]                 DECIMAL (14, 2) NULL,
    [CanBeProcessed]          INT             NULL,
    [IsCompleted]             BIT             NULL,
    [CompletedOn]             DATETIME        NULL
);

