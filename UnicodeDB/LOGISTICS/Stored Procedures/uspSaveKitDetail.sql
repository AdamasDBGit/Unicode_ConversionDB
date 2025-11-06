/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Logistics Item List From T_Kit_Logistics table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSaveKitDetail]
(
	@iKitId INT,
	@iLogisticsId INT,
	@iKitQty INT,
	@sCrtdBy VARCHAR(20),
	@dtCrtdOn DATETIME,
	@sUpdBy VARCHAR(20),
	@dtUpdOn DATETIME
)
AS
BEGIN TRY
SET NOCOUNT OFF;

	INSERT INTO [LOGISTICS].[T_Kit_Logistics]
	(
		--I_Kit_Logistics_ID, 
		I_Kit_ID,
		I_Logistics_ID,
		I_Kit_Qty,
		S_Crtd_By, 
		Dt_Crtd_On,
		S_Upd_By, 
		Dt_Upd_On
	)
	VALUES
	(
		@iKitId,
		@iLogisticsId,
		@iKitQty,
		@sCrtdBy,
		@dtCrtdOn,
		@sUpdBy,
		@dtUpdOn
	)

END TRY

BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
