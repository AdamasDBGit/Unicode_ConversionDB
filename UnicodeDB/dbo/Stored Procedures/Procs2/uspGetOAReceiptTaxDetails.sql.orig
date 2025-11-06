CREATE PROCEDURE [dbo].[uspGetOAReceiptTaxDetails]
	@sReceiptIDs Varchar(1000)

AS
BEGIN

	SELECT OA.I_Tax_ID,OA.N_Tax_Paid,RH.I_Status,
	dbo.fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,CM.I_Country_ID,CM.I_Centre_ID,RH.I_Receipt_Type,BCD.I_Brand_ID) AS Company_Share
	FROM dbo.T_OnAccount_Receipt_Tax OA
	INNER JOIN dbo.T_Receipt_Header RH
	ON OA.I_Receipt_Header_ID = RH.I_Receipt_Header_ID
	INNER JOIN dbo.T_Centre_Master CM
	ON RH.I_Centre_Id = CM.I_Centre_Id
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = CM.I_Centre_Id
	AND BCD.I_Status = 1
	WHERE OA.I_Receipt_Header_ID IN 
	(SELECT * FROM dbo.fnString2Rows(@sReceiptIDs,','))

END
