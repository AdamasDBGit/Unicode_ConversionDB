/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Logistics Item List From T_Logistics_Master table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspUpdateKitMaster]
(
	--@sKitCode VARCHAR(20),
	@sKitDesc VARCHAR(200),
	@dKitRateINR NUMERIC(18,2),
	@dKitRateUSD NUMERIC(18,2),
	@iKitID INT,
	@sCrtdBy VARCHAR(20),
	@dtCrtdOn DATETIME,
	@sUpdBy VARCHAR(20),
	@dtUpdOn DATETIME
)
AS
BEGIN TRY
SET NOCOUNT OFF;

	UPDATE [LOGISTICS].[T_Kit_Master]
		SET 
			--S_Kit_Code, 
			S_Kit_Desc		= @sKitDesc, 
			I_Kit_Rate_INR	= @dKitRateINR,
			I_Kit_Rate_USD	= @dKitRateUSD,
			S_Crtd_By		= @sCrtdBy, 
			Dt_Crtd_On		= @dtCrtdOn,
			S_Upd_By		= @sUpdBy, 
			Dt_Upd_On		= @dtUpdOn
	WHERE I_Kit_ID = COALESCE(@iKitID, I_Kit_ID)

--SET @iKitID = SCOPE_IDENTITY();

	DELETE FROM LOGISTICS.T_Kit_Logistics
		WHERE I_Kit_ID = @iKitID

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
