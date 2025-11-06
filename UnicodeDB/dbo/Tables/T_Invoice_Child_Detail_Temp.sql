CREATE TABLE [dbo].[T_Invoice_Child_Detail_Temp] (
    [I_Invoice_Detail_ID]            INT             IDENTITY (1, 1) NOT NULL,
    [I_Fee_Component_ID]             INT             NULL,
    [I_Invoice_Child_Header_ID]      INT             NULL,
    [I_Installment_No]               INT             NULL,
    [Dt_Installment_Date]            DATETIME        NULL,
    [N_Amount_Due]                   NUMERIC (18, 2) NULL,
    [I_Display_Fee_Component_ID]     INT             NULL,
    [I_Sequence]                     INT             NULL,
    [N_Amount_Adv_Coln]              NUMERIC (18, 2) NULL,
    [Flag_IsAdvanceTax]              NVARCHAR (MAX)  NULL,
    [I_Receipt_Header_ID]            INT             NULL,
    [S_Invoice_Number]               NVARCHAR (MAX)  NULL,
    [Tmp_AutoIdTag]                  INT             NULL,
    [N_Discount_Amount]              DECIMAL (14, 2) NULL,
    [N_Due]                          DECIMAL (14, 2) NULL,
    [I_Payment_Status]               INT             NULL,
    [N_CGST]                         NUMERIC (18, 2) NULL,
    [N_SGST]                         NUMERIC (18, 2) NULL,
    [N_IGST]                         NUMERIC (18, 2) NULL,
    [I_GST_FeeComponent_Catagory_ID] INT             NULL
);

