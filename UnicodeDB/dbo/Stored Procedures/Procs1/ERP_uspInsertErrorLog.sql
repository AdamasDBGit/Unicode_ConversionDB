CREATE PROCEDURE [dbo].[ERP_uspInsertErrorLog]
-- Add the parameters for the stored procedure here
	@sErrorMessage nvarchar(MAX),
	@sErrorController nvarchar(50),
	@sErrorAction nvarchar(50),
	@userID nvarchar(50)
	--@ErrorID 
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
		INSERT INTO dbo.ERP_ErrorLogTable
		(
			ErrorMessage,
			ErrorController,
			ErrorAction,
			Date,
			ErrorID,
			UserID
		)
		VALUES
		(
			@sErrorMessage,
			@sErrorController,
			@sErrorAction,
			GETDATE(),
			NEWID() ,
			@userID
		)
		DECLARE @newLogID int,@errorID nvarchar(MAX)
		SET @newLogID = SCOPE_IDENTITY()
		SET @errorID = (select ErrorID from ERP_ErrorLogTable where ID=@newLogID)
		select @errorID ErrorID

	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
