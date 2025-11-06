CREATE PROCEDURE [dbo].[uspFTBatchGetOwnCenterCashCollection] --1
	@iCenterID INT
 
AS
BEGIN

	SELECT ISNULL(RCD.N_Amount_Paid,0) AS N_Amount_Paid,RH.S_Receipt_No,
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
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Status = 1	
	AND RH.I_Receipt_Type = 2
	AND FCM.I_Status = 1
	ORDER BY RH.I_Receipt_Header_ID

	SELECT ISNULL(RH.N_Receipt_Amount,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,
	ISNULL(dbo.fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,RH.I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM  dbo.T_Receipt_Header RH	
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

	SELECT ISNULL(RCD.N_Amount_Paid,0) AS N_Amount_Paid,RH.S_Receipt_No,
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
	AND RH.I_Centre_ID = @iCenterID
	AND RH.I_Status = 0	
	AND RH.I_PaymentMode_ID = 1
	AND FCM.I_Status = 1

	SELECT ISNULL(RH.N_Receipt_Amount,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,
	ISNULL(dbo.fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,RH.I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM  dbo.T_Receipt_Header RH	
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

	SELECT RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type
	FROM  dbo.T_Receipt_Header RH	
	WHERE RH.S_Fund_Transfer_Status = 'N'
	AND RH.I_Status = 1
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Centre_Id = @iCenterID
	ORDER BY RH.I_Receipt_Header_ID

END
