CREATE FUNCTION [dbo].[fnCalculateConvenienceChargeTax]
    (
      @ConvenienceChargeAmount DECIMAL(18, 4),
      @BrandID INT,
      @ReceiptDate DATETIME,
      --@PaymentMode INT,
      @TaxID INT=NULL
    )
RETURNS DECIMAL(18, 4)
AS 
    BEGIN
        DECLARE @Tax DECIMAL(18, 4)
        DECLARE @TaxAmount DECIMAL(18,4)
        --DECLARE @AdditionalAmount DECIMAL(18,2)
		
		IF(@TaxID IS NULL)
		BEGIN
			SELECT @Tax=SUM(ISNULL(N_Value,0.0)) FROM ERP.T_ConvenienceCharge_Tax_Master TCCTM
			WHERE
			I_Brand_ID=@BrandID AND I_Status=1
			AND CONVERT(DATE, @ReceiptDate) BETWEEN CONVERT (DATE, Dt_From_Date)
                                             AND     CONVERT (DATE, Dt_To_Date)
			
			SET @TaxAmount=@ConvenienceChargeAmount*(@Tax/100)
		END
		ELSE
		BEGIN
			SELECT @Tax=ISNULL(N_Value,0) FROM ERP.T_ConvenienceCharge_Tax_Master TCCTM
			WHERE
			I_Brand_ID=@BrandID AND I_Status=1 AND I_Tax_ID=@TaxID
			AND CONVERT(DATE, @ReceiptDate) BETWEEN CONVERT (DATE, Dt_From_Date)
                                             AND     CONVERT (DATE, Dt_To_Date)
			
			
			SET @TaxAmount=@ConvenienceChargeAmount*(@Tax/100)
		END
		
		RETURN @TaxAmount

    END