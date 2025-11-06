CREATE TABLE [dbo].[T_OnAccount_Receipt_Tax] (
    [I_OnAccount_Receipt_Tax] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Receipt_Header_ID]     INT             NOT NULL,
    [I_Tax_ID]                INT             NOT NULL,
    [N_Tax_Paid]              NUMERIC (18, 2) NULL,
    [N_Tax_Rff]               NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_T_OnAccount_Receipt_Tax] PRIMARY KEY CLUSTERED ([I_OnAccount_Receipt_Tax] ASC)
);

