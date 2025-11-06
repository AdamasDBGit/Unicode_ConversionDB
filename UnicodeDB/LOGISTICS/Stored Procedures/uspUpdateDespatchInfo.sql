/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:21/09/2007
-- Description:Update Despatch Info From T_Logistics_Despatch_Info table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspUpdateDespatchInfo]
(
	@dtActualDate DATETIME = NULL,
	@sUpdBy   VARCHAR(20) = NULL,
	@dtUpdOn DATETIME = NULL,
	@iStatus INT = NULL,
    @iLogisticOrderID INT = NULL
)
AS
--Declare @DispatchInfo int
BEGIN TRY
SET NOCOUNT OFF;

	UPDATE [LOGISTICS].[T_Logistics_Despatch_Info]
	SET
		Dt_Act_Delivery_Date = @dtActualDate,
		S_Upd_By = @sUpdBy,
		Dt_Upd_On = @dtUpdOn
	WHERE 
        I_Logistics_Order_ID = COALESCE(@iLogisticOrderID, I_Logistics_Order_ID)


----SET @DispatchInfo = SCOPE_IDENTITY()
IF (@iLogisticOrderID > 0 AND @@ERROR = 0)
BEGIN
	UPDATE [LOGISTICS].[T_Logistics_Order]
	SET 	
			I_Status_ID = @iStatus
	WHERE 
			I_Logistic_Order_ID = COALESCE(@iLogisticOrderID, I_Logistic_Order_ID)
END


END TRY

BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
