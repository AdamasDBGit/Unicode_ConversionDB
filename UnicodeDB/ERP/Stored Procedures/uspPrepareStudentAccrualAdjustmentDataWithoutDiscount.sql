CREATE PROCEDURE [ERP].[uspPrepareStudentAccrualAdjustmentDataWithoutDiscount] --exec [ERP].[uspPrepareStudentAccrualAdjustmentData] '2017-07-29'
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
			tcm.S_Cost_Center, CASE WHEN ABS(ticd.N_Amount_Due) > ABS(trcd.N_Amount_Paid) THEN ABS(trcd.N_Amount_Paid)
									ELSE ABS(ticd.N_Amount_Due) 
							   end, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end		
	WHERE ticd.Dt_Installment_Date is not null
	AND trh.Dt_Receipt_Date is not null
	AND tip.Dt_Crtd_On is not null
	AND DATEDIFF(dd, CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						  ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)
					 END, @dtExecutionDate) = 0
	--AND DATEDIFF(dd,ticd.Dt_Installment_Date, @dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(tidx.N_Tax_Value)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
									ELSE ABS(tidx.N_Tax_Value)
							   END, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidx ON ticd.I_Invoice_Detail_ID = tidx.I_Invoice_Detail_ID AND tidx.I_Tax_ID=trtd.I_Tax_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE ticd.Dt_Installment_Date is not null
	and trh.Dt_Receipt_Date is not null
	and tip.Dt_Crtd_On is not null
	and CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE,'2017-07-01') -- Commented by Raj
	and DATEDIFF(dd,CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						 ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
					ELSE trh.Dt_Receipt_Date END)
	END,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL

	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(tidx.N_Tax_Value_Scheduled)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
									ELSE ABS(tidx.N_Tax_Value_Scheduled)
							   END, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidx ON ticd.I_Invoice_Detail_ID = tidx.I_Invoice_Detail_ID AND tidx.I_Tax_ID=trtd.I_Tax_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE ticd.Dt_Installment_Date is not null
	and trh.Dt_Receipt_Date is not null
	and tip.Dt_Crtd_On is not null
	and CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE,'2017-07-01')
	and CONVERT(DATE,trh.Dt_Receipt_Date) >= CONVERT(DATE,ticd.Dt_Installment_Date)
	and DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL

	UNION ALL

	SELECT	TA.I_Brand_ID, tttm.I_Transaction_Type_ID, TA.I_Student_Detail_ID,NULL,
			TA.S_Cost_Center, TA.N_Tax_Value, @dtExecutionDate, NULL, NULL
	FROM(
		SELECT	tbcd.I_Brand_ID, tip.I_Student_Detail_ID,
					tcm.S_Cost_Center, ABS(SUM(ISNULL(A.N_Tax_Value,0))) AS N_Tax_Value,ticd.I_Fee_Component_ID 
		FROM( SELECT taicd.I_Advance_Ref_Invoice_Child_Detail_ID, taidt.N_Tax_Value, taidt.I_Tax_ID
			  FROM T_Invoice_Child_Detail icd
			  INNER JOIN T_Advance_Invoice_Child_Detail_Mapping taicd on icd.I_Invoice_Detail_ID = taicd.I_Advance_Ref_Invoice_Child_Detail_ID
			  INNER JOIN T_Advance_Invoice_Detail_Tax_Mapping taidt on taicd.I_Advance_Invoice_Child_Detail_Map_ID = taidt.I_Advance_Invoice_Detail_Map_ID
			  WHERE ISNULL(icd.Flag_IsAdvanceTax,'N') = 'Y' 
			  AND DATEDIFF(dd,CONVERT(DATE,icd.Dt_Installment_Date),@dtExecutionDate) = 0) A
			  INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON A.I_Advance_Ref_Invoice_Child_Detail_ID = ticd.I_Invoice_Detail_ID
			  INNER JOIN dbo.T_Invoice_Child_Header AS tich ON ticd.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID
			  INNER JOIN dbo.T_Invoice_Parent AS tip ON tich.I_Invoice_Header_ID = tip.I_Invoice_Header_ID	
			  INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
			  INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
		GROUP BY tbcd.I_Brand_ID, tip.I_Student_Detail_ID,tcm.S_Cost_Center,ticd.I_Fee_Component_ID ) TA
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON TA.I_Brand_ID = tttm.I_Brand_ID
			AND tttm.I_Fee_Component_ID = TA.I_Fee_Component_ID 
			AND tttm.I_Fee_Component_ID IS NOT NULL
			AND tttm.I_Payment_Mode_ID IS NULL 
			AND tttm.I_Status = 1
			AND tttm.I_Transaction_Nature_ID = 6			
	
	-----For history Data
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(ticd.N_Amount_Due) > ABS(trcd.N_Amount_Paid) THEN ABS(trcd.N_Amount_Paid)
			ELSE ABS(ticd.N_Amount_Due) end, 			
			@dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header_Archive AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail_Archive AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE 
	ticd.Dt_Installment_Date is not null
	AND trh.Dt_Receipt_Date is not null
	AND tip.Dt_Crtd_On is not null
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND DATEDIFF(dd, CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						  ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)
					 END, @dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(tidx.N_Tax_Value)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
			ELSE ABS(tidx.N_Tax_Value)
			END, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header_Archive AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail_Archive AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail_Archive AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidx ON ticd.I_Invoice_Detail_ID = tidx.I_Invoice_Detail_ID AND tidx.I_Tax_ID=trtd.I_Tax_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE ticd.Dt_Installment_Date is not null
	AND trh.Dt_Receipt_Date is not null
	AND tip.Dt_Crtd_On is not null
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND DATEDIFF(dd, CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
								     ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						  ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)
				     END, @dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	
	 --end 
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(ISNULL(trh.N_Receipt_Amount,0)) + ABS(ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
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
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(ticd.N_Amount_Due) > ABS(trcd.N_Amount_Paid) THEN ABS(trcd.N_Amount_Paid)
									ELSE ABS(ticd.N_Amount_Due) 
							   end, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end		
	WHERE ticd.Dt_Installment_Date is not null
	AND trh.Dt_Receipt_Date is not null
	AND tip.Dt_Crtd_On is not null
	AND DATEDIFF(dd, CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						  ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)
					 END, @dtExecutionDate) = 0
	--AND DATEDIFF(dd,ticd.Dt_Installment_Date, @dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(tidx.N_Tax_Value)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
									ELSE ABS(tidx.N_Tax_Value)
							   END, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidx ON ticd.I_Invoice_Detail_ID = tidx.I_Invoice_Detail_ID AND tidx.I_Tax_ID=trtd.I_Tax_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE ticd.Dt_Installment_Date is not null
	and trh.Dt_Receipt_Date is not null
	and tip.Dt_Crtd_On is not null
	and CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE,'2017-07-01') -- Commented by Raj
	and DATEDIFF(dd,CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						 ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
					ELSE trh.Dt_Receipt_Date END)
	END,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(tidx.N_Tax_Value_Scheduled)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
									ELSE ABS(tidx.N_Tax_Value_Scheduled)
							   END, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidx ON ticd.I_Invoice_Detail_ID = tidx.I_Invoice_Detail_ID AND tidx.I_Tax_ID=trtd.I_Tax_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE ticd.Dt_Installment_Date is not null
	and trh.Dt_Receipt_Date is not null
	and tip.Dt_Crtd_On is not null
	and CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE,'2017-07-01')
	and CONVERT(DATE,trh.Dt_Receipt_Date) >= CONVERT(DATE,ticd.Dt_Installment_Date)
	and DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT	TA.I_Brand_ID, tttm.I_Transaction_Type_ID, TA.I_Student_Detail_ID,NULL,
			TA.S_Cost_Center, TA.N_Tax_Value, @dtExecutionDate, NULL, NULL
	FROM(
		SELECT	tbcd.I_Brand_ID, tip.I_Student_Detail_ID,
					tcm.S_Cost_Center, ABS(SUM(ISNULL(A.N_Tax_Value,0))) AS N_Tax_Value,ticd.I_Fee_Component_ID 
		FROM( SELECT taicd.I_Advance_Ref_Invoice_Child_Detail_ID, taidt.N_Tax_Value, taidt.I_Tax_ID
			  FROM T_Invoice_Child_Detail icd
			  INNER JOIN T_Advance_Invoice_Child_Detail_Mapping taicd on icd.I_Invoice_Detail_ID = taicd.I_Advance_Ref_Invoice_Child_Detail_ID
			  INNER JOIN T_Advance_Invoice_Detail_Tax_Mapping taidt on taicd.I_Advance_Invoice_Child_Detail_Map_ID = taidt.I_Advance_Invoice_Detail_Map_ID
			  WHERE ISNULL(icd.Flag_IsAdvanceTax,'N') = 'Y' 
			  AND DATEDIFF(dd,CONVERT(DATE,icd.Dt_Installment_Date),@dtExecutionDate) = 0) A
			  INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON A.I_Advance_Ref_Invoice_Child_Detail_ID = ticd.I_Invoice_Detail_ID
			  INNER JOIN dbo.T_Invoice_Child_Header AS tich ON ticd.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID
			  INNER JOIN dbo.T_Invoice_Parent AS tip ON tich.I_Invoice_Header_ID = tip.I_Invoice_Header_ID	
			  INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
			  INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
			  WHERE tbcd.I_Brand_ID=@iBrandID
		GROUP BY tbcd.I_Brand_ID, tip.I_Student_Detail_ID,tcm.S_Cost_Center,ticd.I_Fee_Component_ID ) TA
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON TA.I_Brand_ID = tttm.I_Brand_ID
			AND tttm.I_Fee_Component_ID = TA.I_Fee_Component_ID 
			AND tttm.I_Fee_Component_ID IS NOT NULL
			AND tttm.I_Payment_Mode_ID IS NULL 
			AND tttm.I_Status = 1
			AND tttm.I_Transaction_Nature_ID = 6
			
						
	
	-----For history Data
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(ticd.N_Amount_Due) > ABS(trcd.N_Amount_Paid) THEN ABS(trcd.N_Amount_Paid)
			ELSE ABS(ticd.N_Amount_Due) end, 			
			@dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header_Archive AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail_Archive AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE 
	ticd.Dt_Installment_Date is not null
	AND trh.Dt_Receipt_Date is not null
	AND tip.Dt_Crtd_On is not null
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND DATEDIFF(dd, CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						  ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)
					 END, @dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, CASE WHEN ABS(tidx.N_Tax_Value)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
			ELSE ABS(tidx.N_Tax_Value)
			END, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header_Archive AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail_Archive AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail_Archive AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidx ON ticd.I_Invoice_Detail_ID = tidx.I_Invoice_Detail_ID AND tidx.I_Tax_ID=trtd.I_Tax_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE ticd.Dt_Installment_Date is not null
	AND trh.Dt_Receipt_Date is not null
	AND tip.Dt_Crtd_On is not null
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND DATEDIFF(dd, CASE WHEN (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
								     ELSE trh.Dt_Receipt_Date END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						  ELSE (CASE WHEN ticd.Dt_Installment_Date> trh.Dt_Receipt_Date THEN ticd.Dt_Installment_Date 
									 ELSE trh.Dt_Receipt_Date END)
				     END, @dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	 --end 
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(ISNULL(trh.N_Receipt_Amount,0)) + ABS(ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Tax_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 6
	WHERE DATEDIFF(dd,trh.Dt_Receipt_Date,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
		
END
