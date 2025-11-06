CREATE PROCEDURE [dbo].[uspModifyCompanyTaxMaster] 
	-- Add the parameters for the stored procedure here
	@iIndex INT,	
	@iBrandID INT,
	@iCountryID INT,
	@sTaxName VARCHAR(50),
	@sTaxDesc VARCHAR(50),
	@sCrtdBy VARCHAR(20),
	@dtCrtdOn DATETIME,
	@iFlag INT
AS
BEGIN
	SET NOCOUNT ON;
	IF(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Company_Tax_Master
			(I_Brand_ID,I_Country_ID,S_Tax_Name,S_Tax_Desc,
				I_Status,S_Crtd_By,Dt_Crtd_On)
			VALUES
			(@iBrandID,@iCountryID,@sTaxName,@sTaxDesc,1,@sCrtdBy,@dtCrtdOn)
		END

	IF(@iFlag=2)
		BEGIN
			UPDATE dbo.T_Company_Tax_Master
				SET I_Brand_ID = @iBrandID,
					I_Country_ID = @iCountryID,
					S_Tax_Name = @sTaxName,
					S_Tax_Desc = @sTaxDesc,
					S_Upd_By = @sCrtdBy,
					Dt_Upd_On = @dtCrtdOn
			WHERE I_Company_Tax_Master_ID = @iIndex
		END

	IF(@iFlag=3)
		BEGIN
			UPDATE dbo.T_Company_Tax_Master
				SET I_Status=0,
					S_Upd_By=@sCrtdBy,
					Dt_Upd_On=@dtCrtdOn	
			WHERE I_Company_Tax_Master_ID = @iIndex
		END

END
