CREATE PROCEDURE [dbo].[uspGetDiscountRateFromSchemeID]    
(    
 @iDiscountSchemeId INT,    
 @dTotalInvoiceAmount NUMERIC(18,2)    
)    
    
AS    
    
BEGIN TRY    
 SET NOCOUNT ON;    
 DECLARE @iDiscountRate NUMERIC(18,2)    
 DECLARE @nMaxRange NUMERIC(18,2)    
     
 SELECT @nMaxRange = MAX(N_RANGE_TO) FROM T_DISCOUNT_DETAILS WHERE I_DISCOUNT_SCHEME_ID = @iDiscountSchemeId    
     
 IF @dTotalInvoiceAmount > @nMaxRange    
  BEGIN    
   SELECT @iDiscountRate = N_DISCOUNT_RATE FROM T_DISCOUNT_DETAILS WHERE N_RANGE_TO = @nMaxRange AND I_DISCOUNT_SCHEME_ID = @iDiscountSchemeId    
  END    
 ELSE    
  BEGIN    
   SELECT  @iDiscountRate = N_DISCOUNT_RATE FROM T_DISCOUNT_DETAILS WHERE @dTotalInvoiceAmount >= N_RANGE_FROM AND @dTotalInvoiceAmount <= N_RANGE_TO AND I_DISCOUNT_SCHEME_ID = @iDiscountSchemeId    
  END    
    --PRINT @iDiscountRate
 SELECT  ISNULL(@iDiscountRate,0) AS Discount_Rate    
END TRY    
      
      
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
   
END CATCH
