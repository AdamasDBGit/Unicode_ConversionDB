CREATE PROCEDURE [dbo].[uspFTBatchGetCenterActiveReceiptsTax] --30
	@iCenterID INT
 
AS
BEGIN

	SELECT RTD.N_Tax_Paid,RTD.I_Tax_ID,TM.S_Tax_Code,RTD.N_Tax_Rff
	FROM  dbo.T_Receipt_Header RH
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
	INNER JOIN dbo.T_Tax_Master TM
	ON RTD.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1		

	SELECT OART.N_Tax_Paid,OART.I_Tax_ID,TM.S_Tax_Code,RH.I_Receipt_Header_ID,OART.N_Tax_Rff
	FROM  dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_OnAccount_Receipt_Tax OART
	ON RH.I_Receipt_Header_ID = OART.I_Receipt_Header_ID		
	INNER JOIN dbo.T_Tax_Master TM
	ON OART.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID
	

	SELECT RTD.N_Tax_Paid,RTD.I_Tax_ID,TM.S_Tax_Code,RTD.N_Tax_Rff
	FROM  dbo.T_Receipt_Header RH
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
	INNER JOIN dbo.T_Tax_Master TM
	ON RTD.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1		

	SELECT OART.N_Tax_Paid,OART.I_Tax_ID,TM.S_Tax_Code,OART.N_Tax_Rff
	FROM  dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_OnAccount_Receipt_Tax OART
	ON RH.I_Receipt_Header_ID = OART.I_Receipt_Header_ID		
	INNER JOIN dbo.T_Tax_Master TM
	ON OART.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

	CREATE TABLE #TempComponent
	(
		I_Tax_ID INT,
		N_Tax_Paid Numeric(18,2),
		N_Rff_Amount Numeric(18,2)
	)

	INSERT INTO #TempComponent
	SELECT RTD.I_Tax_ID,SUM(RTD.N_Tax_Paid),SUM(RTD.N_Tax_Rff)
	FROM  dbo.T_Receipt_Header RH
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
	INNER JOIN dbo.T_Tax_Master TM
	ON RTD.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1		
	GROUP BY RTD.I_Tax_ID

	INSERT INTO #TempComponent
	SELECT OART.I_Tax_ID,SUM(OART.N_Tax_Paid),SUM(OART.N_Tax_Rff)
	FROM  dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_OnAccount_Receipt_Tax OART
	ON RH.I_Receipt_Header_ID = OART.I_Receipt_Header_ID		
	INNER JOIN dbo.T_Tax_Master TM
	ON OART.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID
	GROUP BY OART.I_Tax_ID

	INSERT INTO #TempComponent
	SELECT RTD.I_Tax_ID,-SUM(RTD.N_Tax_Paid),-SUM(RTD.N_Tax_Rff)
	FROM  dbo.T_Receipt_Header RH
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
	INNER JOIN dbo.T_Tax_Master TM
	ON RTD.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1	
	GROUP BY RTD.I_Tax_ID

	INSERT INTO #TempComponent
	SELECT OART.I_Tax_ID,-SUM(OART.N_Tax_Paid),-SUM(OART.N_Tax_Rff)
	FROM  dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_OnAccount_Receipt_Tax OART
	ON RH.I_Receipt_Header_ID = OART.I_Receipt_Header_ID		
	INNER JOIN dbo.T_Tax_Master TM
	ON OART.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID
	GROUP BY OART.I_Tax_ID

	SELECT I_Tax_ID, SUM(N_Tax_Paid) AS N_Tax_Paid, SUM(N_Rff_Amount) AS N_Rff_Amount
	FROM #TempComponent GROUP BY I_Tax_ID

	DROP TABLE #TempComponent
	
END
