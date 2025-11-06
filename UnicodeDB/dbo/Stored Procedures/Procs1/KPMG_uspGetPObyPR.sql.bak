
CREATE PROCEDURE [dbo].[KPMG_uspGetPObyPR]
(	
	@PR_Id NVARCHAR(MAX)
)
AS
	BEGIN Try	
		If((@PR_Id IS NOT null)OR (@PR_Id <> ''))		
		Select Fld_KPMG_PO_Id,Fld_KPMG_PoPr_Id from dbo.Tbl_KPMG_PoDetails where  Fld_KPMG_PR_Id = @PR_Id
	END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH

