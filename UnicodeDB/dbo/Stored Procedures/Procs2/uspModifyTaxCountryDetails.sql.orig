-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Tax master data
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyTaxCountryDetails]
	@iTaxID int,
	@iCountryID int,
	@sTaxCode varchar(10),
	@sTaxDesc varchar(50),
	@cIsSurcharge char(1),
	@sFeeCompIDs varchar(100),
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
			INSERT INTO dbo.T_Tax_Master
			(I_Country_ID,S_Tax_Code,S_Tax_Desc,C_Is_Surcharge,I_Status,Dt_Valid_From,Dt_Valid_To)
			VALUES
			(@iCountryID,@sTaxCode,@sTaxDesc,@cIsSurcharge,1,@dtDateFrom,@dtDateTo)		

			SELECT @iTaxID = @@IDENTITY 
		
			INSERT INTO dbo.T_Tax_Country_Fee_Component
			(I_Tax_ID,I_Country_ID,I_Fee_Component_ID,N_Tax_Rate,
			Dt_Valid_From,Dt_Valid_To,I_Status)
			SELECT @iTaxID,@iCountryID,*,@nTaxRate,@dtDateFrom,@dtDateTo,1
			FROM dbo.fnString2Rows(@sFeeCompIDs,',')
	
--			INSERT INTO dbo.T_Fee_Component_Tax
--			(I_Centre_Id,I_Fee_Component_ID,I_Tax_ID,N_Tax_Rate)
--			SELECT A.I_Centre_Id,B.*,@iTaxID,@nTaxRate
--			FROM dbo.T_Centre_Master A,dbo.fnString2Rows(@sFeeCompIDs,',') B
--			WHERE A.I_Country_ID = @iCountryID
			
				
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
			
			UPDATE dbo.T_Tax_Country_Fee_Component
			SET I_Status = 0,
			Dt_Valid_To = @dtCreatedOn
			WHERE I_Tax_ID = @iTaxID
			AND I_Country_ID = @iCountryID
			AND I_Fee_Component_ID IN (SELECT * FROM fnString2Rows(@sFeeCompIDs,','))
			
			INSERT INTO dbo.T_Tax_Country_Fee_Component
			(I_Tax_ID,I_Country_ID,I_Fee_Component_ID,N_Tax_Rate,
			Dt_Valid_From,Dt_Valid_To,I_Status)
			SELECT @iTaxID,@iCountryID,*,@nTaxRate,@dtDateFrom,@dtDateTo,1
			FROM dbo.fnString2Rows(@sFeeCompIDs,',')

--			DELETE FROM dbo.T_Fee_Component_Tax
--			WHERE I_Centre_Id in 
--			(SELECT I_Centre_Id FROM dbo.T_Centre_Master
--			WHERE I_Country_ID = @iCountryID)
--			AND I_Fee_Component_ID IN (SELECT * FROM fnString2Rows(@sFeeCompIDs,','))
--			AND I_Tax_ID = @iTaxID
--
--			INSERT INTO dbo.T_Fee_Component_Tax
--			(I_Centre_Id,I_Fee_Component_ID,I_Tax_ID,N_Tax_Rate)
--			SELECT A.I_Centre_Id,B.*,@iTaxID,@nTaxRate
--			FROM dbo.T_Centre_Master A,dbo.fnString2Rows(@sFeeCompIDs,',') B
--			WHERE A.I_Country_ID = @iCountryID
						
		END

	ELSE IF(@iFlag = 3)
		BEGIN
--			DELETE FROM dbo.T_Fee_Component_Tax
--			WHERE I_Centre_Id in 
--			(SELECT I_Centre_Id FROM dbo.T_Centre_Master
--			WHERE I_Country_ID = @iCountryID)
--			AND I_Fee_Component_ID IN (SELECT * FROM fnString2Rows(@sFeeCompIDs,','))
--			AND I_Tax_ID = @iTaxID

			UPDATE dbo.T_Tax_Country_Fee_Component
			SET I_Status = 0,
			Dt_Valid_To = @dtCreatedOn
			WHERE I_Tax_ID = @iTaxID
			AND I_Country_ID = @iCountryID
			AND I_Fee_Component_ID IN (SELECT * FROM fnString2Rows(@sFeeCompIDs,','))
		END
END
