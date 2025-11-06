CREATE PROCEDURE [dbo].[TestReceipts]

AS
BEGIN

	DECLARE @iReceiptAmount numeric(10,2)
	DECLARE @iReceiptTaxAmount Numeric(10,2)
	
	DECLARE @iReceiptTemp INT

	DECLARE @receiptAmountHeader numeric(10,2)
	DECLARE @receiptAmountTaxHeader numeric(10,2)

	CREATE TABLE #TempReceipt
	(
		ID_Identity INT IDENTITY(1,1),
		I_Receipt_Header_ID INT
	)
		
	INSERT INTO #TempReceipt
	SELECT  I_Receipt_Header_ID FROM  dbo.T_Receipt_Header

	DECLARE @iCount INT
	DECLARE @iRowCount INT
	SELECT @iRowCount = count(ID_Identity) FROM #TempReceipt
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @iReceiptTemp = I_Receipt_Header_ID from #TempReceipt where ID_Identity = @iCount

		SELECT @iReceiptAmount = SUM(N_Amount_Paid) FROM dbo.T_Receipt_Component_Detail	
			WHERE  I_Receipt_Detail_ID = @iReceiptTemp

		SELECT @iReceiptTaxAmount = SUM(N_Tax_Paid) FROM dbo.T_Receipt_Tax_Detail
			WHERE I_Receipt_Comp_Detail_ID IN
				(
					SELECT I_Receipt_Comp_Detail_ID FROM dbo.T_Receipt_Component_Detail	
						WHERE  I_Receipt_Detail_ID = @iReceiptTemp
				)
		SELECT @receiptAmountHeader = N_Receipt_Amount,@receiptAmountTaxHeader = N_Tax_Amount
			FROM dbo.T_Receipt_Header WHERE I_Receipt_Header_ID = @iReceiptTemp
			
		IF (@receiptAmountHeader <> @iReceiptAmount) AND (@receiptAmountTaxHeader <> @iReceiptTaxAmount)
		BEGIN
			
			SELECT * FROM dbo.T_Receipt_Header WHERE I_Receipt_Header_ID = @iReceiptTemp
	
		END

		SET @iCount = @iCount + 1
	END	
END
