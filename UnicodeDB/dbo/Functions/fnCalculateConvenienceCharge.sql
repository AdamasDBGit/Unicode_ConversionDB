CREATE FUNCTION [dbo].[fnCalculateConvenienceCharge]
    (
      @ReceiptAmount DECIMAL(18, 4),
      @BrandID INT,
      @ReceiptDate DATETIME,
      @PaymentMode INT
    )
RETURNS DECIMAL(18, 4)
AS 
    BEGIN
        DECLARE @ConvenienceCharge DECIMAL(18, 4)
        DECLARE @ConvienceChargePercentage DECIMAL(18,4)
        DECLARE @AdditionalAmount DECIMAL(18,4)
	
        SELECT  @ConvienceChargePercentage=ISNULL(N_Percentage,0.0) ,
                @AdditionalAmount=ISNULL(N_Addl_Amount,0.0)
        FROM    dbo.T_ConvenienceCharge_Matrix TCCM
        WHERE   I_PaymentMode_ID = @PaymentMode
                AND CONVERT(DATE, @ReceiptDate) BETWEEN CONVERT (DATE, Dt_valid_from)
                                             AND     CONVERT (DATE, Dt_valid_to)
                AND I_Status = 1
                AND @ReceiptAmount BETWEEN N_From_Amount AND N_To_Amount
                AND I_Brand_ID = @BrandID
                
                SET @ConvenienceCharge=(@ReceiptAmount*(@ConvienceChargePercentage/100))+@AdditionalAmount;
                
                RETURN @ConvenienceCharge
    END