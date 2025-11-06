CREATE FUNCTION [dbo].[fnGetFineAmountTaxForAPI]
    (
      @ComponentID INT,
      @FineAmount DECIMAL(14,2)
    )
RETURNS DECIMAL(14, 2)
AS
    BEGIN
    
        DECLARE @FineAmountTax DECIMAL(14, 2)= 0
    
        SELECT @FineAmountTax=SUM(ISNULL(@FineAmount,0)*(ISNULL(TTCRT.N_Tax_Rate,0)/100)) FROM dbo.T_Tax_Country_ReceiptType AS TTCRT
        WHERE
        TTCRT.I_Receipt_Type=@ComponentID
        AND TTCRT.I_Status=1 AND TTCRT.Dt_Valid_To>=GETDATE()

        RETURN @FineAmountTax


    END