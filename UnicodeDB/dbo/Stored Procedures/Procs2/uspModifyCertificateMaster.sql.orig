CREATE PROCEDURE [dbo].[uspModifyCertificateMaster] 
(
	@iCertificateID int,
	@iBrandID int,	
    @sCertificateName varchar(300),
	@sCertificateDesc varchar(300),
	@sCertificateType varchar(10),
	@iCertificateTemplate int = NULL,
	@sCertificateBy varchar(20),
	@dCertificateOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @sErrorCode varchar(20)

    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Certificate_Master
		(I_Brand_ID, 
		 S_Certificate_Name,
	     S_Certificate_Description,
		 S_Certificate_Type,
		 I_Template_ID, 
		 I_Status, 
		 S_Crtd_By, 
		 Dt_Crtd_On)
		VALUES
		(@iBrandID, 
		 @sCertificateName,
	     @sCertificateDesc,
		 @sCertificateType, 
		 @iCertificateTemplate,
         1, 
		 @sCertificateBy, 
		 @dCertificateOn)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Certificate_Master
		SET I_Brand_ID = @iBrandID,
		S_Certificate_Name = @sCertificateName,
	    S_Certificate_Description = @sCertificateDesc,
		S_Certificate_Type = @sCertificateType,
		I_Template_ID = @iCertificateTemplate,
		S_Upd_By = @sCertificateBy,
		Dt_Upd_On = @dCertificateOn
		where I_Certificate_ID = @iCertificateID
	END
	-- Check for deletion of Master Data
	ELSE IF @iFlag = 3
	BEGIN
		IF EXISTS(SELECT I_Course_ID FROM dbo.T_Course_Master
					WHERE I_Certificate_ID = @iCertificateID
					AND I_Status = 1)
			BEGIN
				SET @sErrorCode = 'CM_100020'
			END
		ELSE
			BEGIN
				UPDATE dbo.T_Certificate_Master
				SET I_Status = 0,
				S_Upd_By = @sCertificateBy,
				Dt_Upd_On = @dCertificateOn
				where I_Certificate_ID = @iCertificateID
			END	
	END
	SELECT @sErrorCode AS ERROR
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
