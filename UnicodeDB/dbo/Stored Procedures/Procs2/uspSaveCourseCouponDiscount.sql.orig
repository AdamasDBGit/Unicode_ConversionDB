CREATE PROCEDURE [dbo].[uspSaveCourseCouponDiscount] --'<Root><CouponNumber sCouponNumber="TESTCUAUG25_1" /><CouponNumber sCouponNumber="TESTCUAUG25_2" /><CouponNumber sCouponNumber="TESTCUAUG25_3" /></Root>'  
(                      
                  
 @sCouponNumbers VARCHAR(MAX),  
 @iStatus INT,          
 @sCouponCourseIds VARCHAR(MAX),                
 @dtExpiryDate DATETIME=NULL,        
 @dDiscountAmount DECIMAL        
)                      
AS                         
BEGIN TRY                        
 BEGIN TRANSACTION            
          
 DECLARE @iCouponID INT          
 DECLARE @xml_hndl INT      
 DECLARE @xml_hndl1 INT      
   
  CREATE TABLE #tempCouponNumber        
  (                    
    couponNumber VARCHAR(50)    
  )  
    
  EXEC sp_xml_preparedocument @xml_hndl OUTPUT, @sCouponNumbers        
    
  INSERT INTO #tempCouponNumber  
   (     
      couponNumber  
   )  
   SELECT sCouponNumber          
   From              
   OPENXML(@xml_hndl, '/Root/CouponNumber', 1)              
 With              
 (              
    sCouponNumber VARCHAR(50) '@sCouponNumber'          
  )              
      
    --SELECT * FROM #tempCouponNumber  
      
    DECLARE @cn_COUPONNUMBER VARCHAR(50)        
      
    DECLARE INSERT_COUPONNUMBER CURSOR FOR        
    SELECT couponNumber FROM #tempCouponNumber  
        
  OPEN INSERT_COUPONNUMBER         
  FETCH NEXT FROM INSERT_COUPONNUMBER INTO @cn_COUPONNUMBER        
           
  WHILE @@FETCH_STATUS = 0            
   BEGIN         
     IF NOT EXISTS(SELECT tcc.S_Coupon_Number FROM dbo.T_Company_Coupon AS tcc WHERE tcc.S_Coupon_Number = @cn_COUPONNUMBER)  
       BEGIN  
		   INSERT INTO dbo.T_Company_Coupon        
			   (         
			  S_Coupon_Number ,        
			  Dt_Expiry_Date ,        
			  I_Status ,        
			  Dt_Discount_Date ,        
			  D_Coupon_Discount        
			   )        
			 VALUES  (         
			  @cn_COUPONNUMBER , -- S_Coupon_Number - varchar(50)        
			  @dtExpiryDate , -- Dt_Expiry_Date - datetime        
			  @iStatus , -- I_Status - int        
			  NULL , -- Dt_Discount_Date - datetime        
			  @dDiscountAmount  -- D_Coupon_Discount - decimal        
			   )        
                 
			SELECT @iCouponID = @@IDENTITY            
			PRINT  @iCouponID          
               
			DELETE FROM dbo.T_Coupon_Course_Map WHERE I_Coupon_ID = @iCouponID          
                   
			 --prepare the XML Document by executing a system stored procedure              
			EXEC sp_xml_preparedocument @xml_hndl1 OUTPUT, @sCouponCourseIds              
		                   
			INSERT INTO dbo.T_Coupon_Course_Map        
			 (           
			I_Coupon_ID,        
			I_Course_ID        
			 )          
			 SELECT @iCouponID,IDtoInsert          
			  From              
			  OPENXML(@xml_hndl1, '/Root/CouponDiscount', 1)              
			  With              
			  (              
			 IDToInsert INT '@ID'          
			  )              
          END       
         
    FETCH NEXT FROM INSERT_COUPONNUMBER INTO @cn_COUPONNUMBER              
             
   END        
           
  CLOSE INSERT_COUPONNUMBER         
  DEALLOCATE INSERT_COUPONNUMBER       
                  
    
    
  DROP TABLE #tempCouponNumber  
   
  COMMIT TRANSACTION            
            
END TRY              
                    
BEGIN CATCH              
          
  ROLLBACK TRANSACTION              
                    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int                        
 SELECT @ErrMsg = ERROR_MESSAGE(),                        
 @ErrSeverity = ERROR_SEVERITY()                        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)            
                       
END CATCH
