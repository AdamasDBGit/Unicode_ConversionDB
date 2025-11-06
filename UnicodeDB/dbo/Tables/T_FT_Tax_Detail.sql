CREATE TABLE [dbo].[T_FT_Tax_Detail] (
    [I_FT_Tax_Detail_ID]        INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Tax_ID]                  INT             NULL,
    [I_Fund_Transfer_Header_ID] INT             NULL,
    [N_Tax_Amount_Company]      NUMERIC (12, 4) NULL,
    [N_Tax_Amount_BP]           NUMERIC (12, 4) NULL,
    CONSTRAINT [PK_FT_Tax_Detail] PRIMARY KEY CLUSTERED ([I_FT_Tax_Detail_ID] ASC)
);

