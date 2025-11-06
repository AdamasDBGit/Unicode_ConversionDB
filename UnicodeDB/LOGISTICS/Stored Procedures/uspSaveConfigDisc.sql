/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:09/24/2007
-- Description:Save Config Charge
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSaveConfigDisc]
(
	@iBrandID INT,
	@bChargeDiscount BIT,
	@sChargeCode VARCHAR(50),
	@sChargeDesc VARCHAR(100),
	@dtStart DATETIME,
    @dtEnd DATETIME,
	@iAmount FLOAT,
    @sCrtdBy    VARCHAR(20),
	@dtCrtdOn DATETIME
)
AS
BEGIN TRY
SET NOCOUNT OFF;
IF (@bChargeDiscount = 'true')
BEGIN
	INSERT INTO [LOGISTICS].[T_Logistics_ChrgDiscount_Config]
	(		 
		I_Brand_ID,
		S_Logistics_Charge_Code,
        S_Logistics_Charge_Desc,
		Dt_Start,
		Dt_End,
		I_Amount,
		S_Crtd_By, 
		Dt_Crtd_On
	)
	VALUES
	(
		@iBrandID,
		@sChargeCode,
		@sChargeDesc,
        @dtStart,
		@dtEnd,
		@iAmount,
		@sCrtdBy,
		@dtCrtdOn
	)
END
ELSE
BEGIN
	INSERT INTO [LOGISTICS].[T_Logistics_Charge_Discount_Co]
	(		 
		I_Brand_ID,
		S_Logistics_Charge_Code,
        S_Logistics_Charge_Desc,
		Dt_Start,
		Dt_End,
		I_Amount,
		S_Crtd_By, 
		Dt_Crtd_On
	)
	VALUES
	(
		@iBrandID,
		@sChargeCode,
		@sChargeDesc,
        @dtStart,
		@dtEnd,
		@iAmount,
		@sCrtdBy,
		@dtCrtdOn
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
