CREATE TABLE [dbo].[T_ERP_Fee_Advance_Records] (
    [I_Fee_Adv_Record_ID]     INT             IDENTITY (1, 1) NOT NULL,
    [R_I_Enquiry_Regn_ID]     INT             NULL,
    [R_I_School_Session_ID]   INT             NULL,
    [I_Brand_ID]              INT             NULL,
    [N_Adv_Amt]               NUMERIC (18, 2) NULL,
    [Dt_Adv_Dt]               DATE            NULL,
    [I_Fee_Struct_Payment_ID] INT             NULL,
    [Is_Active]               BIT             NULL,
    [Dt_Create_Dt]            DATE            CONSTRAINT [DF__T_ERP_Fee__Dt_Cr__45C02421] DEFAULT (getdate()) NULL,
    [Is_AdhocAdv]             BIT             NULL
);

