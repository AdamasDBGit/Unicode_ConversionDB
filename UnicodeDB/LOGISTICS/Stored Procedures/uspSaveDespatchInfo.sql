/*
-- =================================================================
-- Author: Jayanti Chowdhury
-- Create date:04/08/2007
-- Description:Save Despatch Info From T_Logistics_Despatch_Info table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSaveDespatchInfo]
(
	@iDocketNo VARCHAR(20) = NULL,
	@sRemarks VARCHAR(200) = NULL,
	@sAirBillNo VARCHAR(20) = NULL,
    @sTransporter VARCHAR(200) = NULL,
	@iCourierID INT = 0,
	@dtDispDate DATETIME = NULL,
	@dtExpectedDate DATETIME = NULL,
	@dtActualDate DATETIME = NULL,
    @sCrtdBy    VARCHAR(20) = NULL,
	@dtCrtdOn DATETIME = NULL,
	@sUpdBy   VARCHAR(20) = NULL,
	@dtUpdOn DATETIME = NULL,
	@iStatus INT = NULL,
    @iLogisticOrderID INT = NULL
)
AS
Declare @DispatchInfo int
BEGIN TRY
SET NOCOUNT OFF;

	INSERT INTO [LOGISTICS].[T_Logistics_Despatch_Info]
	(		 
		S_Docket_No,
		S_Remarks,
		S_Air_Bill_No,
        S_Transporter,
		I_Courier_ID,
		Dt_Despatch_Date,
		Dt_Exp_Delivery_Date,
		Dt_Act_Delivery_Date,
		I_Logistics_Order_ID,
		S_Crtd_By, 
		Dt_Crtd_On,
		S_Upd_By, 
		Dt_Upd_On
	)
	VALUES
	(
		@iDocketNo,
		@sRemarks,
		@sAirBillNo,
        @sTransporter,
		@iCourierID,
		@dtDispDate,
		@dtExpectedDate,
		@dtActualDate,
		@iLogisticOrderID,
		@sCrtdBy,
		@dtCrtdOn,
		@sUpdBy,
		@dtUpdOn
	)

SET @DispatchInfo = SCOPE_IDENTITY()
IF (@DispatchInfo > 0 AND @@ERROR = 0)
BEGIN
						--Update T_Logistics_Order
						UPDATE [LOGISTICS].[T_Logistics_Order]
						SET 	
								I_Status_ID=@iStatus
			 
		 
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
