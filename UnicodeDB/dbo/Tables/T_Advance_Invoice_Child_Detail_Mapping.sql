CREATE TABLE [dbo].[T_Advance_Invoice_Child_Detail_Mapping] (
    [I_Advance_Invoice_Child_Detail_Map_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Advance_Ref_Invoice_Child_Detail_ID] INT             NOT NULL,
    [I_Receipt_Component_Detail_ID]         INT             NOT NULL,
    [I_Invoice_Detail_ID]                   INT             NOT NULL,
    [N_Advance_Amount]                      NUMERIC (18, 2) CONSTRAINT [DF__T_Advance__N_Adv__5C69BB45] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_Advance_Invoice_Child_Detail_Mapping] PRIMARY KEY CLUSTERED ([I_Advance_Invoice_Child_Detail_Map_ID] ASC)
);

