CREATE PROCEDURE [dbo].[uspUpdateReceiptChildRffAmount]
AS
BEGIN

	CREATE TABLE #tempTable
	(	
		ID_Identity INT IDENTITY(1,1),
		I_Receipt_Comp_Detail_ID INT
	)
		
	INSERT INTO #tempTable
	SELECT I_Receipt_Comp_Detail_ID 
	FROM dbo.T_Receipt_Component_Detail
	where N_Comp_Amount_Rff is null 

	
	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @iReceiptCompID INT
	DECLARE @CompanyShare NUMERIC(18,2)
	SELECT @iRowCount = count(ID_Identity) FROM #tempTable
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN

		SELECT @iReceiptCompID =  I_Receipt_Comp_Detail_ID 
			FROM #tempTable 
			where ID_Identity = @iCount

		SELECT @CompanyShare = [dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,CM.I_Country_ID,RH.I_Centre_Id,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID) 
			FROM dbo.T_Receipt_Header RH
			INNER JOIN dbo.T_Receipt_Component_Detail RCD
			ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
			INNER JOIN dbo.T_Invoice_Child_Detail ICD
			ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
			INNER JOIN dbo.T_Invoice_Child_Header ICH
			ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = RH.I_Centre_Id
			AND BCD.I_Status = 1
			INNER JOIN dbo.T_Centre_Master CM
			ON RH.I_Centre_Id = CM.I_Centre_ID
			where RCD.I_Receipt_Comp_Detail_ID = @iReceiptCompID
		
		DECLARE @N_Amount_Rff numeric(18,2)
		DECLARE @N_Receipt_Tax_Rff NUMERIC(18,2)

		select @N_Amount_Rff = @CompanyShare * N_Amount_Paid/100
		FROM dbo.T_Receipt_Component_Detail
		WHERE I_Receipt_Comp_Detail_ID = @iReceiptCompID

		UPDATE T_Receipt_Component_Detail 
		SET N_Comp_Amount_Rff = @N_Amount_Rff
		WHERE I_Receipt_Comp_Detail_ID = @iReceiptCompID

        UPDATE dbo.T_Receipt_Tax_Detail
		SET N_Tax_Rff = @CompanyShare * N_Tax_Paid/100
		WHERE I_Receipt_Comp_Detail_ID = @iReceiptCompID

		PRINT 'Receipt Child Updation : ' + CAST(@iCount AS VARCHAR(20))

		SET @iCount = @iCount + 1
	end
	drop table #tempTable
END
