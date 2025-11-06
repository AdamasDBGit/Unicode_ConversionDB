
CREATE PROCEDURE [ERP].[uspPrepareStudentAgencyPaymentDataReversal_Arivoo]
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
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = trh.I_PaymentMode_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID IN (15,17)
	WHERE DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL AND trh.I_Status=0
	
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
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = trh.I_PaymentMode_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID IN (15,17)
	WHERE DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL AND trh.I_Status=0
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
	
	
	
END

