
CREATE FUNCTION [dbo].[fnGetReceiptAmtExcldConvenienceCharge]
    (
      @ReceiptAmount DECIMAL(18, 4),
      @BrandID INT,
      @ReceiptDate DATETIME,
      @PaymentMode INT,
      @TaxID INT=NULL
    )
RETURNS DECIMAL(18, 4)
AS 
    BEGIN
       DECLARE @ConvenienceCharge DECIMAL(18,4)
       DECLARE @TaxForConvenienceCharge DECIMAL(18,4)
       DECLARE @FinalReceiptAmount DECIMAL(18,4)
       
       SET @ConvenienceCharge=CAST(ROUND(ISNULL(dbo.fnCalculateConvenienceCharge(@ReceiptAmount,@BrandID,@ReceiptDate,@PaymentMode),0),2) AS DECIMAL(14,2))--akash 5.2.2016 --susmita 2022-09-02 add Null Check
       SET @TaxForConvenienceCharge=CAST(ROUND(ISNULL(dbo.fnCalculateConvenienceChargeTax(@ConvenienceCharge,@BrandID,@ReceiptDate,@TaxID),0),2) AS DECIMAL(14,2))--akash 5.2.2016  --susmita 2022-09-02 add Null Check
       SET @FinalReceiptAmount=@ReceiptAmount-(@ConvenienceCharge+@TaxForConvenienceCharge)
       
       RETURN CAST(ROUND(@FinalReceiptAmount,2) AS DECIMAL(14,2))--akash 5.2.2016
       
    END