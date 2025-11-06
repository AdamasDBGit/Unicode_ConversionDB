CREATE PROCEDURE [dbo].[uspInsertErrorLog]
-- Add the parameters for the stored procedure here
	@sErrorCode varchar(50),
	@sErrorDescription text,
	@sLoginID varchar(200),
	@dtCrtdOn datetime
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
		INSERT INTO dbo.T_Error_Log
		(
			S_Error_Number,
			S_Login_ID,
			S_Error_Description,
			Dt_Crtd_On
		)
		VALUES
		(
			@sErrorCode,
			@sLoginID,
			@sErrorDescription,
			@dtCrtdOn
		)
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
