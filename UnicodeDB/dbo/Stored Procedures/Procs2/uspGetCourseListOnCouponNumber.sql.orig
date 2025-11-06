-- =============================================      
-- Author:  Utpal  
-- Create date: 24/08/20011     
-- Description: Get CourseID List On Coupon Number  
-- =============================================      
CREATE PROCEDURE [dbo].[uspGetCourseListOnCouponNumber] --'ACC101101019'--'TestCoupon1'   
(      
 @sCouponNumber varchar(30)      
)      
AS      
BEGIN TRY      
      
 SELECT DISTINCT tcc1.D_Coupon_Discount,CourseIds = STUFF  
 (  
  ( SELECT ',' + +CAST(I_Course_ID AS VARCHAR(5))       
 FROM dbo.T_Company_Coupon AS tcc  
 INNER JOIN dbo.T_Coupon_Course_Map AS tccm  
 ON tcc.I_Coupon_ID = tccm.I_Coupon_ID   
 WHERE tccm.I_Coupon_ID = tcc.I_Coupon_ID  
 AND  
 tcc.S_Coupon_Number = @sCouponNumber  
 FOR XML PATH('')  
   ),1,1,''  
 )    
FROM dbo.T_Company_Coupon AS tcc1
WHERE tcc1.S_Coupon_Number = @sCouponNumber  
  
      
END TRY      
BEGIN CATCH      
 --Error occurred:        
      
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int      
 SELECT @ErrMsg = ERROR_MESSAGE(),      
   @ErrSeverity = ERROR_SEVERITY()      
      
 RAISERROR(@ErrMsg, @ErrSeverity, 1)      
END CATCH
