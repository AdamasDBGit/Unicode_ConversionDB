-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/06/2007
-- Description:	Get the fee sharing percentage for different receipt types
-- =============================================

CREATE PROCEDURE [dbo].[uspGetReceiptTypeFeeSharing]
(
	@iCountryID INT = NULL,
	@iCenterID INT = NULL,
	@iReceiptType INT = NULL,
	@iReceiptDate Datetime
)

AS
BEGIN
	DECLARE @iBrandID INT
	
	SELECT @iBrandID = I_Brand_ID from dbo.T_Brand_Center_Details
	WHERE I_Status = 1 and I_Centre_ID = @iCenterID
	
	SELECT ISNULL(dbo.fnGetCompanyShareOnAccountReceipts(@iReceiptDate,@iCountryID,@iCenterID,@iReceiptType,@iBrandID),0) AS CompanyShare

END
