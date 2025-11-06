CREATE PROCEDURE [ECOMMERCE].[uspGetPrintTaxInvoiceDetails](@InvoiceNo VARCHAR(MAX), @ReceiptID INT)
AS
BEGIN

	DECLARE @StudentDetailID INT
	DECLARE @CenterID INT
	DECLARE @BatchID INT
	DECLARE @FeeScheduleID INT
	DECLARE @FeeScheduleDate DATETIME

	--CREATE TABLE #InvSummary
	--(
	--	S_Course_Name VARCHAR(MAX),
	--	S_SAC_Code VARCHAR(MAX),
	--	Course_Amt DECIMAL(14,2),
	--	Discount DECIMAL(14,2),
	--	OLD_TAX DECIMAL(14,2),
	--	S_SGST_Tax DECIMAL(14,2),
	--	S_CGST_Tax DECIMAL(14,2),
	--	S_IGST_Tax DECIMAL(14,2),
	--	TaxAmt DECIMAL(14,2),
	--	Total DECIMAL(14,2)
	--)

	CREATE TABLE #InvDetails
	(
		I_Installment_No INT,   
		Dt_Installment_Date DATETIME,  
		N_Amount_Due DECIMAL(14,2),   
		N_Discount_Amount DECIMAL(14,2),   
		N_Advance_Amount DECIMAL(14,2), 
		N_SGST_Amount DECIMAL(14,2),
		N_CGST_Amount DECIMAL(14,2),
		N_IGST_Amount DECIMAL(14,2),
		N_Tax_Amount DECIMAL(14,2),
		N_Net_Amount DECIMAL(14,2),  
		N_Total_Amount DECIMAL(14,2)
	)


	select TOP 1 @StudentDetailID=A.I_Student_Detail_ID,@CenterID=A.I_Centre_Id,@BatchID=C.I_Batch_ID,@FeeScheduleDate=A.Dt_Invoice_Date,@FeeScheduleID=A.I_Invoice_Header_ID
	from T_Invoice_Parent A
	inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
	inner join T_Invoice_Batch_Map C on B.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID
	inner join T_Invoice_Child_Detail D on B.I_Invoice_Child_Header_ID=D.I_Invoice_Child_Header_ID
	where
	D.S_Invoice_Number=@InvoiceNo and D.I_Installment_No>0

	--insert into #InvSummary
	--exec [dbo].[uspGetInvoiceSummary] @FeeScheduleID

	insert into #InvDetails
	exec [ECOMMERCE].[uspGetIndividualIstallmentInvoice] @InvoiceNo,'I'


	SELECT CHND.S_Brand_Name,CHND.I_Center_ID,CHND.S_Center_Name,NCA.S_Center_Address1,TCM.S_City_Name,
				TSM.S_State_Name,TCM2.S_Country_Name,NCA.S_Pin_Code,NCA.S_Email_ID,NCA.S_Telephone_No,GCM.*,
				ISNULL(TBM.S_CIN,'NA') AS CIN,
				ISNULL(TBM.S_PAN,'NA') AS PAN
	FROM 
	dbo.T_GST_Code_Master AS GCM
	INNER JOIN dbo.T_State_Master AS SM ON GCM.I_State_ID = SM.I_State_ID AND GCM.I_Status = 1 AND SM.I_Status = 1
	INNER JOIN NETWORK.T_Center_Address AS NCA ON SM.I_State_ID = NCA.I_State_ID
	INNER JOIN dbo.T_Invoice_Parent AS IP ON NCA.I_Centre_Id = IP.I_Centre_Id
	INNER JOIN T_Center_Hierarchy_Name_Details CHND ON IP.I_Centre_Id = CHND.I_Center_ID AND GCM.I_Brand_ID = CHND.I_Brand_ID
	inner join T_City_Master TCM on NCA.I_City_ID=TCM.I_City_ID
	inner join T_State_Master TSM on NCA.I_State_ID=TSM.I_State_ID
	inner join T_Country_Master TCM2 on NCA.I_Country_ID=TCM2.I_Country_ID
	inner join T_Brand_Master TBM on CHND.I_Brand_ID=TBM.I_Brand_ID
	WHERE IP.I_Invoice_Header_ID = @FeeScheduleID

	select NCA.I_Student_Detail_ID,NCA.S_Student_ID,NCA.S_First_Name+' '+ISNULL(NCA.S_Middle_Name,'')+' '+NCA.S_Last_Name as StudentName,NCA.S_Curr_Address1,
			TCM.S_City_Name,TSM.S_State_Name,TCM2.S_Country_Name,NCA.S_Curr_Pincode,TR.CustomerID,NCA.S_Email_ID,NCA.S_Mobile_No
	from T_Student_Detail NCA
	inner join T_City_Master TCM on NCA.I_Curr_City_ID=TCM.I_City_ID
	inner join T_State_Master TSM on NCA.I_Curr_State_ID=TSM.I_State_ID
	inner join T_Country_Master TCM2 on ISNULL(NCA.I_Curr_Country_ID,1)=TCM2.I_Country_ID
	inner join ECOMMERCE.T_Registration_Enquiry_Map TREM on NCA.I_Enquiry_Regn_ID=TREM.EnquiryID
	inner join ECOMMERCE.T_Registration TR on TREM.RegID=TR.RegID
	where
	NCA.I_Student_Detail_ID=@StudentDetailID


	select I_Batch_ID,S_Batch_Name,@InvoiceNo as InvoiceNo, @FeeScheduleDate as FeeScheduleDate 
	from T_Student_Batch_Master where I_Batch_ID=@BatchID

	--select * from #InvSummary
	select A.*,@InvoiceNo as InvoiceNo,'I' as InvoiceType,@FeeScheduleID as FeeScheduleID from #InvDetails A

	--select I_Invoice_Header_ID,I_Installment_No,Dt_Installment_Date,S_Invoice_Number,Invoice_Type,
	--SUM(N_Amount_Due) as DueAmount,
	--SUM(N_Discount_Amount) as DiscountAmount,
	--SUM(N_Advance_Amount) as AdvanceAmount,
	--SUM(N_Net_Amount) as NetAmount
	--from #InvDetails
	--group by I_Invoice_Header_ID,I_Installment_No,Dt_Installment_Date,S_Invoice_Number,Invoice_Type

	select C.PlanName,D.ProductName,CASE WHEN A.PaymentModeID=1 THEN 'Lumpsum' ELSE 'Instalment' END as PaymentMode
	from ECOMMERCE.T_Transaction_Product_Details A
	inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionPlanDetailID=B.TransactionPlanDetailID
	inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
	inner join ECOMMERCE.T_Product_Master D on D.ProductID=A.ProductID
	inner join ECOMMERCE.T_Transaction_Product_Subscription_Details E on A.TransactionProductDetailID=E.TransactionProductDetailID
	inner join ECOMMERCE.T_Subscription_Transaction F on E.SubscriptionDetailID=F.SubscriptionDetailID
	where
	F.ReceiptHeaderID=@ReceiptID

	UNION ALL

	select C.PlanName,D.ProductName,CASE WHEN A.PaymentModeID=1 THEN 'Lumpsum' ELSE 'Instalment' END as PaymentMode 
	from ECOMMERCE.T_Transaction_Product_Details A
	inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionPlanDetailID=B.TransactionPlanDetailID
	inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
	inner join ECOMMERCE.T_Product_Master D on D.ProductID=A.ProductID
	where
	A.ReceiptHeaderID=@ReceiptID

	UNION ALL

	select ISNULL(D.PlanName,'') as PlanName,ISNULL(E.ProductName,'') as ProductName,
	CASE WHEN ISNULL(B.PaymentModeID,0)=1 THEN 'Lumpsum' 
	WHEN ISNULL(B.PaymentModeID,0)=2 THEN 'Instalment'
	ELSE ''
	END as PaymentMode 
	from 
	ECOMMERCE.T_Payout_Transaction A
	left join ECOMMERCE.T_Transaction_Product_Details B on A.FeeScheduleID=B.FeeScheduleID and B.IsCompleted=1
	left join ECOMMERCE.T_Transaction_Plan_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID and C.IsCompleted=1
	left join ECOMMERCE.T_Plan_Master D on C.PlanID=D.PlanID
	left join ECOMMERCE.T_Product_Master E on B.ProductID=E.ProductID
	where
	A.ReceiptHeaderID=@ReceiptID
	--ECOMMERCE.T_Transaction_Product_Details A
	--inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionPlanDetailID=B.TransactionPlanDetailID
	--inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
	--inner join ECOMMERCE.T_Product_Master D on D.ProductID=A.ProductID
	--where
	--A.ReceiptHeaderID=@ReceiptID


END
