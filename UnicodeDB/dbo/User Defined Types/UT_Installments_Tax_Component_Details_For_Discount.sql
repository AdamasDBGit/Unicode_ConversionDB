CREATE TYPE [dbo].[UT_Installments_Tax_Component_Details_For_Discount] AS TABLE (
    [I_InstallmentNo]     INT          NOT NULL,
    [Dt_Installment_Date] DATETIME     NOT NULL,
    [I_Component_ID]      INT          NULL,
    [TaxID]               INT          NULL,
    [TaxAmount]           DECIMAL (18) NULL);

