CREATE TABLE [dbo].[T_ERP_FeeComponent_Adhoc_Mapping] (
    [I_FeeComponent_Adhoc_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Fee_Component_ID]      INT             NULL,
    [I_Brand_ID]              INT             NULL,
    [N_Amount]                NUMERIC (12, 2) NULL,
    [Is_Active]               BIT             CONSTRAINT [DF__T_ERP_Fee__Is_Ac__04E684FD] DEFAULT ((1)) NULL,
    [Dt_Created_At]           DATETIME        CONSTRAINT [DF__T_ERP_Fee__Dt_Cr__05DAA936] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]          DATETIME        NULL,
    [I_Created_By]            INT             NULL,
    [I_Modified_By]           INT             NULL
);

