CREATE PROCEDURE [CORPORATE].[uspGetCorporateDetails]    
AS    
BEGIN TRY  
SELECT * FROM CORPORATE.T_Corporate_Details WHERE I_Status = 1  
END TRY    
    
BEGIN CATCH        
 --Error occurred:          
        
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int        
 SELECT @ErrMsg = ERROR_MESSAGE(),        
   @ErrSeverity = ERROR_SEVERITY()        
        
 RAISERROR(@ErrMsg, @ErrSeverity, 1)        
END CATCH
