CREATE PROCEDURE [dbo].[uspUpdateTaxCenterFeeComponent] 
(
	@iIndex INT,
	@iTaxID INT,
	@iCenterID INT,
	@iFeeComponentID INT,
	@nTaxRate NUMERIC(18,2),
	@dtValidFrom Datetime,
	@dtValidTo DateTime,
	@sCrtdBy VARCHAR(20),
	@dtCrtdOn DATETIME,
	@iFlag INT
)
AS
BEGIN

	IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Fee_Component_Tax
		(I_Tax_ID,I_Centre_Id,I_Fee_Component_ID,N_Tax_Rate,
			Dt_Valid_From,Dt_Valid_To,I_Status,S_Crtd_By,Dt_Crtd_On)
		VALUES
		(@iTaxID,@iCenterID,@iFeeComponentID,@nTaxRate,@dtValidFrom,
			@dtValidTo,1,@sCrtdBy,@dtCrtdOn)
		
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Fee_Component_Tax
		SET N_Tax_Rate = @nTaxRate,
			Dt_Valid_From = @dtValidFrom,
			Dt_Valid_To = @dtValidTo,
			S_Upd_By = @sCrtdBy,
			Dt_Upd_On = @dtCrtdOn
		WHERE I_Center_Tax_FeeComponent_ID = @iIndex
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Fee_Component_Tax
		SET Dt_Valid_To = @dtCrtdOn,
			S_Upd_By = @sCrtdBy,
			Dt_Upd_On = @dtCrtdOn,
			I_Status = 0
		WHERE I_Center_Tax_FeeComponent_ID = @iIndex
	END
		
END
