CREATE PROCEDURE [dbo].[uspUploadDocument] 
(
	@sDocumentName NVARCHAR(max),
	@sDocumentType NVARCHAR(max),
	@sDocumentPath NVARCHAR(max),
	@sDocumentURL NVARCHAR(max),
	@sCreatedBy NVARCHAR(max) = null ,
	@dCreatedOn datetime = null
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @iUploadDocID int

	SET @iUploadDocID = 0

	BEGIN TRAN T1
	
	INSERT INTO dbo.T_Upload_Document
	(	
		S_Document_Name, 
		S_Document_Type, 
		S_Document_Path, 
		S_Document_URL,
		I_Status, 
		S_Crtd_By, 
		Dt_Crtd_On
	)
	VALUES
	(
		@sDocumentName, 
		@sDocumentType, 
		@sDocumentPath, 
		@sDocumentURL,
		1, 
		@sCreatedBy, 
		@dCreatedOn
	)

	SELECT @iUploadDocID = SCOPE_IDENTITY()

	COMMIT TRAN T1
		
	SELECT @iUploadDocID DocumentID
	 	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH


