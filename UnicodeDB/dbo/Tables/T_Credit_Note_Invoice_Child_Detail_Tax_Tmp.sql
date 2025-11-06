CREATE TABLE [dbo].[T_Credit_Note_Invoice_Child_Detail_Tax_Tmp] (
    [I_Credit_Note_Invoice_Child_Detail_Tax_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Credit_Note_Invoice_Child_Detail_ID]     INT             NOT NULL,
    [I_Tax_ID]                                  INT             NOT NULL,
    [I_Invoice_Detail_ID]                       INT             NOT NULL,
    [N_Tax_Value]                               NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_T_Credit_Note_Invoice_Child_Detail_Tax_Tmp] PRIMARY KEY CLUSTERED ([I_Credit_Note_Invoice_Child_Detail_Tax_ID] ASC)
);

