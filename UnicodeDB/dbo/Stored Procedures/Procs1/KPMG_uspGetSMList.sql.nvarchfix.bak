    
CREATE PROCEDURE [dbo].[KPMG_uspGetSMList]    
AS    
BEGIN TRY     
    
 SELECT * FROM TBL_KPMG_SM_LIST  where Fld_KPMG_IsEnable='Y'and Fld_KPMG_IsValid='Y' and Fld_KPMG_prefix is not null  
    
END TRY    
BEGIN CATCH    
     
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int    
    
 SELECT @ErrMsg = ERROR_MESSAGE(),    
   @ErrSeverity = ERROR_SEVERITY()    
    
 RAISERROR(@ErrMsg, @ErrSeverity, 1)    
END CATCH
