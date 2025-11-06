CREATE TABLE [SMManagement].[T_Stock_Dispatch_Header] (
    [StockDispatchHeaderID]   INT           IDENTITY (1, 1) NOT NULL,
    [StockDispatchHeaderName] VARCHAR (MAX) NULL,
    [StudentCount]            INT           NULL,
    [ItemCount]               INT           NULL,
    [DispatchDocument]        VARCHAR (MAX) NULL,
    [IsDispatched]            BIT           CONSTRAINT [DF__T_Stock_D__IsDis__0EE28E7E] DEFAULT ((0)) NULL,
    [StatusID]                INT           NULL,
    [DispatchDate]            DATETIME      NULL,
    [CreatedBy]               VARCHAR (MAX) NULL,
    [CreatedOn]               DATETIME      NULL,
    [UpdatedBy]               VARCHAR (MAX) NULL,
    [UpdatedOn]               DATETIME      NULL
);

