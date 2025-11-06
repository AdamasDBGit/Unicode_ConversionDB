CREATE TABLE [dbo].[T_Invoice_Detail_Tax] (
    [I_Tax_ID]              INT             NOT NULL,
    [I_Invoice_Detail_ID]   INT             NOT NULL,
    [N_Tax_Value]           NUMERIC (18, 2) NULL,
    [N_Tax_Value_Scheduled] NUMERIC (18, 2) CONSTRAINT [DF__T_Invoice__N_Tax__598D4E9A] DEFAULT ((0)) NULL,
    [N_Tax_Value_Tmp]       NUMERIC (18, 2) CONSTRAINT [DF__T_Invoice__N_Tax__26CCC4A3] DEFAULT ((0)) NULL,
    [I_Brand_ID]            INT             NULL,
    CONSTRAINT [PK__T_Invoice_Detail__65F6EC68] PRIMARY KEY CLUSTERED ([I_Tax_ID] ASC, [I_Invoice_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ix_I_Invoice_Detail_ID]
    ON [dbo].[T_Invoice_Detail_Tax]([I_Invoice_Detail_ID] ASC)
    INCLUDE([N_Tax_Value], [N_Tax_Value_Scheduled]);

