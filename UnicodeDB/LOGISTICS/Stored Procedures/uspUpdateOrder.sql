/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:04/10/2007
-- Description:
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspUpdateOrder]
(
	@sUpdBy   VARCHAR(20) = NULL,
	@dtUpdOn DATETIME = NULL,
	@iStatus INT = NULL,
    @iLogisticOrderID INT = NULL
)
AS
BEGIN
		--Update T_Logistics_Order
		UPDATE [LOGISTICS].[T_Logistics_Order]
		SET 	
			I_Status_ID = @iStatus,
			S_Upd_By = @sUpdBy,
			Dt_Upd_On = @dtUpdOn
		 
WHERE 
        I_Logistic_Order_ID = COALESCE(@iLogisticOrderID, I_Logistic_Order_ID)		
END
