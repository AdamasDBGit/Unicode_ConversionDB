CREATE PROCEDURE [dbo].[uspGetFTReceiptDetailsOnAccount] 
	@sReceiptIDs varchar(500),
	@sCancelledReceiptIDs varchar(500),
	@iCenterID int = NULL

AS
BEGIN

	DECLARE @iCountryID INT

	SELECT @iCountryID = I_Country_ID
	FROM dbo.T_Centre_Master
	WHERE I_Centre_Id = @iCenterID

--	Get the table for the Fee Components for the receipts covered in the FT
	SELECT ISNULL(SD.S_First_Name,ED.S_First_Name) + ' ' + ISNULL(isnull(SD.S_Middle_Name,ED.S_Middle_Name),'') + ' ' + ISNULL(SD.S_Last_Name,ED.S_Last_Name) as Student_Name,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,
	ISNULL(RH.N_Receipt_Amount,0) AS N_Receipt_Amount,	
	ISNULL(RH.N_Tax_Amount,0) AS N_Tax_Amount,
	ISNULL([dbo].fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,@iCountryID,@iCenterID,I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM dbo.T_Receipt_Header RH	
	LEFT OUTER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID	
	LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail ED
	ON RH.I_Enquiry_Regn_ID = ED.I_Enquiry_Regn_ID
	LEFT OUTER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = RH.I_Centre_ID
	AND BCD.I_Status = 1
	WHERE RH.I_Receipt_Header_ID IN 
		(SELECT * FROM dbo.fnString2Rows(@sReceiptIDs,','))

	SELECT ISNULL(SD.S_First_Name,ED.S_First_Name) + ' ' + ISNULL(isnull(SD.S_Middle_Name,ED.S_Middle_Name),'') + ' ' + ISNULL(SD.S_Last_Name,ED.S_Last_Name) as Student_Name,
	RH.I_Receipt_Header_ID,RH.I_Receipt_Type,
	ISNULL(RH.N_Receipt_Amount,0) * (-1) AS N_Receipt_Amount,	
	ISNULL(RH.N_Tax_Amount,0) * (-1) AS N_Tax_Amount,
	ISNULL([dbo].fnGetCompanyShareOnAccountReceipts(RH.Dt_Receipt_Date,@iCountryID,@iCenterID,I_Receipt_Type,BCD.I_Brand_ID),0) AS N_Company_Share
	FROM dbo.T_Receipt_Header RH	
	LEFT OUTER JOIN dbo.T_Student_Detail SD
	ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID	
	LEFT OUTER JOIN dbo.T_Enquiry_Regn_Detail ED
	ON RH.I_Enquiry_Regn_ID = ED.I_Enquiry_Regn_ID
	LEFT OUTER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = RH.I_Centre_ID
	AND BCD.I_Status = 1
	WHERE RH.I_Receipt_Header_ID IN 
		(SELECT * FROM dbo.fnString2Rows(@sCancelledReceiptIDs,','))

END
