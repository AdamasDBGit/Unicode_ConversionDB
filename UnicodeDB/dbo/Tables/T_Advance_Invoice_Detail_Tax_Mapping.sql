CREATE TABLE [dbo].[T_Advance_Invoice_Detail_Tax_Mapping] (
    [I_Advance_Invoice_Detail_Tax_Map_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Advance_Invoice_Detail_Map_ID]     INT             NOT NULL,
    [I_Tax_ID]                            INT             NOT NULL,
    [N_Tax_Value]                         NUMERIC (18, 2) CONSTRAINT [DF__T_Advance__N_Tax__5F4627F0] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_Advance_Invoice_Detail_Tax_Mapping] PRIMARY KEY CLUSTERED ([I_Advance_Invoice_Detail_Tax_Map_ID] ASC)
);

