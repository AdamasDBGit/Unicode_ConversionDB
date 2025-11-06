
CREATE PROCEDURE [ERP].[uspPrepareStudentAgencyPaymentDataReversal_AIS]
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
	          Bank_Account_Name,
			  Will_Restrict
	        )	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	-----added by susmita : 2024-March-28 : To Restrict ------
			,CASE WHEN RestrictInvoices.I_Invoice_Header_ID IS NOT NULL THEN 'true'  
			ELSE  NULL END Will_Restrict
			--------------------------------------------------------------
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = trh.I_PaymentMode_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID IN (15,17)
-----added by susmita : 2024-March-28 : To Restrict ------		
	LEFT JOIN
	(
	select TIP.I_Invoice_Header_ID from OracleWriteOffinvoicewillNotUndergo as ONU
	inner join 
	T_Invoice_Parent as TIP 
	on ONU.StudentDetailID=TIP.I_Student_Detail_ID and ONU.S_invoice_No=TIP.S_Invoice_No and I_Status=0
	)as RestrictInvoices  on RestrictInvoices.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
-----==============================================-------
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
	          Bank_Account_Name,
			  Will_Restrict
	        )	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	-----added by susmita : 2024-March-28 : To Restrict ------
			,CASE WHEN RestrictInvoices.I_Invoice_Header_ID IS NOT NULL THEN 'true'  
			ELSE  NULL END Will_Restrict
			--------------------------------------------------------------
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = trh.I_PaymentMode_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID IN (15,17)	
	-----added by susmita : 2024-March-28 : To Restrict ------		
			LEFT JOIN
	(
	select TIP.I_Invoice_Header_ID from OracleWriteOffinvoicewillNotUndergo as ONU
	inner join 
	T_Invoice_Parent as TIP 
	on ONU.StudentDetailID=TIP.I_Student_Detail_ID and ONU.S_invoice_No=TIP.S_Invoice_No and I_Status=0
	)as RestrictInvoices  on RestrictInvoices.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
-----==============================================-------
	WHERE DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL AND trh.I_Status=0
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
	
	
	
END
