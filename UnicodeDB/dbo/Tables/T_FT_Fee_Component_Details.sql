CREATE TABLE [dbo].[T_FT_Fee_Component_Details] (
    [I_FT_Fee_Component_ID]     INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Fund_Transfer_Header_ID] INT             NULL,
    [I_Fee_Component_ID]        INT             NULL,
    [N_Total_Amount]            NUMERIC (12, 4) NULL,
    [N_CompanyShare]            NUMERIC (12, 4) NULL,
    CONSTRAINT [PK_FT_Fee_Component_Details] PRIMARY KEY CLUSTERED ([I_FT_Fee_Component_ID] ASC)
);

