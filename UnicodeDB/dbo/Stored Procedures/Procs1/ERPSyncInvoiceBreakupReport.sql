-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ERPSyncInvoiceBreakupReport
	-- Add the parameters for the stored procedure here	 
	 @iBrandID INT=110,
	 @dtStartDate datetime='2025-08-01',
	 @dtEndDate datetime='2025-08-31'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		create table #temp
	(
	BrandID int,
	TransactionTypeID int,
	StudentDetailID int,
	StudentID varchar(max),
	CostCentre varchar(max),
	Amount decimal(14,2),
	TransactionDate datetime,
	CreditNoteNo varchar(max),
	FeeComponent varchar(max)
	)

	Declare @dtExecutionDate DATETIME=NULL

SET @dtExecutionDate = @dtStartDate  --mm/dd/yyyy
WHILE (DATEDIFF(dd,@dtExecutionDate,@dtEndDate) >= 0)
BEGIN
	
	insert into #temp


	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,tsd.S_Student_ID,
			tcm.S_Cost_Center, ABS(isnull(ticd.N_Amount_Due,0)-isnull(ticd.N_Discount_Amount,0)), @dtExecutionDate, ticd.S_Invoice_Number,tttm.S_Transaction_Code --susmita: 2022-10-10 : consider discount
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	--INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID AND tttm.I_Status_ID IS NULL 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Tax_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 1
		inner join T_Student_Detail tsd on tsd.I_Student_Detail_ID=tip.I_Student_Detail_ID	
	WHERE 
	--DATEDIFF(dd,ticd.Dt_Installment_Date,@dtExecutionDate) = 0 
	DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>=CONVERT(DATE,tip.Dt_Crtd_On) THEN ticd.Dt_Installment_Date
					 ELSE CONVERT(DATE,tip.Dt_Crtd_On) 
			    END,@dtExecutionDate) = 0 
	AND tip.I_Status IN (1,3,0,2)
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	AND tbcd.I_Brand_ID=@iBrandID
	
	UNION ALL
	
	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,tsd.S_Student_ID,
			tcm.S_Cost_Center,
			----CASE WHEN (ISNULL(tidt.N_Tax_Value_Scheduled,0) - ISNULL(A.tax_paid,0)) >= 0 THEN (ISNULL(tidt.N_Tax_Value_Scheduled,0) - ISNULL(A.tax_paid,0))
			----	 ELSE 0
			----END,

			--(CASE WHEN (ABS(IsNull(ticd.N_Amount_Due,0)) > ABS(IsNull(A.N_Amount_Paid,0))) THEN (((ABS(IsNull(ticd.N_Amount_Due,0))-ABS(IsNull(A.N_Amount_Paid,0)))*9)/100)
			--	 --ELSE (ABS(IsNull(ticd.N_Amount_Due,0))*9)/100
			--	 ELSE 0.00
			--END),

			----(CASE WHEN (ABS(IsNull(ticd.N_Amount_Due,0)) > ABS(IsNull(A.N_Amount_Paid,0))) THEN CAST(IsNull((((ABS(IsNull(ticd.N_Amount_Due,0))-ABS(IsNull(A.N_Amount_Paid,0)))*
			----(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			----tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))
			----ELSE 
			----CAST(IsNull((((ABS(IsNull(A.N_Amount_Paid,0)))*
			----(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			----tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))
			----	 --ELSE 0.00
			----END),

			(CASE WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0)),0) > ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=1) THEN CAST(IsNull((((ROUND((ABS(IsNull(ticd.N_Amount_Due,0)-ISNULL(ticd.N_Discount_Amount,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))*--2022-10-10 susmita
			--(CASE WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)),0) > ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=1) THEN CAST(IsNull((((ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))* 2022-10-10 susmita backup
			(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))

			WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0)),0) = ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=1) --consider discount : susmita : 2022-10-10
			THEN CAST(IsNull((((ROUND((ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))* --consider discount : susmita : 2022-10-10
			/*WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)),0) = ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=1) 
			THEN CAST(IsNull((((ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))**/--backup : 2022-10-10 : susmita
			--THEN CAST(IsNull(((((ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))+ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))*
			(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))

			WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0)),0) = ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) THEN CAST(IsNull(((ROUND((ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0))),0)*--consider discount : susmita : 2022-10-10
			--WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)),0) = ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) THEN CAST(IsNull(((ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)* --backup : 2022-10-10 : susmita
			(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))

			
			----WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)),0) > ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) THEN CAST(IsNull(((ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)*
			--WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)),0) > ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) THEN CAST(IsNull((((ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))*
			WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0)),0) > ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2) --consider discount : susmita : 2022-10-10
			--WHEN ((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)),0) > ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)) AND A.RcptSameDate=2)--backup : 2022-10-10 : susmita 
			THEN CAST(IsNull(((((ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))+ROUND((ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0)-IsNull(ticd.N_Discount_Amount,0))),0))* --consider discount : susmita : 2022-10-10
			--THEN CAST(IsNull(((((ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))+ROUND((ABS(IsNull(ticd.N_Amount_Due,0))),0)-ROUND((ABS(IsNull(A.N_Amount_Paid,0))),0))*--backup : 2022-10-10 : susmita
			(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))


			WHEN (( ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0) > ROUND(ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0)),0)) AND A.RcptSameDate=2) THEN CAST(IsNull(((ROUND((ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0))),0)* --susmita : 2022-10-10 : consider discount
			(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))


			WHEN ROUND(ABS(IsNull(A.N_Amount_Paid,0)),0)=0 THEN
			CAST(IsNull((((ROUND(ABS(IsNull(ticd.N_Amount_Due,0)-IsNull(ticd.N_Discount_Amount,0)),0))* --consider discount : 2022-10-10 : susmita
			(Select tcfc.N_Tax_Rate From T_Tax_Country_Fee_Component as tcfc where 
			tcfc.I_Fee_Component_ID = ticd.I_Fee_Component_ID and tidt.I_Tax_ID=tcfc.I_Tax_ID and @dtExecutionDate between Dt_Valid_From and Dt_Valid_To))/100),0) AS decimal(18,2))
			ELSE 0.00
			END),

			@dtExecutionDate,ticd.S_Invoice_Number,tttm.S_Transaction_Code
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
	inner join T_Student_Detail tsd on tsd.I_Student_Detail_ID=tip.I_Student_Detail_ID	
	LEFT JOIN (
		Select RAmt.I_Invoice_Detail_ID,SUM(RAmt.N_Amount_Paid) AS N_Amount_Paid,(MAX(RAmt.RcptSameDate)) AS RcptSameDate From (
		SELECT  ticd1.I_Invoice_Detail_ID,IsNull(trcd.N_Amount_Paid,0) AS N_Amount_Paid

		,(CASE WHEN (CONVERT(DATE,MAX(trh.Dt_Receipt_Date))<CONVERT(DATE,ticd1.Dt_Installment_Date)) THEN 1
			   WHEN (CONVERT(DATE,MAX(trh.Dt_Receipt_Date))=CONVERT(DATE,ticd1.Dt_Installment_Date)) THEN 2 END) AS RcptSameDate 

		FROM dbo.T_Receipt_Header AS trh
		INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
		INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
		INNER JOIN dbo.T_Invoice_Child_Detail AS ticd1 ON trcd.I_Invoice_Detail_ID = ticd1.I_Invoice_Detail_ID
		
		Inner Join T_Invoice_Child_Header as ch On ticd1.I_Invoice_Child_Header_ID=ch.I_Invoice_Child_Header_ID
		Inner Join T_Invoice_Parent AS tip1 On tip1.I_Invoice_Header_ID=ch.I_Invoice_Header_ID 

		----AND (CONVERT(DATE,ticd1.Dt_Installment_Date)<IsNull(CONVERT(DATE,tip1.Dt_Upd_On),CONVERT(DATE,GETDATE())))
		----AND CONVERT(DATE,ticd1.Dt_Installment_Date)<IsNull(CONVERT(DATE,trh.Dt_Upd_On),CONVERT(DATE,GETDATE()))

		----AND (trh.I_Status=1 AND (CONVERT(DATE,ticd1.Dt_Installment_Date)<IsNull(CONVERT(DATE,tip1.Dt_Upd_On),CONVERT(DATE,GETDATE())))
		----OR (trh.I_Status=0 AND CONVERT(DATE,ticd1.Dt_Installment_Date)<IsNull(CONVERT(DATE,trh.Dt_Upd_On),CONVERT(DATE,GETDATE()))))

		--AND (trh.I_Status=1 AND (CONVERT(DATE,ticd1.Dt_Installment_Date)<IsNull(CONVERT(DATE,tip1.Dt_Upd_On),CONVERT(DATE,GETDATE())))
		--OR (trh.I_Status=0 AND (CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)>=CONVERT(DATE,trh.Dt_Crtd_On)
		--THEN CONVERT(DATE,ticd1.Dt_Installment_Date) ELSE CONVERT(DATE,trh.Dt_Crtd_On) END)<=(CASE WHEN CONVERT(DATE,trh.Dt_Upd_On) IS NULL 
		--THEN CONVERT(DATE,trh.Dt_Crtd_On) ELSE CONVERT(DATE,trh.Dt_Upd_On) END)))

		AND (((trh.I_Status=1 AND (CONVERT(DATE,ticd1.Dt_Installment_Date)>=(CASE WHEN CONVERT(DATE,tip1.Dt_Upd_On) IS NULL 
		THEN CONVERT(DATE,tip1.Dt_Crtd_On) ELSE CONVERT(DATE,tip1.Dt_Upd_On) END)))
		OR (
		(tip1.I_Status=0 AND (CONVERT(DATE,ticd1.Dt_Installment_Date)<=CONVERT(DATE,tip1.Dt_Crtd_On)))
		OR
		(tip1.I_Status=0 AND (CONVERT(DATE,ticd1.Dt_Installment_Date)<=(CASE WHEN CONVERT(DATE,tip1.Dt_Upd_On) IS NULL THEN CONVERT(DATE,tip1.Dt_Crtd_On) ELSE CONVERT(DATE,tip1.Dt_Upd_On) END)))
		)
		)
		
		OR (trh.I_Status=0 AND (CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)>=CONVERT(DATE,trh.Dt_Crtd_On)
		THEN CONVERT(DATE,ticd1.Dt_Installment_Date) ELSE CONVERT(DATE,trh.Dt_Crtd_On) END)<=(CASE WHEN CONVERT(DATE,trh.Dt_Upd_On) IS NULL 
		THEN CONVERT(DATE,trh.Dt_Crtd_On) ELSE CONVERT(DATE,trh.Dt_Upd_On) END)))


		--AND (DATEDIFF(dd,CASE WHEN ticd1.Dt_Installment_Date>=CONVERT(DATE,trh.Dt_Crtd_On)THEN ticd1.Dt_Installment_Date
		--			 ELSE CONVERT(DATE,trh.Dt_Crtd_On) 
		--		END,@dtExecutionDate) = 0) 

		--  07/03/2018 --
		--AND ((
		--    (trh.I_Status=1 AND (DATEDIFF(dd,CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)>=CONVERT(DATE,trh.Dt_Receipt_Date)THEN CONVERT(DATE,ticd1.Dt_Installment_Date)
		--			 ELSE CONVERT(DATE,trh.Dt_Receipt_Date) 
		--		END,@dtExecutionDate) > 0)) 
		--	 OR (trh.I_Status=0 AND (DATEDIFF(dd,CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)>=CONVERT(DATE,trh.Dt_Receipt_Date)THEN CONVERT(DATE,trh.Dt_Receipt_Date)
		--			 ELSE CONVERT(DATE,trh.Dt_Receipt_Date) 
		--		END,@dtExecutionDate) = 0))
		--	 OR (trh.I_Status=0 AND (DATEDIFF(dd,CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)<=CONVERT(DATE,trh.Dt_Receipt_Date)THEN CONVERT(DATE,trh.Dt_Receipt_Date)
		--			 ELSE CONVERT(DATE,trh.Dt_Receipt_Date) 
		--		END,@dtExecutionDate) > 0)) 
		--	 OR (trh.I_Status=1 AND (DATEDIFF(dd,CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)<=CONVERT(DATE,trh.Dt_Receipt_Date)THEN CONVERT(DATE,trh.Dt_Receipt_Date)
		--			 ELSE CONVERT(DATE,trh.Dt_Receipt_Date) 
		--		END,@dtExecutionDate) > 0))
		--		)
		--AND 
		--	((DATEDIFF(dd,CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)>=CONVERT(DATE,trh.Dt_Crtd_On)THEN CONVERT(DATE,ticd1.Dt_Installment_Date)
		--			 ELSE CONVERT(DATE,trh.Dt_Crtd_On) 
		--		END,@dtExecutionDate) = 0) 
		--	)
		--) 
		AND (
			(
		     (trh.I_Status=1 AND (DATEDIFF(dd,CONVERT(DATE,trh.Dt_Receipt_Date),@dtExecutionDate) > 0))
			 OR (trh.I_Status=0 AND ((DATEDIFF(dd,CONVERT(DATE,trh.Dt_Receipt_Date),@dtExecutionDate)) = 0))

			)
		OR 
			((CONVERT(DATE,ticd1.Dt_Installment_Date)<(CASE WHEN CONVERT(DATE,trh.Dt_Upd_On) IS NULL THEN CONVERT(DATE,trh.Dt_Crtd_On) ELSE CONVERT(DATE,trh.Dt_Upd_On) END)) AND
			((DATEDIFF(dd,CASE WHEN CONVERT(DATE,ticd1.Dt_Installment_Date)>=CONVERT(DATE,trh.Dt_Crtd_On)THEN CONVERT(DATE,ticd1.Dt_Installment_Date)
					 ELSE CONVERT(DATE,trh.Dt_Crtd_On) 
				END,@dtExecutionDate) = 0) 
			))
		) 
		-- 07/03/2017


		GROUP BY ticd1.I_Invoice_Detail_ID,ticd1.Dt_Installment_Date,trcd.N_Amount_Paid,trh.I_Receipt_Header_ID
		) As RAmt 
		--Where RAmt.I_Invoice_Detail_ID =1314510--'1415586'
		Group By RAmt.I_Invoice_Detail_ID--,RAmt.RcptSameDate
		) A 
		
		ON ticd.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID --AND tidt.I_Tax_ID = A.I_Tax_ID
		
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID
		AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID AND tidt.I_Tax_ID = tttm.I_Tax_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 1
	WHERE
	DATEDIFF(dd,CASE WHEN ticd.Dt_Installment_Date>=CONVERT(DATE,tip.Dt_Crtd_On)THEN ticd.Dt_Installment_Date
					 ELSE CONVERT(DATE,tip.Dt_Crtd_On) 
				END,@dtExecutionDate) = 0 
	AND tip.I_Status IN (1,3,0,2)
	AND isnull(ticd.Flag_IsAdvanceTax,'N')<>'Y'
	AND tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,tsd.S_Student_ID,
			tcm.S_Cost_Center, ABS(isnull(A.N_Tax_Value,0)), @dtExecutionDate, ticd.S_Invoice_Number,tttm.S_Transaction_Code
	FROM(
	SELECT taicd.I_Advance_Ref_Invoice_Child_Detail_ID, SUM(ISNULL(taidt.N_Tax_Value,0)) N_Tax_Value, taidt.I_Tax_ID
	FROM T_Invoice_Child_Detail icd
	INNER JOIN T_Advance_Invoice_Child_Detail_Mapping taicd on icd.I_Invoice_Detail_ID = taicd.I_Advance_Ref_Invoice_Child_Detail_ID
	INNER JOIN T_Advance_Invoice_Detail_Tax_Mapping taidt on taicd.I_Advance_Invoice_Child_Detail_Map_ID = taidt.I_Advance_Invoice_Detail_Map_ID
	WHERE ISNULL(icd.Flag_IsAdvanceTax,'N') = 'Y' 
	AND DATEDIFF(dd,CONVERT(DATE,icd.Dt_Installment_Date),@dtExecutionDate) = 0
	GROUP BY taicd.I_Advance_Ref_Invoice_Child_Detail_ID, taidt.I_Tax_ID) A
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON A.I_Advance_Ref_Invoice_Child_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON ticd.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID
	INNER JOIN dbo.T_Invoice_Parent AS tip ON tich.I_Invoice_Header_ID = tip.I_Invoice_Header_ID	
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON tttm.I_Brand_ID = tbcd.I_Brand_ID
		AND ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID AND A.I_Tax_ID = tttm.I_Tax_ID 
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 1
		inner join T_Student_Detail tsd on tsd.I_Student_Detail_ID=tip.I_Student_Detail_ID	
		WHERE
		tbcd.I_Brand_ID=@iBrandID

	UNION ALL

	SELECT	tbcd.I_Brand_ID, tttm.I_Transaction_Type_ID, tip.I_Student_Detail_ID,tsd.S_Student_ID,
			tcm.S_Cost_Center, ABS(ISNULL(tcnidt.N_Tax_Value,0)), @dtExecutionDate, ticd.S_Invoice_Number,tttm.S_Transaction_Code
	FROM dbo.T_Invoice_Parent AS tip
	INNER JOIN dbo.T_Centre_Master AS tcm ON tip.I_Centre_Id = tcm.I_Centre_Id AND tcm.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id AND tbcd.I_Status = 1
	INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
	INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS tcnidt ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
	INNER JOIN ERP.T_Transaction_Type_Master AS tttm ON ticd.I_Fee_Component_ID = tttm.I_Fee_Component_ID
		AND tttm.I_Payment_Mode_ID IS NULL AND tttm.I_Brand_ID = tbcd.I_Brand_ID 
		AND tcnidt.I_Tax_ID = tttm.I_Tax_ID AND tttm.I_Status_ID IS NULL AND tttm.I_Status = 1
		AND tttm.I_Transaction_Nature_ID = 1
		inner join T_Student_Detail tsd on tsd.I_Student_Detail_ID=tip.I_Student_Detail_ID	
	WHERE DATEDIFF(dd,tcnicd.Dt_Crtd_On,@dtExecutionDate) = 0
	AND isnull(ticd.Flag_IsAdvanceTax,'N')='Y'
	AND tbcd.I_Brand_ID=@iBrandID
	

		SET @dtExecutionDate = DATEADD(dd,1,@dtExecutionDate)
	
	end
	

	select * from #temp
	
	drop table #temp
END
