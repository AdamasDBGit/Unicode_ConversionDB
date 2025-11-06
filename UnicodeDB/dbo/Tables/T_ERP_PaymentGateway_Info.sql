CREATE TABLE [dbo].[T_ERP_PaymentGateway_Info] (
    [I_PaymentGateway_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [S_PaymentGateway_Name] NVARCHAR (MAX) NULL,
    [I_IsLive]              BIT            NULL,
    [I_Status]              BIT            NULL
);

