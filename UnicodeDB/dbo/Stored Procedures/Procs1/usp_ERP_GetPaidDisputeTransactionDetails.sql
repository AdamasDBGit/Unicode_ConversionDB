

-- =============================================
-- Author:		<susmita Paul>
-- Create date: <2024-June-28>
-- Description:	<Get Transaction details>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetPaidDisputeTransactionDetails] 
	-- Add the parameters for the stored procedure here
	@TransactionNo NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Create table #Transaction_History
	(
	TransactionNo varchar(max),
	OrderID varchar(max),
	MobileNo varchar(max),
	PaymentJson varchar(max),
	PaymentStatusID int,
	TransactionDate datetime,
	TransactionHistoryID INT,
	PaymentBrandGateWayID INT,
	IsCompleted bit,
	CanBeProcessed bit,
	CompletedOn datetime,
	UpdateOn datetime
	)

			DECLARE @PaymentStatusTable TABLE 
(
	PaymentStatusID INT,
    StatusDescription VARCHAR(255),
    StatusColour VARCHAR(255)
);

-- Step 2: Insert the function result into the table variable
INSERT INTO @PaymentStatusTable
SELECT * 
FROM dbo.usp_ERP_GetTransactionStatus(NULL, NULL)
;


insert into #Transaction_History
	select 
	TM.I_ERP_TransactionNo as TransactionNo,
	TM.Order_ID,
	TM.S_Mobile_No as MobileNo,
	TM.PaymentJson as PaymentJson,
	CASE	
        WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2
        WHEN TM.S_TransactionStatus = 'Initiated' THEN 1
		WHEN TM.S_TransactionStatus = 'Success' THEN 3
        WHEN TM.S_TransactionStatus = 'Failure' THEN 4 
        ELSE NULL
    END AS ExternalPaymentStatus,
	TM.Dt_TransactionDate,
	TM.PG_History_ID,
	TM.I_ERP_Brand_PaymentGateway_Map_id,
	ISNULL(TM.IsCompleted,'false'),
	ISNULL(TM.CanBeProcessed,'false'),
	TM.Dt_CompletedOn,
	TM.Dt_UpdatedOn
	from T_ERP_Transaction_Master as TM
	where TM.I_ERP_TransactionNo=@TransactionNo
	
	DECLARE @InvalidInvoicecount INT=0
	DECLARE @ReceiptNo INT=0
	DECLARE @PendingPaymentCount INT=0

	
     select DISTINCT
           @InvalidInvoicecount= count(*) 
        from 
            T_ERP_Transaction_Master as TM 
        inner join
            T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID
        inner join
        (
            select DISTINCT 
                ICH.I_Invoice_Header_ID,
                ICD.S_Invoice_Number,
                ICD.is_Freezed,
                ICD.Dt_Installment_Date,
                ICD.I_Invoice_Detail_ID
            from 
                T_Invoice_Child_Header as ICH
            inner join
                T_Invoice_Child_Detail as ICD on ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID 
            where
                ICD.is_Freezed = 'true'
        ) as Invoice on TID.S_Installment_invoice_NO = Invoice.S_Invoice_Number 
            and CONVERT(DATE, TID.Dt_Installment_Date) = CONVERT(DATE, Invoice.Dt_Installment_Date)
			where TM.I_ERP_TransactionNo=@TransactionNo
      

	  -- select 
   --        @ExistingReceiptCount= count(*) 
   --     from 
   --         T_ERP_Transaction_Master as TM 
   --     inner join
   --         T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID
   --     inner join
   --     (
   --         select DISTINCT 
   --             ICH.I_Invoice_Header_ID,
   --             ICD.S_Invoice_Number,
   --             ICD.is_Freezed,
   --             ICD.Dt_Installment_Date,
   --             ICD.I_Invoice_Detail_ID
   --         from 
   --             T_Invoice_Child_Header as ICH
   --         inner join
   --             T_Invoice_Child_Detail as ICD on ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID     
   --     ) as Invoice on TID.S_Installment_invoice_NO = Invoice.S_Invoice_Number 
   --         and CONVERT(DATE, TID.Dt_Installment_Date) = CONVERT(DATE, Invoice.Dt_Installment_Date)
			--and Invoice.I_Invoice_Header_ID=TID.I_Invoice_Header_ID
	     
	  --inner join
	  --T_Receipt_Component_Detail as RCD on RCD.I_Invoice_Detail_ID=Invoice.I_Invoice_Detail_ID	 
	  --where TM.I_ERP_TransactionNo=@TransactionNo


	  print @InvalidInvoicecount

	  IF @InvalidInvoicecount > 0
	  begin
	   select distinct
           t1.*,TID.S_Installment_invoice_NO,TID.I_Invoice_Header_ID,RaisedReceipt.I_Receipt_Header_ID,RaisedReceipt.S_Receipt_No
        ,EBPM.I_ERP_Brand_PaymentGateway_Map_id as PaymentGatewayBrandID,
ETPI.S_PaymentGateway_Name as PaymentGatewayName,
EBPM.I_Brand_ID BrandId,
EBPM.S_TransactionUrl TransactionUrl
,EBPM.S_MerchantId MerchantId
,CASE WHEN ISNULL(EBPM.I_IsLive,'false') ='true' THEN EBPM.S_Live_salt
WHEN ISNULL(EBPM.I_IsLive,'false') ='false' THEN EBPM.S_Test_Salt
ELSE 'NA' END Salt,
CASE WHEN ISNULL(EBPM.I_IsLive,'false') ='true' THEN EBPM.S_Live_keySecret
WHEN ISNULL(EBPM.I_IsLive,'false') ='false' THEN EBPM.S_Test_KeySecret
ELSE 'NA' END keySecret,
EBPM.I_Payment_Mode as SMSPaymentMode
,ISNULL(EBPM.I_IsLive,'false') IsLive
,BM.S_Client_Name as ClientName,
SD.S_Student_ID StudentID,
SD.I_Enquiry_Regn_ID as EnquiryRegnID
		
		
		from 
		#Transaction_History as t1
		inner join
            T_ERP_Transaction_Master as TM on t1.TransactionNo=TM.I_ERP_TransactionNo
        inner join
            T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID
        inner join
        (
            select DISTINCT 
                ICH.I_Invoice_Header_ID,
                ICD.S_Invoice_Number,
                ICD.is_Freezed,
                ICD.Dt_Installment_Date,
                ICD.I_Invoice_Detail_ID,
				sum(ICD.N_Amount_Due) as TotalDue
            from 
                T_Invoice_Child_Header as ICH
            inner join
                T_Invoice_Child_Detail as ICD on ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID 
				group by 
				ICH.I_Invoice_Header_ID,
                ICD.S_Invoice_Number,
                ICD.is_Freezed,
                ICD.Dt_Installment_Date,
                ICD.I_Invoice_Detail_ID
        ) as Invoice on TID.S_Installment_invoice_NO = Invoice.S_Invoice_Number 
            and CONVERT(DATE, TID.Dt_Installment_Date) = CONVERT(DATE, Invoice.Dt_Installment_Date)
			and Invoice.I_Invoice_Header_ID=TID.I_Invoice_Header_ID
	     
	  inner JOIN
(
	select TM.I_ERP_TransactionNo,RH.I_Receipt_Header_ID,RH.S_Receipt_No,RH.S_Crtd_By,Receipts.Paidamount,TID.TotalAmoutPaid
	,CASE WHEN Receipts.Paidamount = TID.TotalAmoutPaid THEN 1 ELSE 0 end IsvalidReceipt,existingReceiptstransaction.I_ERP_TransactionNo as ExistingReceiptsTransactionNo
	from T_ERP_Transaction_Master as TM
	inner join
	T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID
	inner join
	T_Invoice_Child_Detail as TCD on TID.S_Installment_invoice_NO=TCD.S_Invoice_Number and TCD.is_Freezed='true'
	inner join
	(
		select 
		ICD.S_Invoice_Number,RH.I_Receipt_Header_ID,RH.S_Receipt_No,sum(RCD.N_Amount_Paid) Paidamount
		from T_Receipt_Header as RH 
		inner join
		T_Receipt_Component_Detail as RCD on RH.I_Receipt_Header_ID=RCD.I_Receipt_Detail_ID and RH.I_PaymentMode_ID=32 and RH.S_Crtd_By='rice-group-admin'
		inner join
		T_Invoice_Child_Detail as ICD on RCD.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
		group by ICD.S_Invoice_Number,RH.I_Receipt_Header_ID,RH.S_Receipt_No
		)
	Receipts on TID.S_Installment_invoice_NO=Receipts.S_Invoice_Number
	inner join
	T_Receipt_Header as RH on RH.I_Receipt_Header_ID=Receipts.I_Receipt_Header_ID
	left join
	(
	select TM.I_ERP_TransactionNo,TID.ReceiptHeaderID from 
	T_ERP_Transaction_Master as TM
	inner join
	T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID
	where TID.ReceiptHeaderID IS NOT NULL
	) as existingReceiptstransaction on RH.I_Receipt_Header_ID=existingReceiptstransaction.ReceiptHeaderID
	where TID.ReceiptHeaderID IS NULL 
 ) as RaisedReceipt on TM.I_ERP_TransactionNo=RaisedReceipt.I_ERP_TransactionNo and RaisedReceipt.IsvalidReceipt =1
 inner join 
T_ERP_PaymentGateway_Info as ETPI on ETPI.I_PaymentGateway_Id=t1.PaymentBrandGateWayID
inner join
T_ERP_Brand_PaymentGateway_Map as EBPM on ETPI.I_PaymentGateway_Id=EBPM.I_PaymentGateway_Id
inner join
T_Brand_Master as BM on BM.I_Brand_ID=EBPM.I_Brand_ID 
inner join
T_Student_Detail as SD on SD.I_Student_Detail_ID=TM.I_StudentDetailID
where ETPI.I_Status = 1 and EBPM.Is_Active=1 and ETPI.I_Status=1 and BM.I_Status=1
 
 and TM.S_TransactionStatus='Initiated'
	  end
	  





	  -- select 
   --        @PendingPaymentCount= count(*) 
   --     from 
   --         T_ERP_Transaction_Master as TM 
   --     inner join
   --         T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID
   --     inner join
   --     (
   --         select DISTINCT 
   --             ICH.I_Invoice_Header_ID,
   --             ICD.S_Invoice_Number,
   --             ICD.is_Freezed,
   --             ICD.Dt_Installment_Date,
   --             ICD.I_Invoice_Detail_ID,
			--	sum(ICD.N_Amount_Due) as TotalDue
   --         from 
   --             T_Invoice_Child_Header as ICH
   --         inner join
   --             T_Invoice_Child_Detail as ICD on ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID 
			--	group by 
			--	ICH.I_Invoice_Header_ID,
   --             ICD.S_Invoice_Number,
   --             ICD.is_Freezed,
   --             ICD.Dt_Installment_Date,
   --             ICD.I_Invoice_Detail_ID
   --     ) as Invoice on TID.S_Installment_invoice_NO = Invoice.S_Invoice_Number 
   --         and CONVERT(DATE, TID.Dt_Installment_Date) = CONVERT(DATE, Invoice.Dt_Installment_Date)
			--and Invoice.I_Invoice_Header_ID=TID.I_Invoice_Header_ID
	     
	  --left join
	  --(select I_Invoice_Detail_ID,ISNULL(sum(N_Amount_Paid),0) as TotalPaidAmount from
	  --T_Receipt_Component_Detail group by I_Invoice_Detail_ID)as RCD on   
	  --RCD.I_Invoice_Detail_ID=Invoice.I_Invoice_Detail_ID 
	  --where TM.I_ERP_TransactionNo=@TransactionNo and ISNULL(RCD.TotalPaidAmount,0) < Invoice.TotalDue




	
--select 
--	TH.*,
--	ExternalStatus.StatusDescription,
--	ExternalStatus.StatusColour,
--	PGHistory.*,
--	@InvalidInvoicecount as InvalidInvoicecount,
--	@ExistingReceiptCount as ExistingReceiptCount,
--	@PendingPaymentCount as PendingPaymentCount,
--	CASE WHEN @InvalidInvoicecount > 0 OR @PendingPaymentCount <= 0 OR DATEDIFF(MINUTE, TH.TransactionDate, GETDATE()) < 30
--	THEN 'false' 
--	--CASE WHEN @InvalidInvoicecount > 0 OR @ExistingReceiptCount > 0 THEN 'false' 
--	ELSE
--	'true' END ISAllowed,
--	CASE 
--    WHEN @PendingPaymentCount <= 0 THEN 'Unallowed to adjust: It seems the requested invoice has already been adjusted.'
--    WHEN @InvalidInvoiceCount > 0 THEN 'Unallowed to adjust: It seems the requested invoice is invalid.'
--    WHEN DATEDIFF(MINUTE, TH.TransactionDate, GETDATE()) < 30 THEN 'Kindly wait a moment while the payment gateway completes the process. Manual adjustments will be available shortly.'
--    ELSE 'UnAllowed To Adjust: Something is Wrong!'
--	END AS Errormessage
--	from 
--	#Transaction_History as TH
--	LEFT join
--	@PaymentStatusTable as ExternalStatus on TH.PaymentStatusID=ExternalStatus.PaymentStatusID
--	left join
--	T_ERP_PG_History as PGHistory on PGHistory.PG_History_ID=TH.TransactionHistoryID



	
   


END

