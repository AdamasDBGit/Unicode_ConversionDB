CREATE PROC [dbo].[uspGetCouponDiscount]  
(  
 @sCouponNumber VARCHAR(50)  
)  
AS   
BEGIN  
   
 SET NOCOUNT ON  
   
 SELECT ISNULL(D_Coupon_Discount,0) D_Coupon_Discount FROM T_Company_Coupon  
 WHERE S_Coupon_Number = @sCouponNumber  
 AND Dt_Expiry_Date >= CAST(FLOOR(CAST( getdate() AS float)) AS datetime)  
 AND I_Status = 1  
   
END
