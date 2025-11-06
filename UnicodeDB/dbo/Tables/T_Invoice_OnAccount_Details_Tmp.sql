CREATE TABLE [dbo].[T_Invoice_OnAccount_Details_Tmp] (
    [ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [Brand]              NVARCHAR (MAX) NULL,
    [StateNameAndCode]   NVARCHAR (MAX) NULL,
    [TaxType]            NVARCHAR (MAX) NULL,
    [ReceiptNo]          NVARCHAR (MAX) NULL,
    [OnAccountComponent] NVARCHAR (MAX) NULL,
    [TaxableAmount]      NVARCHAR (MAX) NULL,
    [Tax]                NVARCHAR (MAX) NULL,
    [CreatedDate]        NVARCHAR (MAX) NULL,
    [CancelledDate]      NVARCHAR (MAX) NULL,
    [ReceiptStatus]      NVARCHAR (MAX) NULL,
    [Type]               NVARCHAR (MAX) NULL,
    [TAXINV]             NVARCHAR (MAX) NULL,
    [CM]                 NVARCHAR (MAX) NULL,
    [I_Brand_ID]         INT            NULL,
    CONSTRAINT [PK_T_Invoice_OnAccount_Details_Tmp] PRIMARY KEY CLUSTERED ([ID] ASC)
);

