CREATE TABLE [dbo].[AdvQryTemp] (
    [I_Invoice_Detail_ID]       INT             NULL,
    [Dt_Installment_Date]       DATE            NULL,
    [Amount_Paid]               DECIMAL (14, 2) NULL,
    [Adv_N_Amount_Paid]         DECIMAL (14, 2) NULL,
    [I_Receipt_Comp_Detail_ID]  INT             NULL,
    [I_Receipt_Header_ID]       INT             NULL,
    [I_Fee_Component_ID]        INT             NULL,
    [I_Invoice_Child_Header_ID] INT             NULL
);

