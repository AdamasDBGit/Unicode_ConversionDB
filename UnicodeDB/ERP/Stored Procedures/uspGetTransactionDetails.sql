CREATE PROCEDURE [ERP].[uspGetTransactionDetails]
(
	@sHierarchyList VARCHAR(MAX),
	@iBrandID INT,
	@dtTransactionDate DATETIME = NULL
)
AS
BEGIN
	IF (@dtTransactionDate IS NULL)
	BEGIN
		SET @dtTransactionDate = GETDATE()
	END
		
	SELECT	tbm.S_Brand_Code, tcm.S_Center_Name, tcm.S_Cost_Center, ttnm.S_Nature_Of_Transaction, tttm.S_Transaction_Type,			
			tsd.S_First_Name + ' ' + ISNULL(tsd.S_Middle_Name,'') + ' ' + ISNULL(tsd.S_Last_Name,'') AS Student_Name,
			tstd.N_Amount, tstd.Instrument_Number, tstd.Bank_Account_Name
	FROM ERP.T_Student_Transaction_Details AS tstd
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID
	INNER JOIN erp.T_Transaction_Nature_Master AS ttnm ON tttm.I_Transaction_Nature_ID = ttnm.I_Transaction_Nature_ID
	INNER JOIN dbo.T_Student_Center_Detail AS tscd ON tscd.I_Student_Detail_ID = tstd.I_Student_ID
	INNER JOIN dbo.T_Student_Detail AS tsd ON tstd.I_Student_ID = tsd.I_Student_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON tcm.I_Centre_Id = tscd.I_Centre_Id
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tscd.I_Centre_Id = tbcd.I_Centre_Id
	INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON tscd.I_Centre_Id = FN1.CenterID
	WHERE tstd.I_Student_ID IS NOT NULL AND DATEDIFF(dd,tstd.Transaction_Date,@dtTransactionDate) = 0
	
	UNION ALL
	
	SELECT	tbm.S_Brand_Code, tcm.S_Center_Name, tcm.S_Cost_Center, ttnm.S_Nature_Of_Transaction, tttm.S_Transaction_Type,			
			terd.S_First_Name + ' ' + ISNULL(terd.S_Middle_Name,'') + ' ' + ISNULL(terd.S_Last_Name,'') AS Student_Name,
			tstd.N_Amount, tstd.Instrument_Number, tstd.Bank_Account_Name
	FROM ERP.T_Student_Transaction_Details AS tstd
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tstd.I_Transaction_Type_ID = tttm.I_Transaction_Type_ID
	INNER JOIN erp.T_Transaction_Nature_Master AS ttnm ON tttm.I_Transaction_Nature_ID = ttnm.I_Transaction_Nature_ID
	INNER JOIN dbo.T_Enquiry_Regn_Detail AS terd ON tstd.I_Enquiry_Regn_ID = terd.I_Enquiry_Regn_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON tcm.I_Centre_Id = terd.I_Centre_Id	
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON terd.I_Centre_Id = tbcd.I_Centre_Id
	INNER JOIN dbo.T_Brand_Master AS tbm ON tbcd.I_Brand_ID = tbm.I_Brand_ID
	INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON terd.I_Centre_ID = FN1.CenterID
	WHERE tstd.I_Student_ID IS NULL AND DATEDIFF(dd,tstd.Transaction_Date,@dtTransactionDate) = 0
		
	ORDER BY tcm.S_Cost_Center, tcm.S_Center_Name, ttnm.S_Nature_Of_Transaction, tttm.S_Transaction_Type, Student_Name
END
