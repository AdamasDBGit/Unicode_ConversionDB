CREATE PROCEDURE [ECOMMERCE].[uspUpdatePayoutTransctionDetails](@PayoutTransactionID INT,@TransactionStatus VARCHAR(MAX), @ReceiptHeaderID INT=NULL)
AS
BEGIN

	DECLARE @IsCompleted BIT=0
	DECLARE @CompletedOn DATETIME=NULL

	IF(@ReceiptHeaderID<=0)
		set @ReceiptHeaderID=NULL

	IF(@ReceiptHeaderID IS NOT NULL and @ReceiptHeaderID>0)
	BEGIN

		SET @IsCompleted=1
		SET @CompletedOn=GETDATE()

	END

	Update ECOMMERCE.T_Payout_Transaction set ReceiptHeaderID=@ReceiptHeaderID,IsCompleted=@IsCompleted,CompletedOn=@CompletedOn,TransactionStatus=@TransactionStatus
	where
	PayoutTransactionID=@PayoutTransactionID and IsCompleted=0 and StatusID=1 and ReceiptHeaderID IS NULL

END

