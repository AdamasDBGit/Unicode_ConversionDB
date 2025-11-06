CREATE TABLE [dbo].[T_Invoice_Detail_Tax_Temp] (
    [I_Tax_ID]              INT             NOT NULL,
    [I_Invoice_Detail_ID]   INT             NOT NULL,
    [N_Tax_Value]           NUMERIC (18, 2) NULL,
    [N_Tax_Value_Scheduled] NUMERIC (18, 2) NULL,
    [N_Tax_Value_Tmp]       NUMERIC (18, 2) NULL
);

