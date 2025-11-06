CREATE TYPE [dbo].[UT_Installment_Component_Wise_Discount] AS TABLE (
    [Dt_Installment_Date]  DATETIME        NULL,
    [I_Invoice_Detail_ID]  INT             NULL,
    [I_Fee_Component_ID]   INT             NULL,
    [BaseAmount]           DECIMAL (18, 2) NULL,
    [Fixed_DiscountValue]  DECIMAL (8, 2)  NULL,
    [Perc_DiscountValue]   DECIMAL (8, 2)  NULL,
    [DiscountedBaseAmount] DECIMAL (18, 2) NULL,
    [DiscountedCGST]       DECIMAL (8, 2)  NULL,
    [DiscountedSGST]       DECIMAL (8, 2)  NULL,
    [DiscountedIGST]       DECIMAL (8, 2)  NULL,
    [DiscountedCGSTP]      DECIMAL (8, 2)  NULL,
    [DiscountedSGSTP]      DECIMAL (8, 2)  NULL,
    [DiscountedIGSTP]      DECIMAL (8, 2)  NULL);

