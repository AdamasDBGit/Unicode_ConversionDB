CREATE PROCEDURE [ERP].[uspPrepareStudentDiscountAccrualData] --exec [ERP].[uspPrepareStudentFeeAccrualData] '2017-07-07'
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
			tcm.S_Cost_Center, ABS(isnull(ticd.N_Discount_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	--INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID AND tttm.I_Status_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 20
	WHERE 
	DATEDIFF(dd,ticd.Dt_Installment_Date,@dtExecutionDate) = 0 
	--DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>=CONVERT(DATE,tip.Dt_Crtd_On) THEN ticd.Dt_Installment_Date
	--				 ELSE CONVERT(DATE,tip.Dt_Crtd_On) 
	--		    END,@dtExecutionDate) = 0 
	AND tip.I_Status IN (1,3,0,2)
	AND ISNULL(ticd.N_Discount_Amount,0)>0
	
	
	
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
			tcm.S_Cost_Center, ABS(isnull(ticd.N_Discount_Amount,0)), @dtExecutionDate, NULL, NULL
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	--INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID AND tttm.I_Status_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 20
	WHERE 
	DATEDIFF(dd,ticd.Dt_Installment_Date,@dtExecutionDate) = 0 
	--DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>=CONVERT(DATE,tip.Dt_Crtd_On) THEN ticd.Dt_Installment_Date
	--				 ELSE CONVERT(DATE,tip.Dt_Crtd_On) 
	--		    END,@dtExecutionDate) = 0 
	AND tip.I_Status IN (1,3,0,2)
	AND tbcd.I_Brand_ID=@iBrandID
	AND ISNULL(ticd.N_Discount_Amount,0)>0
	
	
	
	END
	
	
END
