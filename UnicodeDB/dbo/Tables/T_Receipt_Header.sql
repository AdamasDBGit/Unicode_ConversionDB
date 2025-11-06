CREATE TABLE [dbo].[T_Receipt_Header] (
    [I_Receipt_Header_ID]     INT             IDENTITY (1, 1) NOT NULL,
    [S_Receipt_No]            NVARCHAR (MAX)  NULL,
    [I_Invoice_Header_ID]     INT             NULL,
    [Dt_Receipt_Date]         DATETIME        NULL,
    [I_Student_Detail_ID]     INT             NULL,
    [I_PaymentMode_ID]        INT             NOT NULL,
    [I_Centre_Id]             INT             NULL,
    [I_Enquiry_Regn_ID]       INT             NULL,
    [N_Receipt_Amount]        NUMERIC (18, 2) NULL,
    [S_Fund_Transfer_Status]  CHAR (1)        NULL,
    [I_Status]                INT             NULL,
    [Dt_CreditCard_Expiry]    DATETIME        NULL,
    [S_CreditCard_Issuer]     NVARCHAR (MAX)  NULL,
    [S_Cancellation_Reason]   NVARCHAR (MAX)  NULL,
    [N_CreditCard_No]         NUMERIC (18)    NULL,
    [S_ChequeDD_No]           NVARCHAR (MAX)  NULL,
    [Dt_ChequeDD_Date]        DATETIME        NULL,
    [S_Bank_Name]             NVARCHAR (MAX)  NULL,
    [S_Branch_Name]           NVARCHAR (MAX)  NULL,
    [I_Receipt_Type]          SMALLINT        NULL,
    [S_Crtd_By]               NVARCHAR (MAX)  NULL,
    [S_Upd_By]                NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]              DATETIME        NULL,
    [Dt_Upd_On]               DATETIME        NULL,
    [N_Tax_Amount]            NUMERIC (18, 2) NULL,
    [N_Amount_Rff]            NUMERIC (18, 2) NULL,
    [N_Receipt_Tax_Rff]       NUMERIC (18, 2) NULL,
    [S_AdjustmentRemarks]     NVARCHAR (MAX)  NULL,
    [Bank_Account_Name]       NVARCHAR (MAX)  NULL,
    [Dt_Deposit_Date]         DATETIME        NULL,
    [S_Narration]             NVARCHAR (MAX)  NULL,
    [I_Currency_ID]           INT             NULL,
    [Is_NewGSTEnvironment]    BIT             NULL,
    [I_School_Session_ID]     INT             NULL,
    [I_Brand_ID]              INT             NULL,
    [I_Ref_Invoice_Header_ID] INT             NULL,
    [S_Ref_Invoice_Number]    NVARCHAR (MAX)  NULL,
    [S_Utr_No]                NVARCHAR (50)   NULL,
    [S_Prayer_Account_No]     NVARCHAR (50)   NULL,
    CONSTRAINT [PK__T_Receipt_Header__603E1312] PRIMARY KEY CLUSTERED ([I_Receipt_Header_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Invoice_ID_Receipt]
    ON [dbo].[T_Receipt_Header]([I_Invoice_Header_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_I_Status_I_Receipt_Header_ID]
    ON [dbo].[T_Receipt_Header]([I_Status] ASC)
    INCLUDE([I_Receipt_Header_ID]);

