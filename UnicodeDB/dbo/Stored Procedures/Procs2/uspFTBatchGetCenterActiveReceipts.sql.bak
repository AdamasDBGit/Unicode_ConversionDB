CREATE PROCEDURE [dbo].[uspFTBatchGetCenterActiveReceipts] --492
	@iCenterID INT

AS
BEGIN

	SELECT ISNULL(RCD.N_Amount_Paid,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,FCM.S_Component_Code,FCM.I_Fee_Component_ID,RCD.N_Comp_Amount_Rff
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 1	
	AND RH.I_Receipt_Type = 2
	AND FCM.I_Status = 1
	ORDER BY RH.I_Receipt_Header_ID

	SELECT ISNULL(RH.N_Receipt_Amount,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,0 AS I_Fee_Component_ID,RH.N_Amount_Rff
	FROM  dbo.T_Receipt_Header RH	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

	SELECT ISNULL(RCD.N_Amount_Paid,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,FCM.S_Component_Code,FCM.I_Fee_Component_ID,RCD.N_Comp_Amount_Rff
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 0	
	AND FCM.I_Status = 1

	SELECT ISNULL(RH.N_Receipt_Amount,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,0 AS I_Fee_Component_ID,RH.N_Amount_Rff
	FROM  dbo.T_Receipt_Header RH	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

	CREATE TABLE #TempComponent
	(
		I_Fee_Component_ID INT,
		N_Amount_Paid Numeric(18,2),
		N_Rff_Amount Numeric(18,2)
	)

	INSERT INTO #TempComponent
	SELECT FCM.I_Fee_Component_ID,SUM(ISNULL(RCD.N_Amount_Paid,0)),SUM(RCD.N_Comp_Amount_Rff)
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 1	
	AND RH.I_Receipt_Type = 2
	AND FCM.I_Status = 1
	Group BY FCM.I_Fee_Component_ID

	INSERT INTO #TempComponent
	SELECT 0,SUM(ISNULL(RH.N_Receipt_Amount,0)),SUM(RH.N_Amount_Rff)
	FROM  dbo.T_Receipt_Header RH	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

	INSERT INTO #TempComponent
	SELECT FCM.I_Fee_Component_ID,-SUM(ISNULL(RCD.N_Amount_Paid,0)),-SUM(RCD.N_Comp_Amount_Rff)
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Receipt_Component_Detail RCD
	ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail ICD
	ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Fee_Component_Master FCM
	ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID
	INNER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 0	
	AND FCM.I_Status = 1
	GROUP BY FCM.I_Fee_Component_ID

	INSERT INTO #TempComponent
	SELECT 0,-SUM(ISNULL(RH.N_Receipt_Amount,0)),-SUM(RH.N_Amount_Rff)
	FROM  dbo.T_Receipt_Header RH	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID
 
	SELECT I_Fee_Component_ID,SUM(ISNULL(N_Amount_Paid,0)) AS N_Amount_Paid,SUM(ISNULL(N_Rff_Amount,0)) AS N_Rff_Amount
	from #TempComponent GROUP BY I_Fee_Component_ID

	DROP TABLE #TempComponent

	CREATE TABLE #ReceiptList
	(
		I_Receipt_Header_ID INT,
		S_Receipt_No VARCHAR(20),
		Dt_Receipt_Date DATETIME
	)

	INSERT INTO #ReceiptList
	SELECT RH.I_Receipt_Header_ID,RH.S_Receipt_No,RH.Dt_Receipt_Date
	FROM dbo.T_Receipt_Header RH
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 1	

	INSERT INTO #ReceiptList
	SELECT RH.I_Receipt_Header_ID,RH.S_Receipt_No,RH.Dt_Upd_On
	FROM dbo.T_Receipt_Header RH
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 0
	
	SELECT * FROM #ReceiptList ORDER BY I_Receipt_Header_ID

	DROP TABLE #ReceiptList	

END
