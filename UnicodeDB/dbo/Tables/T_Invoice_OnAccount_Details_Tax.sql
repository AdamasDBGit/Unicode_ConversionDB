CREATE TABLE [dbo].[T_Invoice_OnAccount_Details_Tax] (
    [I_OnAccount_Ivoice_Tax_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_OnAccount_Ivoice_ID]     INT             NULL,
    [I_Tax_ID]                  INT             NULL,
    [N_Tax_Paid]                NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_T_Invoice_OnAccount_Details_Tax] PRIMARY KEY CLUSTERED ([I_OnAccount_Ivoice_Tax_ID] ASC)
);

