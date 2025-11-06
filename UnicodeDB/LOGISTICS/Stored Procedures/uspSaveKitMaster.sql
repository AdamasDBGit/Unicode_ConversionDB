/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Logistics Item List From T_Logistics_Master table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSaveKitMaster]
(
	@sKitCode VARCHAR(20),
	@sKitDesc VARCHAR(200),
	@dKitRateINR NUMERIC(18,2),
	@dKitRateUSD NUMERIC(18,2),
	@iKitID INT = 0 OUTPUT,
	@iKitMode INT,
	@sCrtdBy VARCHAR(20),
	@dtCrtdOn DATETIME,
	@sUpdBy VARCHAR(20),
	@dtUpdOn DATETIME
)
AS
BEGIN TRY
SET NOCOUNT OFF;

	INSERT INTO [LOGISTICS].[T_Kit_Master]
		(
			S_Kit_Code, 
			S_Kit_Desc, 
			I_Kit_Rate_INR,
			I_Kit_Rate_USD,
			I_Kit_Mode,
			S_Crtd_By, 
			Dt_Crtd_On,
			S_Upd_By, 
			Dt_Upd_On
		)
		VALUES
		(
			@sKitCode,
  			@sKitDesc,
			@dKitRateINR,
			@dKitRateUSD,
			@iKitMode,
			@sCrtdBy,
			@dtCrtdOn,
			@sUpdBy,
			@dtUpdOn
		)
SET @iKitID = SCOPE_IDENTITY();
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
