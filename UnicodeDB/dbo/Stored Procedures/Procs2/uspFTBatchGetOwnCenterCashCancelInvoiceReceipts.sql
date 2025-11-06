CREATE PROCEDURE [dbo].[uspFTBatchGetOwnCenterCashCancelInvoiceReceipts]
	@iCenterID INT
 
AS
BEGIN

	SELECT I_Receipt_Header_ID,S_Receipt_No,
	N_Receipt_Amount,S_ChequeDD_No
	FROM dbo.T_Receipt_Header
	WHERE I_Centre_Id = @iCenterID
	AND I_PaymentMode_ID = 1
	AND I_Receipt_Type = 2
	AND S_Fund_Transfer_Status = 'Y'
	AND I_Status = 0

	SELECT RCD.I_Receipt_Comp_Detail_ID,ISNULL(RCD.N_Amount_Paid,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,FCM.S_Component_Code,
	ISNULL([dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID),0) AS N_Company_Share
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
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type = 2
	AND FCM.I_Status = 1

	SELECT RTD.I_Receipt_Comp_Detail_ID,RTD.N_Tax_Paid,RTD.I_Tax_ID,TM.S_Tax_Code,
	ISNULL([dbo].fnGetCompanyShare(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,ICH.I_Course_ID,ICD.I_Fee_Component_ID,BCD.I_Brand_ID),0) AS N_Company_Share
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
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type = 2
	AND RH.I_Centre_Id = @iCenterID
	AND FCM.I_Status = 1

END
