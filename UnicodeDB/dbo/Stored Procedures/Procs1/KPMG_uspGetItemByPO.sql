
CREATE PROCEDURE [dbo].[KPMG_uspGetItemByPO]
(	
	@PO_Id NVARCHAR(max)
)
AS
	BEGIN Try	
		If((@PO_Id IS NOT null)OR (@PO_Id <> ''))		
		Select Fld_KPMG_Item_Id,Fld_KPMG_PoPr_Id from dbo.Tbl_KPMG_PoDetails where  Fld_KPMG_PO_Id = @PO_Id
	END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(max) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH


