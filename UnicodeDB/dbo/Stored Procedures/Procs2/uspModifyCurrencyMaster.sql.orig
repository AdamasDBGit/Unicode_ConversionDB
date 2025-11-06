CREATE PROCEDURE [dbo].[uspModifyCurrencyMaster] 
(
	@iCurrencyID int,
	@sCurrencyCode varchar(20),
	@sCurrencyName varchar(50),
    @sCurrencyBy varchar(20),
	@dCurrencyOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Currency_Master
		(S_Currency_Code, 
		S_Currency_Name, 
		I_Status, 
		S_Crtd_By, 
		Dt_Crtd_On)
		VALUES(@sCurrencyCode, 
		@sCurrencyName, 
		1, 
		@sCurrencyBy, 
		@dCurrencyOn)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Currency_Master
		SET S_Currency_Code = @sCurrencyCode,
		S_Currency_Name = @sCurrencyName,
		S_Upd_By = @sCurrencyBy,
		Dt_Upd_On = @dCurrencyOn
		where I_Currency_ID = @iCurrencyID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Currency_Master
		SET I_Status = 0,
		S_Upd_By = @sCurrencyBy,
		Dt_Upd_On = @dCurrencyOn
		where I_Currency_ID = @iCurrencyID
	END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
