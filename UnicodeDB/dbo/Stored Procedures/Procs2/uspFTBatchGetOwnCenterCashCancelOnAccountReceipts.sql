CREATE PROCEDURE [dbo].[uspFTBatchGetOwnCenterCashCancelOnAccountReceipts]
	@iCenterID INT
 
AS
BEGIN

	SELECT ISNULL(RH.N_Receipt_Amount,0) AS N_Amount_Paid,RH.S_Receipt_No,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,RH.S_ChequeDD_No,
	ISNULL(dbo.fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,@iCenterID,RH.I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM  dbo.T_Receipt_Header RH	
	INNER JOIN dbo.T_Centre_Master CM
	ON CM.I_Centre_Id = @iCenterID
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = @iCenterID
	AND BCD.I_Status = 1
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Status = 0
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

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
	WHERE RH.S_Fund_Transfer_Status = 'Y'
	AND RH.I_Status = 0
	AND RH.I_PaymentMode_ID = 1
	AND RH.I_Receipt_Type <> 2
	AND RH.I_Centre_Id = @iCenterID

END
