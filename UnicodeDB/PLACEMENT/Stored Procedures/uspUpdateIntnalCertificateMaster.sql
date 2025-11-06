CREATE PROCEDURE [PLACEMENT].[uspUpdateIntnalCertificateMaster]
   (
	@iInternationalCertificateID	INT          ,
	@sCertificateName	        VARCHAR(100) ,
	@sCertificateVenderName		VARCHAR(200) , 
        @iStatus                        INT	     , 
	@sUpdBy            		VARCHAR(20)  ,
	@DtUpd_By           		DATETIME     
   )
AS
BEGIN TRY 

      UPDATE [PLACEMENT].T_Intnal_Certificate_Master
      SET
	S_Certificate_Name		= @sCertificateName       ,
       	S_Certificate_Vender_Name	= @sCertificateVenderName ,
       	I_Status			= @iStatus		  ,
       	S_Upd_By			= @sUpdBy                 ,
       	Dt_Upd_By			= @DtUpd_By               
       WHERE
	    I_International_Certificate_ID = @iInternationalCertificateID
           
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
