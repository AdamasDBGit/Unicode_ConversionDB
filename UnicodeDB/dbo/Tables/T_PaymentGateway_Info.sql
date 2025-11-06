CREATE TABLE [dbo].[T_PaymentGateway_Info] (
    [I_PaymentGateway_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [S_PaymentGateway_Name] NVARCHAR (MAX) NULL,
    [I_Brand_ID]            INT            NOT NULL,
    [S_TransactionUrl]      NVARCHAR (MAX) NULL,
    [S_Salt]                NVARCHAR (MAX) NULL,
    [S_MerchantId]          NVARCHAR (MAX) NULL,
    [I_IsLive]              INT            NULL,
    [I_Status]              INT            NULL
);

