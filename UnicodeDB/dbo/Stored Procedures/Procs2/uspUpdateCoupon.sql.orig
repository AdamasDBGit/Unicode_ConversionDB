-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 18/09/2006  
-- Description: Validate coupon  
-- =============================================  
CREATE PROCEDURE [dbo].[uspUpdateCoupon]  
(  
 @sCouponNumber varchar(30) ,
 @iInvoiceID INT 
)  
AS  
BEGIN TRY  
  
 UPDATE dbo.T_Company_Coupon  
  SET I_Status = 0,  
   Dt_Discount_Date = getdate(),
   I_Invoice_Header_ID =    @iInvoiceID
 WHERE S_Coupon_Number = @sCouponNumber  
  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
