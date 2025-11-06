CREATE PROCEDURE [dbo].[uspUpdateUserPassword] 
(
	@iEmpID int,
	@sOldPassword nnvarchar(max),
	@sNewPassword nnvarchar(max)
	
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE dbo.T_User_Master
	SET S_Password = @sNewPassword,
		B_Force_Password_Change = 0
	WHERE I_User_ID = @iEmpID
	AND S_Password = @sOldPassword
	AND I_Status = 1
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
