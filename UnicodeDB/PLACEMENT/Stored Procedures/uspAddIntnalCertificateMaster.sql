CREATE PROCEDURE [PLACEMENT].[uspAddIntnalCertificateMaster]
   (
	@iInternationalCertificateID	INT          ,
	@sCertificateName	        VARCHAR(100) ,
	@sCertificateVenderName		VARCHAR(200) ,  
	@sCrtdBy            		VARCHAR(20)  ,
	@DtCrtdBy           		DATETIME     
   )
AS
BEGIN TRY

   SET NOCOUNT OFF;
   -- Insert Intnal Certificate record in T_Intnal_Certificate_Master 
   INSERT INTO PLACEMENT.T_Intnal_Certificate_Master 
   (
	I_International_Certificate_ID	,
	S_Certificate_Name		,
	S_Certificate_Vender_Name	,
	I_Status			,
	S_Crtd_By			,
	Dt_Crtd_By			
   )

   VALUES
   (
	@iInternationalCertificateID	,
	@sCertificateName		,
	@sCertificateVenderName		,
	1				,
	@sCrtdBy			,
	@DtCrtdBy			
   )
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
