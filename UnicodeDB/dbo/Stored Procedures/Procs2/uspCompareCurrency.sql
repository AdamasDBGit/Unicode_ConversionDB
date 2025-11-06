CREATE PROCEDURE [dbo].[uspCompareCurrency]
(
	@iSourceCentreID INT,
	@iDestinationCentreID INT
)
AS
BEGIN
	DECLARE @bResult BIT
	DECLARE @iSourceCentreCurrencyID INT
	DECLARE @iDestinationCentreCurrencyID INT

	SELECT @iSourceCentreCurrencyID=COUNTRY.[I_Currency_ID] FROM [T_Country_Master] COUNTRY  WITH(NOLOCK)
	INNER JOIN [T_CENTRE_MASTER] CENTRE  WITH(NOLOCK) ON [COUNTRY].[I_Country_ID] = [CENTRE].[I_Country_ID]
	WHERE [CENTRE].[I_Centre_Id]=@iSourceCentreID

	SELECT @iDestinationCentreCurrencyID=COUNTRY.[I_Currency_ID] FROM [T_Country_Master] COUNTRY WITH(NOLOCK)
	INNER JOIN [T_CENTRE_MASTER] CENTRE WITH(NOLOCK) ON [COUNTRY].[I_Country_ID] = [CENTRE].[I_Country_ID]
	WHERE [CENTRE].[I_Centre_Id]=@iDestinationCentreID
	
	IF (@iSourceCentreCurrencyID = @iDestinationCentreCurrencyID)
		BEGIN
			select 1
		END
	ELSE
		BEGIN
			select 0
		END

	
END
