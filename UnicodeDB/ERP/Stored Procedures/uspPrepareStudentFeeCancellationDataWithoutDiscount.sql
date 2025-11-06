CREATE PROCEDURE [ERP].[uspPrepareStudentFeeCancellationDataWithoutDiscount] --exec [ERP].[uspPrepareStudentFeeCancellationData] '2017-07-29'
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

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(ticd.N_Amount_Due), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01') 
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE  tip.Dt_Upd_On 
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(tidt.N_Tax_Value_Scheduled), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0 
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE  tip.Dt_Upd_On 
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	
	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(ISNULL(tcnicd.N_Amount_Due,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0 	
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE tip.Dt_Upd_On
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			--tcm.S_Cost_Center, ABS(ISNULL(tcnidt.N_Tax_Value,0)), @dtExecutionDate, NULL, NULL
			tcm.S_Cost_Center, ISNULL(tcnidt.N_Tax_Value,0), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0 
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE tip.Dt_Upd_On
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'

	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			--tcm.S_Cost_Center, ABS(ISNULL(tcnidt.N_Tax_Value,0)), @dtExecutionDate, NULL, NULL
			tcm.S_Cost_Center, ISNULL(tcnidt.N_Tax_Value,0), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE DATEDIFF(dd,tcnicd.Dt_Crtd_On,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')='Y'

	UNION ALL

	SELECT tbcd.I_Brand_ID,tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			--tcm.S_Cost_Center, ABS(ISNULL(trtd.N_Tax_Paid,0)), @dtExecutionDate, NULL, NULL
			tcm.S_Cost_Center, ISNULL(trtd.N_Tax_Paid,0), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND trtd.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	WHERE trh.I_Status = 0 
	--AND CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE, '2017-07-01')
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE,trh.Dt_Upd_On) -- RAJ
	AND CONVERT(DATE,trh.Dt_Receipt_Date) < CONVERT(DATE,ticd.Dt_Installment_Date)
	AND DATEDIFF(dd, trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	
	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(toart.N_Tax_Paid), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_OnAccount_Receipt_Tax AS toart ON trh.I_Receipt_Header_ID = toart.I_Receipt_Header_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Tax_ID = toart.I_Tax_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	
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

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(ticd.N_Amount_Due), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01') 
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE  tip.Dt_Upd_On 
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(tidt.N_Tax_Value_Scheduled), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt WITH (NOLOCK) ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0 
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE  tip.Dt_Upd_On 
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(ISNULL(tcnicd.N_Amount_Due,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tttm.I_Status_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0 	
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE tip.Dt_Upd_On
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			--tcm.S_Cost_Center, ABS(ISNULL(tcnidt.N_Tax_Value,0)), @dtExecutionDate, NULL, NULL
			tcm.S_Cost_Center, ISNULL(tcnidt.N_Tax_Value,0), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt WITH (NOLOCK) ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE tip.I_Status = 0 
	AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date> tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						 ELSE tip.Dt_Upd_On
					END,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			--tcm.S_Cost_Center, ABS(ISNULL(tcnidt.N_Tax_Value,0)), @dtExecutionDate, NULL, NULL
			tcm.S_Cost_Center, ISNULL(tcnidt.N_Tax_Value,0), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd WITH (NOLOCK) ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt WITH (NOLOCK) ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE DATEDIFF(dd,tcnicd.Dt_Crtd_On,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')='Y'
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT tbcd.I_Brand_ID,tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			--tcm.S_Cost_Center, ABS(ISNULL(trtd.N_Tax_Paid,0)), @dtExecutionDate, NULL, NULL
			tcm.S_Cost_Center, ISNULL(trtd.N_Tax_Paid,0), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd WITH (NOLOCK) ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd WITH (NOLOCK) ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd WITH (NOLOCK) ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND trtd.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	WHERE trh.I_Status = 0 
	--AND CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE, '2017-07-01')
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE,trh.Dt_Upd_On) -- RAJ
	AND CONVERT(DATE,trh.Dt_Receipt_Date) < CONVERT(DATE,ticd.Dt_Installment_Date)
	AND DATEDIFF(dd, trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(trh.N_Receipt_Amount), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(toart.N_Tax_Paid), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh WITH (NOLOCK)
	INNER JOIN dbo.T_OnAccount_Receipt_Tax AS toart WITH (NOLOCK) ON trh.I_Receipt_Header_ID = toart.I_Receipt_Header_ID
	INNER JOIN dbo.T_Centre_Master AS tcm WITH (NOLOCK) ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd WITH (NOLOCK) ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm WITH (NOLOCK) ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Tax_ID = toart.I_Tax_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 2
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
	

END
