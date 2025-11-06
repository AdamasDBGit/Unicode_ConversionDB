CREATE PROCEDURE [CORPORATE].[uspGetCorporatePlan]  
(    
 @CorporatePlanId INT    
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
         N_Percent_Student_Share  ,
         IsCertificate_Eligible 
         FROM CORPORATE.T_Corporate_Plan AS TCP WHERE I_Corporate_Plan_ID = @CorporatePlanId AND I_Status = 1     
   
 SELECT I_Batch_ID FROM CORPORATE.T_Corporate_Plan_Batch_Map AS TCPBM WHERE I_Corporate_Plan_ID = @CorporatePlanId  
END TRY    
BEGIN CATCH    
 --Error occurred:      
    
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
