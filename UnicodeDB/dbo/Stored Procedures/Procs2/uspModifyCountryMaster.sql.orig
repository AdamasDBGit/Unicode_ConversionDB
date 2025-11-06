CREATE PROCEDURE [dbo].[uspModifyCountryMaster]
	-- Add the parameters for the stored procedure here
	@iCountryID int,
	@sCountryCode varchar(20),
	@sCountryName varchar(100),
	@sCountryBy varchar(20),
	@dCountryOn datetime,
	@iFlag int,
	@iCurrencyID int			
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- test comment 123

    -- Insert statements for procedure here
	if(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Country_Master(
												S_Country_Code,
												S_Country_Name,
												I_Currency_ID, 
												I_Status, 
												S_Crtd_By, 
												Dt_Crtd_On
										   )
			VALUES(
					@sCountryCode, 
					@sCountryName, 
					@iCurrencyID,
					1, 
					@sCountryBy, 
					@dCountryOn
				)
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
				UPDATE dbo.T_Country_Master
				SET S_Country_Code = @sCountryCode,
				S_Country_Name = @sCountryName,
				I_Currency_ID = @iCurrencyID,
				S_Upd_By = @sCountryBy,
				Dt_Crtd_On = @dCountryOn
				where I_Country_ID = @iCountryID	
		END

	ELSE IF(@iFlag = 3)
		BEGIN
				UPDATE dbo.T_Country_Master
				SET I_Status = 0,
				S_Upd_By = @sCountryBy,
				Dt_Upd_On = @dCountryOn
				where I_Country_ID = @iCountryID
		END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
