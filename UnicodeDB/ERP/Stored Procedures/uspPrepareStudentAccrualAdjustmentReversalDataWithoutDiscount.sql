CREATE PROCEDURE [ERP].[uspPrepareStudentAccrualAdjustmentReversalDataWithoutDiscount] --exec [ERP].[uspPrepareStudentAccrualAdjustmentReversalData] '2017-07-29'
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
		AND tttm.I_Transaction_Nature_ID = 9
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE trh.I_Status = 0 
	--AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
	--ELSE trh.Dt_Upd_On END,@dtExecutionDate) = 0
	--debjit
	AND DATEDIFF(dd,CASE WHEN (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						 ELSE (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)
					END,@dtExecutionDate) = 0	
	--AND DATEDIFF(dd,ticd.Dt_Installment_Date, @dtExecutionDate) = 0
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
		AND tttm.I_Transaction_Nature_ID = 9
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE trh.I_Status = 0 
	AND CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE, '2017-07-01')
	AND DATEDIFF(dd,CASE WHEN (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						 ELSE (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)
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
		AND tttm.I_Transaction_Nature_ID = 9
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE trh.I_Status = 0 
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
	AND CONVERT(DATE,trh.Dt_Receipt_Date) >= CONVERT(DATE,ticd.Dt_Installment_Date)
	AND DATEDIFF(dd, trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL

	UNION ALL

	SELECT tbcd.I_Brand_ID,tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(ISNULL(trtd.N_Tax_Paid,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 9
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	WHERE trh.I_Status = 0 
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
	--AND CONVERT(DATE,trh.Dt_Upd_On) <= CONVERT(DATE,ticd.Dt_Installment_Date) -- Add By Raj
	AND CONVERT(DATE,trh.Dt_Receipt_Date) < CONVERT(DATE,ticd.Dt_Installment_Date)
	AND DATEDIFF(dd, trh.Dt_Upd_On,@dtExecutionDate) = 0
	
	-----For history Data
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center,  CASE WHEN ABS(ticd.N_Amount_Due) > ABS(trcd.N_Amount_Paid) THEN ABS(trcd.N_Amount_Paid)
									ELSE ABS(ticd.N_Amount_Due) 
								end, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header_Archive AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail_Archive AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 9
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID		
	WHERE DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						   ELSE tip.Dt_Upd_On 
					  END,@dtExecutionDate) = 0
	and CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tip.I_Status=0
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center,  CASE WHEN ABS(tidx.N_Tax_Value)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
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
		AND tttm.I_Transaction_Nature_ID = 9
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID		
	WHERE 
	--trh.I_Status = 0 AND 
	--DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
	--ELSE trh.Dt_Upd_On END,@dtExecutionDate) = 0
	DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
					 ELSE tip.Dt_Upd_On 
				END,@dtExecutionDate) = 0
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tip.I_Status=0
		
	---- end
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(ISNULL(trh.N_Receipt_Amount,0)) + ABS(ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 9
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
		AND tttm.I_Transaction_Nature_ID = 9
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE trh.I_Status = 0 
	--AND DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
	--ELSE trh.Dt_Upd_On END,@dtExecutionDate) = 0
	--debjit
	AND DATEDIFF(dd,CASE WHEN (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						 ELSE (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)
					END,@dtExecutionDate) = 0	
	--AND DATEDIFF(dd,ticd.Dt_Installment_Date, @dtExecutionDate) = 0
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
		AND tttm.I_Transaction_Nature_ID = 9
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE trh.I_Status = 0 
	AND CONVERT(DATE,ticd.Dt_Installment_Date) < CONVERT(DATE, '2017-07-01')
	AND DATEDIFF(dd,CASE WHEN (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)<CONVERT(DATE,tip.Dt_Crtd_On) THEN CONVERT(DATE,tip.Dt_Crtd_On)
						 ELSE (CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
									ELSE trh.Dt_Upd_On END)
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
		AND tttm.I_Transaction_Nature_ID = 9
	--added
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	--end	
	WHERE trh.I_Status = 0 
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
	AND CONVERT(DATE,trh.Dt_Receipt_Date) >= CONVERT(DATE,ticd.Dt_Installment_Date)
	AND DATEDIFF(dd, trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT tbcd.I_Brand_ID,tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,NULL,
			tcm.S_Cost_Center, ABS(ISNULL(trtd.N_Tax_Paid,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 9
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID
	WHERE trh.I_Status = 0 
	AND CONVERT(DATE,ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
	--AND CONVERT(DATE,trh.Dt_Upd_On) <= CONVERT(DATE,ticd.Dt_Installment_Date) -- Add By Raj
	AND CONVERT(DATE,trh.Dt_Receipt_Date) < CONVERT(DATE,ticd.Dt_Installment_Date)
	AND DATEDIFF(dd, trh.Dt_Upd_On,@dtExecutionDate) = 0	
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	-----For history Data
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center,  CASE WHEN ABS(ticd.N_Amount_Due) > ABS(trcd.N_Amount_Paid) THEN ABS(trcd.N_Amount_Paid)
									ELSE ABS(ticd.N_Amount_Due) 
								end, @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header_Archive AS trh
	INNER JOIN dbo.T_Receipt_Component_Detail_Archive AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND tttm.I_Status_ID IS NULL AND tttm.I_Fee_Component_ID = ticd.I_Fee_Component_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 9
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID		
	WHERE DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
						   ELSE tip.Dt_Upd_On 
					  END,@dtExecutionDate) = 0
	and CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tip.I_Status=0
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center,  CASE WHEN ABS(tidx.N_Tax_Value)> ABS(trtd.N_Tax_Paid) THEN ABS(trtd.N_Tax_Paid)
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
		AND tttm.I_Transaction_Nature_ID = 9
	INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID=trh.I_Invoice_Header_ID		
	WHERE 
	--trh.I_Status = 0 AND 
	--DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>trh.Dt_Upd_On THEN ticd.Dt_Installment_Date
	--ELSE trh.Dt_Upd_On END,@dtExecutionDate) = 0
	DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>tip.Dt_Upd_On THEN ticd.Dt_Installment_Date
					 ELSE tip.Dt_Upd_On 
				END,@dtExecutionDate) = 0
	AND CONVERT(DATE,tip.Dt_Upd_On) < CONVERT(DATE,'2017-07-01')
	AND trh.I_Invoice_Header_ID IS NOT NULL
	AND tip.I_Status=0
	AND tbcd.I_Brand_ID=@iBrandID
		
	---- end
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, trh.I_Student_Detail_ID,trh.I_Enquiry_Regn_ID,
			tcm.S_Cost_Center, ABS(ISNULL(trh.N_Receipt_Amount,0)) + ABS(ISNULL(trh.N_Tax_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Receipt_Header AS trh
	INNER JOIN dbo.T_Centre_Master AS tcm ON trh.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tcm.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tbcd.I_Brand_ID = tttm.I_Brand_ID
		AND trh.I_Receipt_Type = tttm.I_Status_ID AND tttm.I_Tax_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Fee_Component_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 9
	WHERE trh.I_Status = 0 AND DATEDIFF(dd,trh.Dt_Upd_On,@dtExecutionDate) = 0
	AND trh.I_Invoice_Header_ID IS NULL
	AND tbcd.I_Brand_ID=@iBrandID
	
	END
	
END
