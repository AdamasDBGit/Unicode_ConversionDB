/*
-- =================================================================
-- Author:sanjay mitra
-- Create date:01/08/2007
-- Description:Insert order details  [LOGISTICS].[uspSaveALLOrderDetails]
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSaveOrder]
(				
		 @iCenterID INT = NULL
		,@dtOrderDate DATETIME = NULL
		,@iTotalAmount INT = NULL
		,@sTransportationMode VARCHAR(3)
		,@iPackingCharges INT = NULL
		,@btPackingWaiver BIT = NULL
		,@iTransportationCharges INT = NULL
		,@btTransportationWaiver BIT = NULL
		,@btFreeItemFlag BIT = NULL
		,@sPaymentMode VARCHAR(20) = NULL
		,@btTransferredToSAP INT = NULL
		,@StatusID INT = NULL
		,@sCrtdBy VARCHAR(20) = NULL
		,@sUpdBy VARCHAR(20) = NULL
		,@dtCrtdOn DATETIME = NULL
		,@dtUpdOn DATETIME =NULL
		,@iLogisticsOrderID INT OUTPUT
)
AS
BEGIN TRY
SET NOCOUNT OFF;
	

	INSERT INTO [LOGISTICS].[T_Logistics_Order]
		(
		 I_Center_ID
		,Order_Date
		,I_Total_Amount
		,S_Transportation_Mode
		,I_Packing_Charges
		,B_Packing_Waiver
		,I_Transportation_Charges
		,B_Transportation_Waiver
		,B_Free_Item_Flag
		,S_Payment_Mode
		,B_Transferred_To_SAP
		,I_Status_ID
		,S_Crtd_By
		,S_Upd_By
		,Dt_Crtd_On
		,Dt_Upd_On
		)
		VALUES
		(
		 @iCenterID
		,@dtOrderDate
		,@iTotalAmount
		,@sTransportationMode
		,@iPackingCharges
		,@btPackingWaiver
		,@iTransportationCharges
		,@btTransportationWaiver
		,@btFreeItemFlag
		,@sPaymentMode
		,@btTransferredToSAP
		,@StatusID
		,@sCrtdBy
		,@sUpdBy
		,@dtCrtdOn 
		,@dtUpdOn 
		)
		SET @iLogisticsOrderID = SCOPE_IDENTITY()
	

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
