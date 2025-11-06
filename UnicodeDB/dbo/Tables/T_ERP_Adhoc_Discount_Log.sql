CREATE TABLE [dbo].[T_ERP_Adhoc_Discount_Log] (
    [I_ERP_Adhoc_Discount_Log]                  INT             IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]                       INT             NULL,
    [I_Invoice_Child_Header_ID]                 INT             NULL,
    [Pre_Annual_Discounted_InvoiceAmount]       DECIMAL (18, 2) NULL,
    [Pre_Annual_Discounted_InvoiceChild_Amount] DECIMAL (18, 2) NULL,
    [I_Invoice_Detail_ID]                       INT             NULL,
    [I_Fee_Component_ID]                        INT             NULL,
    [N_PreBase_Amount]                          DECIMAL (18, 2) NULL,
    [N_Discounted_Amount]                       DECIMAL (18, 2) NULL,
    [Pre_DiscountSchemeID]                      INT             NULL,
    [Pre_Adhoc_Fix_Discount_Value]              DECIMAL (8, 2)  NULL,
    [Pre_Adhoc_Perc_Discount_Value]             DECIMAL (8, 2)  NULL,
    [Pre_CGST]                                  DECIMAL (8, 2)  NULL,
    [Pre_SGST]                                  DECIMAL (8, 2)  NULL,
    [Pre_IGST]                                  DECIMAL (8, 2)  NULL,
    [DiscountAppliedBy]                         INT             NULL,
    [Dt_DiscountAppliedAt]                      DATETIME        NULL,
    [N_PreDiscount_Amount]                      NUMERIC (12, 2) NULL,
    [Pre_Discounted_Amount]                     DECIMAL (8, 2)  NULL
);

