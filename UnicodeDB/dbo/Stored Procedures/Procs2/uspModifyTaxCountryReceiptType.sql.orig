-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the ReceiptType Tax Country Mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyTaxCountryReceiptType]
	@iTaxID int,
	@iCountryID int,	
	@sReceiptTypeIDs varchar(100),
	@nTaxRate numeric(10,6),
	@dtDateFrom datetime,
	@dtDateTo datetime,
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
	@iFlag int			
AS
BEGIN
	SET NOCOUNT OFF;

	if(@iFlag=1)
		BEGIN
				
			INSERT INTO dbo.T_Tax_Country_ReceiptType
			(I_Tax_ID,I_Country_ID,I_Receipt_Type,N_Tax_Rate,
			Dt_Valid_From,Dt_Valid_To,I_Status,S_Crtd_By,Dt_Crtd_On)
			SELECT @iTaxID,@iCountryID,*,@nTaxRate,@dtDateFrom,@dtDateTo,1,@sCreatedBy,@dtCreatedOn
			FROM dbo.fnString2Rows(@sReceiptTypeIDs,',')	
				
		END	
			
	ELSE IF(@iFlag=2)
		BEGIN
			
			UPDATE dbo.T_Tax_Country_ReceiptType
			SET I_Status = 0,
			Dt_Valid_To = @dtCreatedOn,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dtCreatedOn
			WHERE I_Tax_ID = @iTaxID
			AND I_Country_ID = @iCountryID
			AND I_Receipt_Type IN (SELECT * FROM fnString2Rows(@sReceiptTypeIDs,','))
			
			INSERT INTO dbo.T_Tax_Country_ReceiptType
			(I_Tax_ID,I_Country_ID,I_Receipt_Type,N_Tax_Rate,
			Dt_Valid_From,Dt_Valid_To,I_Status,S_Crtd_By,Dt_Crtd_On)
			SELECT @iTaxID,@iCountryID,*,@nTaxRate,@dtDateFrom,@dtDateTo,1,@sCreatedBy,@dtCreatedOn
			FROM dbo.fnString2Rows(@sReceiptTypeIDs,',')	
						
		END

	ELSE IF(@iFlag = 3)
		BEGIN
			UPDATE dbo.T_Tax_Country_ReceiptType
			SET I_Status = 0,
			Dt_Valid_To = @dtCreatedOn,
			S_Upd_By = @sCreatedBy,
			Dt_Upd_On = @dtCreatedOn
			WHERE I_Tax_ID = @iTaxID
			AND I_Country_ID = @iCountryID
			AND I_Receipt_Type IN (SELECT * FROM fnString2Rows(@sReceiptTypeIDs,','))
		END
END
