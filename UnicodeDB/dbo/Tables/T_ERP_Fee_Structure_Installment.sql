CREATE TABLE [dbo].[T_ERP_Fee_Structure_Installment] (
    [I_Fee_Structure_Installment_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Fee_Structure_ID]             INT             NOT NULL,
    [I_Installment_No]               INT             NOT NULL,
    [D_Installment_Amount]           DECIMAL (18, 2) NOT NULL,
    [Dt_Payment_Date]                DATE            NOT NULL,
    [Dt_Last_Payment_Date]           DATE            NOT NULL
);

