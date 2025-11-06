
CREATE PROCEDURE [dbo].[KPMG_uspUpdateMaterialStatus] 
	@MaterialBarCodeNo NVARCHAR(255),
	@OkStatus INT,
	@DamageStatus INT,
	@DuplicateStatus INT
AS
BEGIN Try	
		IF (@OkStatus=0) set  @OkStatus=NULL 
		IF (@DamageStatus=0) set  @DamageStatus=NULL 
		IF (@DuplicateStatus=0) set  @DuplicateStatus=NULL 
		 
		 IF(@DamageStatus=1)
		 BEGIN
			UPDATE Tbl_KPMG_StockDetails SET Fld_KPMG_Status=5,Fld_KPMG_isIssued=0 WHERE Fld_KPMG_BarCode=@MaterialBarCodeNo
		  END
		--UPDATE Tbl_KPMG_StudyMaterialStatus SET Fld_KPMG_OkStatus=@OkStatus,Fld_KPMG_DamageStatus=@DamageStatus,Fld_KPMG_DuplicateStatus=@DuplicateStatus
		--WHERE Fld_KPMG_MaterialBarCode=@MaterialBarCodeNo
END TRY        
        
    BEGIN CATCH            
 --Error occurred:              
            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH
