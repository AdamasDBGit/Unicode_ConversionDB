CREATE PROCEDURE [ECOMMERCE].[uspGetPrintFeeScheduleDetails](@FeeScheduleID INT)
AS
BEGIN

	DECLARE @StudentDetailID INT
	DECLARE @CenterID INT
	DECLARE @BatchID INT
	DECLARE @InvoiceNo VARCHAR(MAX)
	DECLARE @FeeScheduleDate DATETIME

	CREATE TABLE #InvSummary
	(
		S_Course_Name VARCHAR(MAX),
		S_SAC_Code VARCHAR(MAX),
		Course_Amt DECIMAL(14,2),
		Discount DECIMAL(14,2),
		OLD_TAX DECIMAL(14,2),
		S_SGST_Tax DECIMAL(14,2),
		S_CGST_Tax DECIMAL(14,2),
		S_IGST_Tax DECIMAL(14,2),
		TaxAmt DECIMAL(14,2),
		Total DECIMAL(14,2)
	)

	CREATE TABLE #InvDetails
	(
		I_Invoice_Header_ID INT, 
		I_Installment_No INT,   
		Dt_Installment_Date DATETIME,  
		N_Amount_Due DECIMAL(14,2),   
		N_Discount_Amount DECIMAL(14,2),   
		N_Advance_Amount DECIMAL(14,2),  
		N_Net_Amount DECIMAL(14,2),  
		S_Invoice_Number VARCHAR(MAX),  
		Invoice_Type VARCHAR(10),
		CGST DECIMAL(14,2),
		SGST DECIMAL(14,2),
		IGST DECIMAL(14,2)
	)


	select TOP 1 @StudentDetailID=A.I_Student_Detail_ID,@CenterID=A.I_Centre_Id,@BatchID=C.I_Batch_ID,@InvoiceNo=A.S_Invoice_No,@FeeScheduleDate=A.Dt_Invoice_Date
	from T_Invoice_Parent A
	inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
	inner join T_Invoice_Batch_Map C on B.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID
	where
	A.I_Invoice_Header_ID=@FeeScheduleID

	insert into #InvSummary
	exec [dbo].[uspGetInvoiceSummary] @FeeScheduleID

	insert into #InvDetails
	(
		I_Invoice_Header_ID, 
		I_Installment_No,   
		Dt_Installment_Date,  
		N_Amount_Due,   
		N_Discount_Amount,   
		N_Advance_Amount,  
		N_Net_Amount,  
		S_Invoice_Number,  
		Invoice_Type
	)
	exec [dbo].[uspGetInvoiceDetailRevisedGST] @iInvoiceHeaderID=@FeeScheduleID


	update T1
	set
	T1.CGST=T2.CGST
	from
	#InvDetails T1
	inner join
	(
		select C.I_Invoice_Header_ID,B.S_Invoice_Number,A.N_Tax_Value as CGST
		from T_Invoice_Detail_Tax A
		inner join T_Invoice_Child_Detail B on A.I_Invoice_Detail_ID=B.I_Invoice_Detail_ID
		inner join T_Invoice_Child_Header C on B.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID
		inner join T_Tax_Master D on A.I_Tax_ID=D.I_Tax_ID and D.I_Status=1
		where
		B.I_Installment_No>0 and D.S_Tax_Code COLLATE DATABASE_DEFAULT='CGST' COLLATE DATABASE_DEFAULT
	) T2 on T1.I_Invoice_Header_ID=T2.I_Invoice_Header_ID and T1.S_Invoice_Number COLLATE DATABASE_DEFAULT=T2.S_Invoice_Number COLLATE DATABASE_DEFAULT


	update T1
	set
	T1.SGST=T2.SGST
	from
	#InvDetails T1
	inner join
	(
		select C.I_Invoice_Header_ID,B.S_Invoice_Number,A.N_Tax_Value as SGST
		from T_Invoice_Detail_Tax A
		inner join T_Invoice_Child_Detail B on A.I_Invoice_Detail_ID=B.I_Invoice_Detail_ID
		inner join T_Invoice_Child_Header C on B.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID
		inner join T_Tax_Master D on A.I_Tax_ID=D.I_Tax_ID and D.I_Status=1
		where
		B.I_Installment_No>0 and D.S_Tax_Code COLLATE DATABASE_DEFAULT='SGST' COLLATE DATABASE_DEFAULT
	) T2 on T1.I_Invoice_Header_ID=T2.I_Invoice_Header_ID and T1.S_Invoice_Number COLLATE DATABASE_DEFAULT=T2.S_Invoice_Number COLLATE DATABASE_DEFAULT




	--Table 0
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


	--Table 1
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


	--Table 2
	select I_Batch_ID,S_Batch_Name,@InvoiceNo as InvoiceNo, @FeeScheduleDate as FeeScheduleDate 
	from T_Student_Batch_Master where I_Batch_ID=@BatchID

	--Table 3
	select * from #InvSummary


	--Table 4
	select I_Invoice_Header_ID,I_Installment_No,Dt_Installment_Date,S_Invoice_Number,Invoice_Type,
	SUM(N_Amount_Due) as DueAmount,
	SUM(N_Discount_Amount) as DiscountAmount,
	SUM(N_Advance_Amount) as AdvanceAmount,
	SUM(N_Net_Amount) as NetAmount,
	SUM(CGST) as CGST,
	SUM(SGST) as SGST
	from #InvDetails
	group by I_Invoice_Header_ID,I_Installment_No,Dt_Installment_Date,S_Invoice_Number,Invoice_Type

	--Table 5
	select C.PlanName,D.ProductName 
	from ECOMMERCE.T_Transaction_Product_Details A
	inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionPlanDetailID=B.TransactionPlanDetailID
	inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
	inner join ECOMMERCE.T_Product_Master D on D.ProductID=A.ProductID
	where
	A.FeeScheduleID=@FeeScheduleID


END
