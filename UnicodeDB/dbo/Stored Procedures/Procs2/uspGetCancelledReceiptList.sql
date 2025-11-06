/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 17/07/2007
Description: return list of receipts for a center for which fund transfer has been done and the receipt has been cancelled
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetCancelledReceiptList]
(
	@iCenterID int
)

AS
BEGIN

SELECT * FROM T_Receipt_Header 
WHERE I_Centre_Id = @iCenterID
	AND I_Status = 0
	AND S_Fund_Transfer_Status = 'Y'
	AND I_Receipt_Type = 2 

END
