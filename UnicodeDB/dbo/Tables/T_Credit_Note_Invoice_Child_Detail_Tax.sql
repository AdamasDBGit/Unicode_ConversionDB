CREATE TABLE [dbo].[T_Credit_Note_Invoice_Child_Detail_Tax] (
    [I_Credit_Note_Invoice_Child_Detail_Tax_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Credit_Note_Invoice_Child_Detail_ID]     INT             NOT NULL,
    [I_Tax_ID]                                  INT             NOT NULL,
    [I_Invoice_Detail_ID]                       INT             NOT NULL,
    [N_Tax_Value]                               NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_T_Credit_Note_Invoice_Child_Detail_Tax] PRIMARY KEY CLUSTERED ([I_Credit_Note_Invoice_Child_Detail_Tax_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Idx_CNI_IND]
    ON [dbo].[T_Credit_Note_Invoice_Child_Detail_Tax]([I_Credit_Note_Invoice_Child_Detail_ID] ASC, [I_Invoice_Detail_ID] ASC)
    INCLUDE([N_Tax_Value]);

