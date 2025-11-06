CREATE TABLE [dbo].[T_Receipt_Component_Detail_Archive_Bak] (
    [I_Receipt_Comp_Detail_ID] INT             NOT NULL,
    [I_Invoice_Detail_ID]      INT             NULL,
    [I_Receipt_Detail_ID]      INT             NULL,
    [N_Amount_Paid]            NUMERIC (18, 2) NULL,
    [N_Comp_Amount_Rff]        NUMERIC (18, 2) NULL
);

