
CREATE PROCEDURE [dbo].[KPMG_uspGetPrinterRejectedItemCodes]

AS
BEGIN Try

	SELECT distinct(mstr.Fld_KPMG_ItemCode) AS ItemCode FROM Tbl_KPMG_StockDetails dtl Join Tbl_KPMG_StockMaster mstr
	on mstr.Fld_KPMG_Stock_Id = dtl.Fld_KPMG_Stock_Id
	WHERE mstr.Fld_KPMG_Branch_Id = 0 AND mstr.Fld_KPMG_FromBranch_Id = 0 and dtl.Fld_KPMG_Status = 5
	
END TRY        
    
BEGIN CATCH            
--Error occurred:              
        
    DECLARE @ErrMsg NVARCHAR(max) ,  
        @ErrSeverity INT            
    SELECT  @ErrMsg = ERROR_MESSAGE() ,  
            @ErrSeverity = ERROR_SEVERITY()            
    RAISERROR(@ErrMsg, @ErrSeverity, 1)            
END CATCH

