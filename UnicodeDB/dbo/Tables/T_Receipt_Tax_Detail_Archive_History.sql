CREATE TABLE [dbo].[T_Receipt_Tax_Detail_Archive_History] (
    [I_Receipt_Comp_Detail_ID] INT             NOT NULL,
    [I_Tax_ID]                 INT             NOT NULL,
    [I_Invoice_Detail_ID]      INT             NOT NULL,
    [N_Tax_Paid]               NUMERIC (18, 2) NULL,
    [N_Tax_Rff]                NUMERIC (18, 2) NULL
);

