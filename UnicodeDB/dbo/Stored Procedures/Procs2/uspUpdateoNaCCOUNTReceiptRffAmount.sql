CREATE PROCEDURE [dbo].[uspUpdateoNaCCOUNTReceiptRffAmount]
AS
BEGIN

	CREATE TABLE #temp 
	(
		ID_Identity INT IDENTITY(1,1),
		I_Receipt_Header_ID INT
	)

	INSERT INTO #temp
	SELECT I_Receipt_Header_ID FROM T_Receipt_Header where I_Receipt_Type <> 2 AND N_Amount_RFF is null

	
	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @ireceiptID INT
	SELECT @iRowCount = count(ID_Identity) FROM #temp
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN

		SELECT @ireceiptID =  I_Receipt_Header_ID FROM #temp where ID_Identity = @iCount
		
		DECLARE @CompanyShare NUMERIC(18,2)

		SELECT @CompanyShare = [dbo].fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,CM.I_Centre_Id,RH.I_receipt_Type,BCD.I_Brand_ID)
			FROM dbo.T_Centre_Master CM
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
			AND BCD.I_Status = 1
			inner join t_RECEIPT_Header RH
			ON RH.I_Centre_ID = CM.I_Centre_ID
			where RH.I_Receipt_Header_Id = @ireceiptID
		

		UPDATE dbo.T_Receipt_Header
		SET N_Amount_Rff = N_Receipt_Amount * @CompanyShare/100,
			N_Receipt_Tax_Rff = N_Tax_Amount * @CompanyShare / 100
		WHERE I_Receipt_Header_ID = @ireceiptID

		update dbo.T_OnAccount_Receipt_Tax
		set N_Tax_Rff = N_Tax_Paid * @CompanyShare / 100
		where I_Receipt_Header_ID = @ireceiptID


		SET @iCount = @iCount + 1
	end
	drop table #temp
END
