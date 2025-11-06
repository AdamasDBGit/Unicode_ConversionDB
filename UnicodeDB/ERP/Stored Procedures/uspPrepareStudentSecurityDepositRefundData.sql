CREATE PROCEDURE [ERP].[uspPrepareStudentSecurityDepositRefundData]
(
	@dtExecutionDate DATETIME = NULL,
	@iBrandID INT=NULL
)
AS
BEGIN
	IF (@dtExecutionDate IS NULL)
		SET @dtExecutionDate = GETDATE()
		
		
	IF @iBrandID IS NULL
	
	BEGIN	
		
	INSERT INTO ERP.T_Student_Transaction_Details
	        ( 
	          I_Brand_ID ,
	          I_Transaction_Type_ID ,
	          I_Student_ID ,
	          I_Enquiry_Regn_ID ,
	          S_Cost_Center ,
	          N_Amount ,
	          Transaction_Date ,
	          Instrument_Number ,
	          Bank_Account_Name
	        )	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND trh.I_PaymentMode_ID = tttm.I_Payment_Mode_ID 
		AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 10
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0

	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd WITH (NOLOCK) ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Payment_Mode_ID IS NULL 
		AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 10
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Receipt_Type = 21			-- For Refund	

	UNION ALL
	
		SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd WITH (NOLOCK) ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID = trh.I_Receipt_Type AND tttm.I_Payment_Mode_ID IS NULL 
		AND tttm.I_Fee_Component_ID IS NULL	AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 11
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Receipt_Type = 21			-- For Refund
	
	END
	
	ELSE
	
	BEGIN
	
		INSERT INTO ERP.T_Student_Transaction_Details
	        ( 
	          I_Brand_ID ,
	          I_Transaction_Type_ID ,
	          I_Student_ID ,
	          I_Enquiry_Regn_ID ,
	          S_Cost_Center ,
	          N_Amount ,
	          Transaction_Date ,
	          Instrument_Number ,
	          Bank_Account_Name
	        )	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND trh.I_PaymentMode_ID = tttm.I_Payment_Mode_ID 
		AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 10
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd WITH (NOLOCK) ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Payment_Mode_ID IS NULL 
		AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 10
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Receipt_Type = 21			-- For Refund
	AND tbcd.I_Brand_ID=@iBrandID	

	UNION ALL
	
		SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd WITH (NOLOCK) ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID = trh.I_Receipt_Type AND tttm.I_Payment_Mode_ID IS NULL 
		AND tttm.I_Fee_Component_ID IS NULL	AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 11
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Receipt_Type = 21			-- For Refund
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
	
	
END
