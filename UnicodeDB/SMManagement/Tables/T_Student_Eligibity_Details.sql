CREATE TABLE [SMManagement].[T_Student_Eligibity_Details] (
    [EligibilityDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [EligibilityHeaderID] INT          NULL,
    [I_Delivery]          INT          NULL,
    [EligibilityDate]     DATETIME     NULL,
    [BarcodePrefix]       VARCHAR (10) NULL,
    [IsDelivered]         BIT          CONSTRAINT [DF__T_Student__IsDel__43E066A2] DEFAULT ((0)) NULL,
    [ItemType]            INT          NULL,
    [IsApproved]          BIT          CONSTRAINT [DF__T_Student__IsApp__44D48ADB] DEFAULT ((0)) NULL,
    [ApprovedDate]        DATETIME     NULL,
    [DispatchDate]        DATETIME     NULL,
    [IsDispatched]        BIT          NULL,
    [IsReturned]          BIT          NULL
);

