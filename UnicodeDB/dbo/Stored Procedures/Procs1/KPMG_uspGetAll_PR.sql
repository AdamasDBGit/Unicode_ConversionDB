
CREATE PROCEDURE [dbo].[KPMG_uspGetAll_PR] 
	
AS
BEGIN Try	    
	SELECT Fld_KPMG_PoPr_Id,Fld_KPMG_PR_Id from dbo.Tbl_KPMG_PoDetails where Fld_KPMG_Status = 0
END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH

