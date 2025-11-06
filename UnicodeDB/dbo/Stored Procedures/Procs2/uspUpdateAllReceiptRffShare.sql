CREATE PROCEDURE [dbo].[uspUpdateAllReceiptRffShare]
AS
BEGIN

	PRINT 'Receipt Child Company Share Updation started'	

	EXEC uspUpdateReceiptChildRffAmount

	PRINT 'Receipt Child Company Share Updated'
	
	EXEC uspUpdateReceiptRffAmount

	PRINT 'Receipt Header Company Share Updated'

	EXEC uspUpdateoNaCCOUNTReceiptRffAmount

	PRINT 'On Account Receipts Updated'
	
	EXEC uspOwnCenterUpdate
END
