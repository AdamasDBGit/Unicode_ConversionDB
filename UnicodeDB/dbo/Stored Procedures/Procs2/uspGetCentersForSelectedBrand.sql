CREATE PROCEDURE [dbo].[uspGetCentersForSelectedBrand] 
(
	@iBrandID int = null
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT CM.* FROM dbo.T_Centre_Master CM
	INNER JOIN T_Brand_Center_Details BCD
	ON BCD.I_Centre_ID = CM.I_Centre_ID
	WHERE CM.I_Status = 1
	AND BCD.I_Status = 1
	AND BCD.I_Brand_ID = ISNULL(@iBrandID,BCD.I_Brand_ID)
	
END
