--uspGetFTReceiptDetails '313',1
CREATE PROCEDURE [dbo].[uspGetFTReceiptDetails] 
	@sReceiptIDs varchar(500),
	@iCenterID int = NULL

AS
BEGIN

	DECLARE @iCountryID INT

	SELECT @iCountryID = I_Country_ID
	FROM dbo.T_Centre_Master
	WHERE I_Centre_Id = @iCenterID

--	Get the table for the Fee Components for the receipts covered in the FT
	CREATE TABLE #TempTable
	(
		ID INT IDENTITY(1,1),
		S_Student_Name Varchar(150),
		I_Receipt_Header_ID INT,
		S_Component_Name VARCHAR(50),
		N_Amount_Paid NUMERIC(18,2),
		I_Receipt_Comp_Detail_ID INT,
		N_Tax_Paid NUMERIC(18,2),
		N_Company_Share NUMERIC(18,2)
	)

	CREATE TABLE #TempTable1
	(
		ID INT IDENTITY(1,1),
		S_Student_Name Varchar(150),
		I_Receipt_Header_ID INT,
		S_Component_Name VARCHAR(50),
		N_Amount_Paid NUMERIC(18,2),
		I_Receipt_Comp_Detail_ID INT,
		N_Tax_Paid NUMERIC(18,2),
		N_Company_Share NUMERIC(18,2)
	)


	INSERT INTO #TempTable
	SELECT SD.S_First_Name + ' ' + isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name as Student_Name,
	RH.I_Receipt_Header_ID,
	FCM.S_Component_Name,
	RCD.N_Amount_Paid,RCD.I_Receipt_Comp_Detail_ID,
	ISNULL(RTD.N_Tax_Paid,0) AS N_Tax_Paid,
	[dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,@iCountryID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID) AS N_Company_Share
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail RTD
	ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Center_Detail SCD
	ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
	AND SCD.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = SCD.I_Centre_Id
	AND BCD.I_Status = 1
	WHERE FCM.I_Status = 1
	AND RH.I_Receipt_Header_ID IN 
		(SELECT * FROM dbo.fnString2Rows(@sReceiptIDs,','))
	
	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @iReceiptDetailsID INT
	DECLARE @sCompName varchar(50)
	DECLARE @iReceiptID INT
	DECLARE @nTaxAmt NUMERIC(18,2)
	DECLARE @nReceiptAmt NUMERIC(18,2)

	SELECT @iRowCount = count(ID) FROM #tempTable
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @iReceiptDetailsID = I_Receipt_Comp_Detail_ID FROM #TempTable 
		WHERE ID = @iCount

		SELECT @nTaxAmt = SUM(N_Tax_Paid) FROM #TempTable WHERE I_Receipt_Comp_Detail_ID = @iReceiptDetailsID
		
		UPDATE #TempTable SET N_Tax_Paid = @nTaxAmt WHERE ID = @iCount


		UPDATE #TempTable SET I_Receipt_Comp_Detail_ID = 0 WHERE ID <> @iCount AND I_Receipt_Comp_Detail_ID = @iReceiptDetailsID

		SET @iCount = @iCount + 1
	END

	INSERT INTO #TempTable1 
	SELECT S_Student_Name,I_Receipt_Header_ID,S_Component_Name,N_Amount_Paid,
		I_Receipt_Comp_Detail_ID,N_Tax_Paid,N_Company_Share 
	FROM #TempTable WHERE I_Receipt_Comp_Detail_ID <> 0

	SELECT @iRowCount = count(ID) FROM #TempTable1
	SET @iCount = 1


	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sCompName = S_Component_Name,@iReceiptID = I_Receipt_Header_ID
		FROM #TempTable1 WHERE ID = @iCount 
		
		SELECT @nTaxAmt = SUM(N_Tax_Paid),
			@nReceiptAmt = SUM(N_Amount_Paid)
		FROM #TempTable1 
		WHERE S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID

		
		UPDATE #TempTable1 SET N_Tax_Paid = @nTaxAmt,N_Amount_Paid = @nReceiptAmt WHERE ID = @iCount

		UPDATE #TempTable1 SET S_Component_Name = NULL WHERE ID <> @iCount 
		AND S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID

		SET @iCount = @iCount + 1
	END

	SELECT S_Student_Name AS Student_Name,I_Receipt_Header_ID,S_Component_Name,N_Amount_Paid,
		N_Tax_Paid,ISNULL(N_Company_Share,0) AS N_Company_Share FROM #TempTable1
		WHERE S_Component_Name IS NOT NULL
	
	TRUNCATE TABLE #TempTable
	TRUNCATE TABLE #TempTable1





--	Get the Tax Component Details for the Receipts covered in the FT
	CREATE TABLE #TempTableTax
	(
		ID INT IDENTITY(1,1),
		S_Student_Name Varchar(150),
		I_Receipt_Header_ID INT,
		S_Component_Name VARCHAR(50),
		N_Amount_Paid NUMERIC(18,2),
		S_Tax_Code Varchar(50),
		N_Tax_Rate NUMERIC(18,2),
		N_Tax_Paid NUMERIC(18,2),
		N_Company_Share NUMERIC(18,2)
	)


	INSERT INTO #TempTableTax
	SELECT SD.S_First_Name + ' ' + isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name as Student_Name,
	RH.I_Receipt_Header_ID,
	FCM.S_Component_Name,
	RCD.N_Amount_Paid,
	TM.S_Tax_Code,
	FCT.N_Tax_Rate,
	ISNULL(RTD.N_Tax_Paid,0) AS N_Tax_Paid,
	ISNULL([dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,@iCountryID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail RTD
	ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Fee_Component_Tax FCT
	ON FCT.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Tax_Master TM
	ON RTD.I_Tax_ID = TM.I_Tax_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Center_Detail SCD
	ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
	AND SCD.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = SCD.I_Centre_Id
	AND BCD.I_Status = 1
	WHERE RTD.I_Tax_ID = FCT.I_Tax_ID
	AND FCT.I_Centre_Id = RH.I_Centre_Id
	AND FCM.I_Status = 1
	AND RH.I_Receipt_Header_ID IN 
		(SELECT * FROM dbo.fnString2Rows(@sReceiptIDs,','))


	DECLARE @sTaxCode varchar(50)
	SELECT @iRowCount = count(ID) FROM #tempTableTax
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sCompName = S_Component_Name,
			@iReceiptID = I_Receipt_Header_ID,
			@sTaxCode = S_Tax_Code
		FROM #TempTableTax WHERE ID = @iCount
		
		SELECT @nTaxAmt = SUM(N_Tax_Paid) FROM #TempTableTax 
		WHERE S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID
		AND S_Tax_Code = @sTaxCode

		
		UPDATE #TempTableTax SET N_Tax_Paid = @nTaxAmt WHERE ID = @iCount

		UPDATE #TempTableTax SET S_Component_Name = NULL WHERE ID <> @iCount 
		AND S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID
		AND S_Tax_Code = @sTaxCode

		SET @iCount = @iCount + 1
	END

	SELECT S_Student_Name,I_Receipt_Header_ID,S_Component_Name,
		N_Amount_Paid,S_Tax_Code,N_Tax_Rate,N_Tax_Paid,N_Company_Share
	FROM #TempTableTax WHERE S_Component_Name IS NOT NULL

	TRUNCATE TABLE #TempTableTax
--	get the receipts which have been cancelled and have not been adjusted in the fund transfer
	

	INSERT INTO #TempTable
	SELECT SD.S_First_Name + ' ' + isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name as Student_Name,
	RH.I_Receipt_Header_ID,
	FCM.S_Component_Name,
	RCD.N_Amount_Paid,RCD.I_Receipt_Comp_Detail_ID,
	ISNULL(RTD.N_Tax_Paid,0) AS N_Tax_Paid,
	[dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,@iCountryID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID) AS N_Company_Share
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail RTD
	ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Center_Detail SCD
	ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
	AND SCD.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = SCD.I_Centre_Id
	AND BCD.I_Status = 1
	WHERE FCM.I_Status = 1
	AND RH.I_Centre_Id = @iCenterID
	AND RH.I_Status = 0
	AND RH.S_Fund_Transfer_Status = 'Y'

	SELECT @iRowCount = count(ID) FROM #tempTable
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @iReceiptDetailsID = I_Receipt_Comp_Detail_ID FROM #TempTable 
		WHERE ID = @iCount
		
		SELECT @nTaxAmt = SUM(N_Tax_Paid) FROM #TempTable WHERE I_Receipt_Comp_Detail_ID = @iReceiptDetailsID
		
		UPDATE #TempTable SET N_Tax_Paid = @nTaxAmt WHERE ID = @iCount

		UPDATE #TempTable SET I_Receipt_Comp_Detail_ID = 0 WHERE ID <> @iCount AND I_Receipt_Comp_Detail_ID = @iReceiptDetailsID

		SET @iCount = @iCount + 1
	END

	INSERT INTO #TempTable1 
	SELECT S_Student_Name,I_Receipt_Header_ID,S_Component_Name,N_Amount_Paid,
		I_Receipt_Comp_Detail_ID,N_Tax_Paid,N_Company_Share 
	FROM #TempTable WHERE I_Receipt_Comp_Detail_ID <> 0

	SELECT @iRowCount = count(ID) FROM #TempTable1
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sCompName = S_Component_Name,@iReceiptID = I_Receipt_Header_ID
		FROM #TempTable1 WHERE ID = @iCount 
		
		SELECT @nTaxAmt = SUM(N_Tax_Paid),
			@nReceiptAmt = SUM(N_Amount_Paid)
		FROM #TempTable1 
		WHERE S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID

		
		UPDATE #TempTable1 SET N_Tax_Paid = @nTaxAmt,N_Amount_Paid = @nReceiptAmt WHERE ID = @iCount

		UPDATE #TempTable1 SET S_Component_Name = NULL WHERE ID <> @iCount 
		AND S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID

		SET @iCount = @iCount + 1
	END

	SELECT S_Student_Name AS Student_Name,I_Receipt_Header_ID,S_Component_Name,ISNULL(N_Amount_Paid,0) * (-1) AS N_Amount_Paid,
		ISNULL(N_Tax_Paid,0) * (-1) AS N_Tax_Paid,ISNULL(N_Company_Share,0) AS N_Company_Share FROM #TempTable
		WHERE S_Component_Name IS NOT NULL
	
	DROP TABLE #TempTable

	




--	Get the Tax Component Details for the Receipts covered in the FT but cancelled later
	INSERT INTO #TempTableTax
	SELECT SD.S_First_Name + ' ' + isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name as Student_Name,
	RH.I_Receipt_Header_ID,
	FCM.S_Component_Name,
	RCD.N_Amount_Paid,
	TM.S_Tax_Code,
	FCT.N_Tax_Rate,
	ISNULL(RTD.N_Tax_Paid,0) AS N_Tax_Paid,
	ISNULL([dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,@iCountryID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail RTD
	ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Fee_Component_Tax FCT
	ON FCT.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Tax_Master TM
	ON RTD.I_Tax_ID = TM.I_Tax_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Student_Center_Detail SCD
	ON SCD.I_Student_Detail_ID = SD.I_Student_Detail_ID
	AND SCD.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = SCD.I_Centre_Id
	AND BCD.I_Status = 1
	WHERE RTD.I_Tax_ID = FCT.I_Tax_ID
	AND FCT.I_Centre_Id = RH.I_Centre_Id
	AND FCM.I_Status = 1
	AND RH.I_Centre_Id = @iCenterID
	AND RH.I_Status = 0
	AND RH.S_Fund_Transfer_Status = 'Y'


	SELECT @iRowCount = count(ID) FROM #tempTableTax
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sCompName = S_Component_Name,
			@iReceiptID = I_Receipt_Header_ID,
			@sTaxCode = S_Tax_Code
		FROM #TempTableTax WHERE ID = @iCount
		
		SELECT @nTaxAmt = SUM(N_Tax_Paid) FROM #TempTableTax 
		WHERE S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID
		AND S_Tax_Code = @sTaxCode

		
		UPDATE #TempTableTax SET N_Tax_Paid = @nTaxAmt WHERE ID = @iCount

		UPDATE #TempTableTax SET S_Component_Name = NULL WHERE ID <> @iCount 
		AND S_Component_Name = @sCompName 
		AND I_Receipt_Header_ID = @iReceiptID
		AND S_Tax_Code = @sTaxCode

		SET @iCount = @iCount + 1
	END

	SELECT S_Student_Name,I_Receipt_Header_ID,S_Component_Name,
		N_Amount_Paid,S_Tax_Code,N_Tax_Rate,N_Tax_Paid,N_Company_Share
	FROM #TempTableTax WHERE S_Component_Name IS NOT NULL

END
