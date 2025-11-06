CREATE PROCEDURE [dbo].[uspGetCenterFunctionality] 
	@iCenterID INT

AS
BEGIN

	SELECT * FROM dbo.T_Center_Functionality_Status WHERE I_Center_ID = @iCenterID

END
