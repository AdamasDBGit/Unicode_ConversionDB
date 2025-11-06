CREATE TYPE [dbo].[UT_Installments_Component_Details_For_Discount] AS TABLE (
    [I_InstallmentNo]     INT          NOT NULL,
    [Dt_Installment_Date] DATETIME     NOT NULL,
    [I_Component_ID]      INT          NULL,
    [BaseAmount]          DECIMAL (18) NULL,
    [CGST]                DECIMAL (18) NULL,
    [SGST]                DECIMAL (18) NULL,
    [IGST]                DECIMAL (18) NULL);

