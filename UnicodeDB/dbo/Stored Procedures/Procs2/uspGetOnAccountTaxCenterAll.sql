CREATE PROCEDURE [dbo].[uspGetOnAccountTaxCenterAll] 
	@iCenterID INT

AS
BEGIN

	SELECT * FROM dbo.T_Receipt_Type_Tax
	WHERE I_Centre_Id = @iCenterID
		
END
