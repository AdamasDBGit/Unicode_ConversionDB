/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Logistics Item List From T_Kit_Logistics table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspUpdateConfigDisc]
(
	@sChargeCode VARCHAR(50) = NULL,
	@iAmount NUMERIC(18,2) = NULL,
	@dtStart DATETIME,
	@dtEnd DATETIME,
	@sUpdBy VARCHAR(20),
	@dtUpdOn DATETIME
)
AS
BEGIN TRY
SET NOCOUNT OFF;

	UPDATE [LOGISTICS].[T_Logistics_Charge_Discount_Co]
		SET
			--S_Logistics_Charge_Code = @sChargeCode,
			I_Amount = @iAmount,
			S_Upd_By = @sUpdBy, 
			Dt_Upd_On = @dtUpdOn
		WHERE S_Logistics_Charge_Code = COALESCE(@sChargeCode, S_Logistics_Charge_Code)
			  AND CONVERT(VARCHAR(12),Dt_Start,101) = @dtStart
			  AND CONVERT(VARCHAR(12),Dt_End,101) = @dtEnd

END TRY

BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
