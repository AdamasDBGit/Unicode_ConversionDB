CREATE PROCEDURE [dbo].[uspModifyTaxMaster]   
(  
 @iTaxID int = NULL,  
 @iCountryID INT,  
 @sTaxCode varchar(10),  
 @sTaxDesc varchar(50),  
 @sCrtdBy varchar(50),  
 @DtCrtdOn datetime,  
    @iFlag int  
)  
AS  
BEGIN TRY  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON  
 IF @iFlag = 1
 BEGIN
  INSERT INTO dbo.T_Tax_Master
		   (  I_Country_ID
			 ,S_Tax_Code
			 ,S_Tax_Desc
			 ,C_Is_Surcharge
			 ,I_Status
			 ,Dt_Valid_From
			 ,Dt_Valid_To
			 ,S_Crtd_By
			 ,Dt_Crtd_On
			 ,Dt_Upd_On
		   )
	VALUES(  @iCountryID
			,@sTaxCode
			,@sTaxDesc
			,'N'
			,1
			,@DtCrtdOn
			,NULL
			,@sCrtdBy
			,@DtCrtdOn
			,NULL
		  )
 END
 IF @iFlag = 2  
 BEGIN  
  UPDATE dbo.T_Tax_Master  
  SET S_Tax_Code = @sTaxCode,  
  S_Tax_Desc = @sTaxDesc,    
  I_Country_ID = @iCountryID,  
  S_Upd_By = @sCrtdBy,  
  Dt_Upd_On = @DtCrtdOn  
  WHERE I_Tax_ID = @iTaxID  
 END  
 ELSE IF @iFlag = 3  
 BEGIN  
  UPDATE dbo.T_Tax_Master  
  SET I_Status = 0,  
  Dt_Valid_To = @DtCrtdOn,  
  S_Upd_By = @sCrtdBy,  
  Dt_Upd_On = @DtCrtdOn  
  WHERE I_Tax_ID = @iTaxID  
 END  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
