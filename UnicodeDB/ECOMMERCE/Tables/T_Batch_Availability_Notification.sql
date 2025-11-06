CREATE TABLE [ECOMMERCE].[T_Batch_Availability_Notification] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID] VARCHAR (MAX) NULL,
    [PlanID]     INT           NULL,
    [ProductID]  INT           NULL,
    [CenterID]   INT           NULL,
    [MobileNo]   VARCHAR (MAX) NULL,
    [EmailID]    VARCHAR (MAX) NULL,
    [StatusID]   INT           NULL,
    [CreatedOn]  DATETIME      NULL,
    [CreatedBy]  VARCHAR (MAX) NULL,
    [UpdatedOn]  DATETIME      NULL,
    [UpdatedBy]  VARCHAR (MAX) NULL,
    [NotifiedOn] DATETIME      NULL,
    CONSTRAINT [PK__T_Batch___3214EC27C7B7E29A] PRIMARY KEY CLUSTERED ([ID] ASC)
);

