CREATE TABLE [dbo].[T_Receipt_Tax_Detail] (
    [I_Receipt_Comp_Detail_ID] INT             NOT NULL,
    [I_Tax_ID]                 INT             NOT NULL,
    [I_Invoice_Detail_ID]      INT             NOT NULL,
    [N_Tax_Paid]               NUMERIC (18, 2) NULL,
    [N_Tax_Rff]                NUMERIC (18, 2) NULL,
    [I_Brand_ID]               INT             NULL,
    CONSTRAINT [PK__T_Receipt_Tax_De__3BC0BB7A] PRIMARY KEY CLUSTERED ([I_Receipt_Comp_Detail_ID] ASC, [I_Tax_ID] ASC, [I_Invoice_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Idx_I_Invoice_Detail_ID]
    ON [dbo].[T_Receipt_Tax_Detail]([I_Invoice_Detail_ID] ASC)
    INCLUDE([I_Receipt_Comp_Detail_ID], [N_Tax_Paid]);

