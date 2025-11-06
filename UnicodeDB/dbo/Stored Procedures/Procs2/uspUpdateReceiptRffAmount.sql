CREATE PROCEDURE [dbo].[uspUpdateReceiptRffAmount]
AS
BEGIN

	CREATE TABLE #temp3 
	(
		ID_Identity INT IDENTITY(1,1),
		I_Receipt_Header_ID INT
	)

	INSERT INTO #temp3
	SELECT I_Receipt_Header_ID FROM T_Receipt_Header where I_Receipt_Type = 2
	AND N_Amount_Rff is null

	
	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @ireceiptID INT
	SELECT @iRowCount = count(ID_Identity) FROM #temp3
	SET @iCount = 1

	print 'Total ' + CAST(@iRowCount AS VARCHAR(50))

	WHILE (@iCount <= @iRowCount)
	BEGIN

		SELECT @ireceiptID =  I_Receipt_Header_ID FROM #temp3 where ID_Identity = @iCount
		
		DECLARE @CompanyShare NUMERIC(18,2)
		DECLARE @N_Amount_Rff numeric(18,2)
		DECLARE @N_Receipt_Tax_Rff NUMERIC(18,2)

		SELECT @N_Amount_Rff = SUM (isnull(N_Comp_Amount_Rff,0)) 
		FROM dbo.T_Receipt_Component_Detail 
		WHERE I_Receipt_Detail_ID = @ireceiptID

		SELECT @N_Receipt_Tax_Rff = SUM (ISNULL(RTD.N_Tax_Rff,0))
		FROM dbo.T_Receipt_Tax_Detail RTD
		INNER JOIN dbo.T_Receipt_Component_Detail RCD
		ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
		WHERE RCD.I_Receipt_Detail_ID = @ireceiptID

		UPDATE dbo.T_Receipt_Header
		SET N_Amount_Rff = @N_Amount_Rff,
			N_Receipt_Tax_Rff = @N_Receipt_Tax_Rff
		WHERE I_Receipt_Header_ID = @ireceiptID

		print 'Update  ' + CAST(@iCount AS VARCHAR(50)) + '@@@' + CAST(@ireceiptID AS VARCHAR(50))

		SET @iCount = @iCount + 1
	end

	DROP TABLE #temp3
END
