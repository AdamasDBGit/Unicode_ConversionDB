-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 18/09/2006  
-- Description: Validate coupon  
-- =============================================  
CREATE PROCEDURE [dbo].[uspValidateCoupon]  
(  
 @sCouponNumber varchar(30)  
)  
AS  
BEGIN TRY  
  
 SELECT * FROM dbo.T_Company_Coupon   
 WHERE S_Coupon_Number = @sCouponNumber  
  AND I_Status = 1  
  AND Dt_Expiry_Date >= CAST(FLOOR(CAST( getdate() AS float)) AS datetime)

  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
