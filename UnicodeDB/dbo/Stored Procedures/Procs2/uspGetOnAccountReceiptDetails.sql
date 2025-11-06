/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 03/04/2007
Description: Select List of components that were to be paid before the present date
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetOnAccountReceiptDetails]
(
	@iReceiptID int
)

AS
BEGIN

SELECT * FROM T_Receipt_Header 
WHERE I_Receipt_Header_ID = @iReceiptID

SELECT * FROM dbo.T_OnAccount_Receipt_Tax
WHERE I_Receipt_Header_ID = @iReceiptID


END
