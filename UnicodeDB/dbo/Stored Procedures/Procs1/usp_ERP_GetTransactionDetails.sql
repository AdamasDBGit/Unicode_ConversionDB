  
-- =============================================  
-- Author:  <susmita Paul>  
-- Create date: <2024-June-28>  
-- Description: <Get Transaction details>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetTransactionDetails]   
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
 MobileNo varchar(max),  
 PaymentJson varchar(max),  
 PaymentStatusID int,  
 TransactionDate datetime,  
 TransactionHistoryID INT,  
 PaymentBrandGateWayID INT,  
 IsCompleted bit,  
 CanBeProcessed bit,  
 CompletedOn datetime,  
 UpdateOn datetime,  
 TenentId VARCHAR(MAX)  --Add by Amit Ranjan Basu add TenentId  
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
 TM.Dt_UpdatedOn,  
 bm.tenant_ID  
 from T_ERP_Transaction_Master as TM  
 Left JOIN [T_Brand_Master] bm --Addig By AmitRanjanBasu for get TenentId  
 ON TM.[I_BrandID]=bm.[I_Brand_ID]  
 where TM.I_ERP_TransactionNo=@TransactionNo  
   
 DECLARE @InvalidInvoicecount INT=0  
 DECLARE @ExistingReceiptCount INT=0  
 DECLARE @PendingPaymentCount INT=0  
 DECLARE @TenentID VARCHAR(MAX)  
 DECLARE @Noinvoice int=0

 select distinct @Noinvoice=
 count(*)
 from T_ERP_Transaction_Master TM
 inner join 
 T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID
 where I_ERP_TransactionNo=@TransactionNo and ISNULL(I_Invoice_Header_ID,0) > 0
  
  print @Noinvoice

  if @Noinvoice > 0
  begin
   
     select   
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
                ICD.is_Freezed = 'false'  
        ) as Invoice on TID.S_Installment_invoice_NO = Invoice.S_Invoice_Number   
            and CONVERT(DATE, TID.Dt_Installment_Date) = CONVERT(DATE, Invoice.Dt_Installment_Date)  
   where TM.I_ERP_TransactionNo=@TransactionNo  
   end 
   else
   begin

    select   
           @InvalidInvoicecount= count(*)   
        from   
            T_ERP_Transaction_Master as TM   
        inner join  
            T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID  
        inner join  
        (  
		select 
		inAdhocPaymentScheduleStudentDetailID 
		from 
		T_ERP_AdhocPaymentScheduleStudentDetail as ASSD
		where ASSD.IsFreeze='false' 
        ) as Invoice on TID.PaymentScheduleID = Invoice.inAdhocPaymentScheduleStudentDetailID    
   where TM.I_ERP_TransactionNo=@TransactionNo  


   end 
  
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
  
  if @Noinvoice > 0
  begin 
    select   
           @ExistingReceiptCount= count(*)   
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
        
   left join  
   (select I_Invoice_Detail_ID,sum(N_Amount_Paid) as TotalPaidAmount from  
   T_Receipt_Component_Detail group by I_Invoice_Detail_ID)as RCD on     
   RCD.I_Invoice_Detail_ID=Invoice.I_Invoice_Detail_ID   
   where TM.I_ERP_TransactionNo=@TransactionNo and ISNULL(RCD.TotalPaidAmount,0) >= Invoice.TotalDue  
  
  end 
  else
  begin

	 select   
           @ExistingReceiptCount= count(*)   
        from   
            T_ERP_Transaction_Master as TM   
        inner join  
            T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID  
       where TM.I_ERP_TransactionNo=@TransactionNo and TID.ReceiptHeaderID IS NOT NULL 

  end 

  if @Noinvoice > 0
	  begin
		select   
			   @PendingPaymentCount= count(*)   
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
        
	   left join  
	   (select I_Invoice_Detail_ID,ISNULL(sum(N_Amount_Paid),0) as TotalPaidAmount from  
	   T_Receipt_Component_Detail group by I_Invoice_Detail_ID)as RCD on     
	   RCD.I_Invoice_Detail_ID=Invoice.I_Invoice_Detail_ID   
	   where TM.I_ERP_TransactionNo=@TransactionNo and ISNULL(RCD.TotalPaidAmount,0) < Invoice.TotalDue  
  
	  end 
  else
	  begin

		 select   
			   @PendingPaymentCount= count(*)   
			from   
				T_ERP_Transaction_Master as TM   
			inner join  
				T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID  			  
			where TM.I_ERP_TransactionNo=@TransactionNo and TID.ReceiptHeaderID IS NULL  

	  end
  
  
   
select   
 TH.*,  
 ExternalStatus.StatusDescription,  
 ExternalStatus.StatusColour,  
 PGHistory.*,  
 @InvalidInvoicecount as InvalidInvoicecount,  
 @ExistingReceiptCount as ExistingReceiptCount,  
 @PendingPaymentCount as PendingPaymentCount,  
 CASE WHEN @InvalidInvoicecount > 0 OR @PendingPaymentCount <= 0 OR DATEDIFF(MINUTE, TH.TransactionDate, GETDATE()) < 0  
 THEN 'false'   
 --CASE WHEN @InvalidInvoicecount > 0 OR @ExistingReceiptCount > 0 THEN 'false'   
 ELSE   'true' END ISAllowed,  
 CASE   
    WHEN @PendingPaymentCount <= 0 THEN 'Unallowed to adjust: It seems the requested invoice has already been adjusted.'  
    WHEN @InvalidInvoiceCount > 0 THEN 'Unallowed to adjust: It seems the requested invoice is invalid.'  
    WHEN DATEDIFF(MINUTE, TH.TransactionDate, GETDATE()) < 0 THEN 'Kindly wait a moment while the payment gateway completes the process. Manual adjustments will be available shortly.'    
 END AS Errormessage  
 from   
 #Transaction_History as TH  
 LEFT join  
 @PaymentStatusTable as ExternalStatus on TH.PaymentStatusID=ExternalStatus.PaymentStatusID  
 left join  
 T_ERP_PG_History as PGHistory on PGHistory.PG_History_ID=TH.TransactionHistoryID  
  
  
  
   
     
  
  
END  
