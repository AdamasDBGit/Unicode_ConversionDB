CREATE PROCEDURE [dbo].[uspFTBatchGetOwnCenterCashCollectionTax]
	@iCenterID INT
 
AS
BEGIN

	SELECT RTD.N_Tax_Paid,RTD.I_Tax_ID,TM.S_Tax_Code,
	ISNULL([dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,CM.I_Country_ID,1,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID),0) AS N_Company_Share
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
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1		

	SELECT OART.N_Tax_Paid,OART.I_Tax_ID,TM.S_Tax_Code,RH.I_Receipt_Header_ID,
	ISNULL(dbo.fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,RH.I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM  dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_OnAccount_Receipt_Tax OART
	ON RH.I_Receipt_Header_ID = OART.I_Receipt_Header_ID		
	INNER JOIN dbo.T_Tax_Master TM
	ON OART.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID
	

	SELECT RTD.N_Tax_Paid,RTD.I_Tax_ID,TM.S_Tax_Code,
	ISNULL([dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,CM.I_Country_ID,1,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID),0) AS N_Company_Share
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
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1		

	SELECT OART.N_Tax_Paid,OART.I_Tax_ID,TM.S_Tax_Code,
	ISNULL(dbo.fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,RH.I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM  dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_OnAccount_Receipt_Tax OART
	ON RH.I_Receipt_Header_ID = OART.I_Receipt_Header_ID		
	INNER JOIN dbo.T_Tax_Master TM
	ON OART.I_Tax_ID = TM.I_Tax_ID	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

	
END
