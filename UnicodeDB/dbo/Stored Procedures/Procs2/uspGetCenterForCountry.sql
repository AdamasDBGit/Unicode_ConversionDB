-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS center list for country
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCenterForCountry]
	@iCountryID INT	= NULL,
	@iBrandID INT = NULL
		
AS
BEGIN
	SET NOCOUNT OFF;
	
	IF ISNULL(@iCountryID,0) = 0 
	BEGIN
		SELECT CM.I_Centre_Id,CM.S_Center_Name,CM.I_Status,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE
		FROM dbo.T_Centre_Master CM WITH(NOLOCK)
		INNER JOIN dbo.T_Brand_Center_Details BCD WITH(NOLOCK)
		ON CM.I_Centre_Id = BCD.I_Centre_Id
		WHERE ISNULL(CM.I_Status,1) <> 0
			AND ISNULL(@iBrandID,BCD.I_Brand_ID) = BCD.I_Brand_ID
	END
	ELSE
	BEGIN	
		SELECT CM.I_Centre_Id,CM.S_Center_Name,CM.I_Status,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE
		FROM dbo.T_Centre_Master CM WITH(NOLOCK)
		INNER JOIN dbo.T_Brand_Center_Details BCD WITH(NOLOCK)
		ON CM.I_Centre_Id = BCD.I_Centre_Id
		WHERE ISNULL(CM.I_Status,1) <> 0
			AND I_Country_ID = @iCountryID
			AND ISNULL(@iBrandID,BCD.I_Brand_ID) = BCD.I_Brand_ID
	END
END
