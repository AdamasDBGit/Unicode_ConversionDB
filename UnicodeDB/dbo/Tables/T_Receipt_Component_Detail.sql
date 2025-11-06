CREATE TABLE [dbo].[T_Receipt_Component_Detail] (
    [I_Receipt_Comp_Detail_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Invoice_Detail_ID]      INT             NULL,
    [I_Receipt_Detail_ID]      INT             NULL,
    [N_Amount_Paid]            NUMERIC (18, 2) NULL,
    [N_Comp_Amount_Rff]        NUMERIC (18, 2) NULL,
    [N_CGST]                   NUMERIC (18, 2) NULL,
    [N_SGST]                   NUMERIC (18, 2) NULL,
    [N_IGST]                   NUMERIC (18, 2) NULL,
    [I_Brand_ID]               INT             NULL,
    CONSTRAINT [PK__T_Receipt_Compon__5E55CAA0] PRIMARY KEY CLUSTERED ([I_Receipt_Comp_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCI_I_Invoice_Detail_ID]
    ON [dbo].[T_Receipt_Component_Detail]([I_Invoice_Detail_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [NCI_I_Receipt_Detail_ID]
    ON [dbo].[T_Receipt_Component_Detail]([I_Receipt_Detail_ID] ASC);

