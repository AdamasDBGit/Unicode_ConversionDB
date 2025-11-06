CREATE TABLE [SMManagement].[T_Stock_Dispatch_Student_Header] (
    [StockDispatchStudentHeaderID] INT           IDENTITY (1, 1) NOT NULL,
    [StockDispatchHeaderID]        INT           NULL,
    [StudentDetailID]              INT           NULL,
    [ItemCount]                    INT           NULL,
    [StatusID]                     INT           NULL,
    [IsDispatched]                 BIT           CONSTRAINT [DF__T_Stock_D__IsDis__4D69D0DC] DEFAULT ((0)) NULL,
    [DispatchDate]                 DATETIME      NULL,
    [DispatchDocument]             VARCHAR (MAX) NULL,
    [TrackingID]                   VARCHAR (MAX) NULL,
    [IsDelivered]                  BIT           NULL,
    [DeliveryDate]                 DATETIME      NULL,
    [IsReturned]                   BIT           NULL,
    [ReturnDate]                   DATETIME      NULL
);

