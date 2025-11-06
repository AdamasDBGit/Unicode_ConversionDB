CREATE PROCEDURE [CORPORATE].[uspGetCorporatePlanForCorporate]    
(    
  @iCorporateID INT = NULL    
)          
AS          
BEGIN TRY      
      
SELECT I_Corporate_Plan_ID ,    
        S_Corporate_Plan_Name ,    
        I_Corporate_ID ,    
        Dt_Valid_From ,    
        Dt_Valid_To ,    
        B_Is_Fund_Shared ,    
        I_Corporate_Plan_Type_ID ,    
        I_Minimum_Strength ,    
        I_Maximum_Strength ,    
        N_Percent_Student_Share ,    
        I_Status ,    
        S_Crtd_By ,    
        S_Updt_by ,    
        Dt_Crtd_On ,    
        Dt_Updt_On,
        IsCertificate_Eligible  FROM CORPORATE.T_Corporate_Plan AS tcp1     
        WHERE  tcp1.I_Corporate_ID = @iCorporateID     
        AND tcp1.I_Status = 1        
        --AND tcp1.Dt_Valid_To >= CONVERT(DATE, GETDATE())          
            
    
END TRY          
          
BEGIN CATCH              
 --Error occurred:                
              
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int              
 SELECT @ErrMsg = ERROR_MESSAGE(),              
   @ErrSeverity = ERROR_SEVERITY()              
              
 RAISERROR(@ErrMsg, @ErrSeverity, 1)              
END CATCH
