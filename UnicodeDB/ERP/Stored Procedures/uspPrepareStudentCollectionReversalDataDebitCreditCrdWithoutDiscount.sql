
CREATE PROCEDURE [ERP].[uspPrepareStudentCollectionReversalDataDebitCreditCrdWithoutDiscount]
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
	        
	-- colelction reversal data  excluding convenience and tax charges 
	        	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0), 
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0), 
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	
	UNION ALL
	
	-- colelction reversal data  convenience charge
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0),
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =16 AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0), 
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =16 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	
	UNION ALL
	
	--  colelction reversal data tax part
	        	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceChargeTax(ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			tttm.I_Tax_ID),0),
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Tax_ID IS NOT NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceChargeTax(ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			tttm.I_Tax_ID),0), 
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NOT NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	
	UNION ALL
	
	
	---collection deposit reversal
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0), 
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = 15 AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	AND trh.Dt_Deposit_Date IS NOT NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0),
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = 15 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	AND trh.Dt_Deposit_Date IS NOT NULL
	
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
	        
	-- colelction reversal data  excluding convenience and tax charges 
	        	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0), 
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0), 
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	-- colelction reversal data  convenience charge
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0),
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =16 AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0), 
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =16 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	--  colelction reversal data tax part
	        	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceChargeTax(ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			tttm.I_Tax_ID),0),
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Tax_ID IS NOT NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnCalculateConvenienceChargeTax(ISNULL(dbo.fnCalculateConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID),0),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			tttm.I_Tax_ID),0), 
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NOT NULL 
		AND tttm.I_Payment_Mode_ID =14 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	--AND trh.Dt_Deposit_Date IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	
	---collection deposit reversal
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0), 
			@dtExecutionDate,trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = 15 AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	AND trh.Dt_Deposit_Date IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, 
			ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge(ABS(trh.N_Receipt_Amount + ISNULL(trh.N_Tax_Amount,0)),tttm.I_Brand_ID,trh.Dt_Receipt_Date,
			trh.I_PaymentMode_ID,NULL),0),
			@dtExecutionDate, trh.S_ChequeDD_No, trh.Bank_Account_Name
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID = 15 AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 7
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND trh.I_PaymentMode_ID IN (13,14,15,16,17,19,20,21,22,23,24,25)
	AND trh.Dt_Deposit_Date IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
	
	
END
