CREATE TABLE [dbo].[NewInserted] (
    [I_Invoice_Detail_ID]        INT             NULL,
    [I_Fee_Component_ID]         INT             NULL,
    [I_Invoice_Child_Header_ID]  INT             NULL,
    [I_Installment_No]           INT             NULL,
    [Dt_Installment_Date]        DATETIME        NULL,
    [N_Amount_Due]               NUMERIC (18, 2) NULL,
    [I_Display_Fee_Component_ID] INT             NULL,
    [I_Sequence]                 INT             NULL,
    [N_Amount_Adv_Coln]          NUMERIC (18, 2) NULL,
    [Flag_IsAdvanceTax]          NVARCHAR (MAX)  NULL,
    [Tmp_AutoIdTag]              INT             NULL
);

