/*
-- =================================================================
-- Author:sanjay mitra
-- Create date:01/08/2007
-- Description:Insert order details  [LOGISTICS].[uspSaveOrderDetails]
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSaveOrderLine]
(			
		  @iLogisticsOrderID INT = NULL	
		 ,@iLogisticsiID INT = NULL
		 ,@iSliNo INT = NULL
		 ,@iItemQty FLOAT = NULL
		 ,@iItemAmount FLOAT = NULL
		 ,@sCrtdBy VARCHAR(20) = NULL
		 ,@sUpdBy VARCHAR(20) = NULL
		 ,@dtCrtdOn DATETIME = NULL
		 ,@dtUpdOn DATETIME =NULL
		 ,@iDelCnt INT
		 
)
AS
BEGIN TRY
SET NOCOUNT OFF;
IF (@iDelCnt = 0)
	BEGIN
			DELETE FROM [LOGISTICS].[T_Logistics_Order_Line]
			WHERE I_Logistics_Order_ID = @iLogisticsOrderID
	END

BEGIN
	INSERT INTO [LOGISTICS].[T_Logistics_Order_Line]
		(
		 I_Logistics_Order_ID
		,I_Logistics_ID
		,I_Sl_No
		,I_Item_Qty
		,I_Item_Amount
		,S_Crtd_By
		,S_Upd_By
		,Dt_Crtd_On
		,Dt_Upd_On
		)
		VALUES
		(
		  @iLogisticsOrderID 
		 ,@iLogisticsiID
		 ,@iSliNo
		 ,@iItemQty
		 ,@iItemAmount
		 ,@sCrtdBy
		 ,@sUpdBy
		 ,@dtCrtdOn
		 ,@dtUpdOn
		)
END
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
