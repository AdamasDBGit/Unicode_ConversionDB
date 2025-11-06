CREATE PROCEDURE [dbo].[uspGetTaxCountry] 
	@iTaxID int,
	@iCountryID int
AS
BEGIN

	SELECT I_Tax_ID,I_Country_ID,I_Fee_Component_ID,N_Tax_Rate,Dt_Valid_From,Dt_Valid_To
	FROM dbo.T_Tax_Country_Fee_Component
	WHERE I_Tax_ID = @iTaxID
	AND I_Country_ID = @iCountryID 
	AND I_Status = 1
	
END
