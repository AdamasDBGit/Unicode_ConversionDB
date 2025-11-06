

CREATE   PROCEDURE [dbo].[usp_ERP_GetInvoiceDetail_BKP_May_2025]  --[dbo].[uspGetInvoiceDetail] 168173       
    (
      @iInvoiceHeaderID INT            
    )
AS
    BEGIN            
        SET NOCOUNT ON;            
        DECLARE @iInvoiceDetailId INT            
        DECLARE @TempTable TABLE
            (
              I_Tax_ID INT ,
              I_Invoice_Detail_ID INT ,
              N_Tax_Value NUMERIC(18, 6) ,
              TAX_CODE VARCHAR(20) ,
              TAX_DESC VARCHAR(50) ,
              TAX_CHECK INT
            )            
 -- TABLE[0] RETURNS ALL THE INFORMATION FROM T_INVOICE_PARENT             
        SELECT  DISTINCT TIP.I_Invoice_Header_ID as InvoiceHeaderID,
		TIP.I_Student_Detail_ID as StudentDetailID,
				TIP.S_Invoice_No as InvoiceNo,
				TIP.N_Invoice_Amount as ActualInvoiceAmount,
				TIP.N_ERP_Discount_Amount as TotalDiscountAmount,
                TIP2.S_Invoice_No AS ParentInvoiceNo,
				TIP.I_Status as Status,
				CASE WHEN ICH.C_Is_LumpSum <> 'N' THEN 1 ELSE 0 END as IsLumpsum,
				ISNULL(TIP.S_Narration,ISNULL(partialremarks.Merged_Remarks,'')) as Remarks
        FROM    T_Invoice_Parent TIP WITH ( NOLOCK )
				inner join
				T_Invoice_Child_Header ICH WITH ( NOLOCK ) on TIP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
                LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH ON TIP.I_Parent_Invoice_ID = TSIH.I_Invoice_Header_ID
                LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH1 ON TIP.I_Invoice_Header_ID = TSIH1.I_Invoice_Header_ID
                LEFT OUTER JOIN dbo.T_Invoice_Parent AS TIP2 ON TSIH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID
				 LEFT JOIN (
       SELECT distinct
    Invoice_Header_ID,
    CAST(CreatedOn AS DATE) AS CreatedOn,  -- Convert only once for efficiency
    ISNULL(STUFF(( 
        SELECT DISTINCT ' | ' + ISNULL(Remarks, '') 
        FROM Nullify_Installments_Details AS sub 
        WHERE sub.Invoice_Header_ID = main.Invoice_Header_ID 
          AND CAST(sub.CreatedOn AS DATE) = CAST(main.CreatedOn AS DATE)  -- Optimized conversion
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, ''), 'No Remarks') AS Merged_Remarks
FROM Nullify_Installments_Details AS main 
WHERE Isdone = 1 AND Remarks IS NOT NULL
GROUP BY Invoice_Header_ID, CAST(CreatedOn AS DATE)  -- Ensure it matches SELECT
    ) AS partialremarks  on partialremarks.Invoice_Header_ID=TIP.I_Invoice_Header_ID
				
        WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID            
            
   

   DECLARE @OracleTransactionDateMax date = null

   select @OracleTransactionDateMax=max(Transaction_Date)  from ERP.T_Student_Transaction_Details 


             
        SELECT DISTINCT
                ICD.I_Invoice_Detail_ID, 
    ICD.I_Fee_Component_ID, 
    ICD.I_Invoice_Child_Header_ID, 
    ICD.I_Installment_No, 
    ICD.Dt_Installment_Date, 
    ICD.N_Amount_Due, 
    ICD.I_Display_Fee_Component_ID, 
    ICD.I_Sequence, 
    ICD.N_Amount_Adv_Coln, 
    ICD.Flag_IsAdvanceTax, 
    ICD.I_Receipt_Header_ID, 
    ICD.S_Invoice_Number, 
    ICD.Tmp_AutoIdTag, 
    ICD.N_Discount_Amount, 
    ICD.N_Due, 
    ICD.I_Payment_Status, 
    ICD.N_CGST, 
    ICD.N_SGST, 
    ICD.N_IGST, 
    ICD.I_GST_FeeComponent_Catagory_ID, 
    ICD.is_Freezed, 
    ICD.ERP_Installment_Discount_Scheme_Master_ID, 
    ICD.N_ERP_Discount_Amount, 
    CASE WHEN CONVERT(DATE,ICD.Dt_Installment_Date) > CONVERT(DATE,@OracleTransactionDateMax) then 'false'
	else 'true' END as Is_Finance_Push, 
     CASE WHEN CONVERT(DATE,ICD.Dt_Installment_Date) > CONVERT(DATE,@OracleTransactionDateMax) then 'false'
	else 'true' END as Is_Finance_Reconcile, 
    ICD.N_CGST_per, 
    ICD.N_SGST_per, 
    ICD.N_IGST_per, 
    ICD.N_CGST_Tax_Value_Scheduled, 
    ICD.N_SGST_Tax_Value_Scheduled, 
    ICD.I_GST_Tax_Value_Scheduled, 
    ICD.IsDiscountRateApplied, 
    ICD.Discount_Amount_Rate,
				FCM.I_Fee_Component_ID as FeeComponentID,
				FCM.S_Component_Code as FeeComponentCode,
				FCM.S_Component_Name as FeeComponentName,
				PaymentDetails.ReceiptHeader,
				PaymentDetails.ReceiptNo,
				PaymentDetails.Amountpaid
        FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
                INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
                LEFT JOIN T_Course_Fee_Plan_Detail TCFPD WITH ( NOLOCK ) ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID
                                                              AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID
				INNER JOIN T_Fee_Component_Master as FCM on ICD.I_Fee_Component_ID=FCM.I_Fee_Component_ID
				left join
				(
				select RH.I_Receipt_Header_ID as ReceiptHeader,RH.S_Receipt_No as ReceiptNo,
				RCD.I_Invoice_Detail_ID as InvoiceDetailID,RCD.N_Amount_Paid as Amountpaid
				from T_Receipt_Header as RH 
				inner join
				T_Receipt_Component_Detail as RCD on RH.I_Receipt_Header_ID=RCD.I_Receipt_Detail_ID
				where RH.I_Status=1
				) as PaymentDetails on PaymentDetails.InvoiceDetailID=ICD.I_Invoice_Detail_ID
		WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID      
        --ADDITION STARTED ON 26/06/2017  
                AND ISNULL(ICD.Flag_IsAdvanceTax, '') <> 'Y'  
        --ADDITION ENDED ON 26/06/2017  
				
        ORDER BY  ICD.Dt_Installment_Date,ICD.I_Fee_Component_ID           
            
            
        --DECLARE TABLE_CURSOR CURSOR
        --FOR
        --    SELECT  ICD.I_Invoice_Detail_ID
        --    FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
        --    WHERE   ICD.I_Invoice_Child_Header_ID IN (
        --            SELECT  I_Invoice_Child_Header_ID
        --            FROM    T_Invoice_Child_Header ICH WITH ( NOLOCK )
        --            WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID )
        --    ORDER BY Dt_Installment_Date             
             
        --OPEN TABLE_CURSOR            
        --FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId            
             
        --WHILE @@FETCH_STATUS = 0
        --    BEGIN            
        --        INSERT  INTO @TempTable
        --                SELECT  IDT.I_Tax_ID ,
        --                        IDT.I_Invoice_Detail_ID ,   
        --                        --IDT.N_Tax_Value,     
        --                        IDT.N_Tax_Value N_Tax_Value ,
        --                        TM.S_Tax_Code AS TAX_CODE ,
        --                        TM.S_Tax_Desc AS TAX_DESC ,
        --                        CASE WHEN TM.S_Tax_Code = 'SGST' THEN 1
        --                             WHEN TM.S_Tax_Code = 'CGST' THEN 2
        --                             WHEN TM.S_Tax_Code = 'IGST' THEN 3
        --                             ELSE 0
        --                        END
        --                FROM    T_Invoice_Detail_Tax IDT ,
        --                        T_Tax_Master TM ,  
        --                        --ADDITION STARTED ON 26/06/2017  
        --                        T_Invoice_Child_Detail ICD     
        --                        --ADDITION ENDED ON 26/06/2017  
        --                WHERE   IDT.I_Invoice_Detail_ID = @iInvoiceDetailId
        --                        AND TM.I_Tax_ID = IDT.I_Tax_ID             
        --                        --ADDITION STARTED ON 26/06/2017  
        --                        AND IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
        --                        AND ISNULL(ICD.Flag_IsAdvanceTax, '') <> 'Y'  
        --                        --ADDITION ENDED ON 26/06/2017  
               
        --        FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId            
        --    END            
                
        --CLOSE TABLE_CURSOR            
        --DEALLOCATE TABLE_CURSOR            
             
 --TABLE[3] RETURNS  Invoice 
       
SELECT 
    TIP.S_Invoice_No as InvoiceNo,
	EDCR.S_Claim_Status as ClaimStatus,
	EDCR.S_Discount_Remarks as DiscountRemarks,
	EDCR.Dt_Final_Approved_Date FinalApprovedDate,
	EDCR.Dt_Rejected_Date RejectedDate,
	EDCR.Dt_Claim_Date ClaimDate,
    ISNULL(EDCR.Is_Rejected,'false') as IsRejected,
	ISNULL(EDCR.Is_Fully_Approved,'false') as IsFullyApproved,
    LastActionBy.*, 
    nextapprover.*,
	ClaimUser.I_User_ID as ClaimUserID,
	ClaimUser.S_First_Name + ' ' + ISNULL(ClaimUser.S_Middle_Name + ' ', '') + ClaimUser.S_Last_Name as ClaimUserName
FROM 
    T_Invoice_Parent AS TIP
INNER JOIN 
    T_ERP_Discount_Claim_Request AS EDCR 
    ON TIP.CurrentDiscountClaimRequestID = EDCR.I_ERP_Discount_Claim_Request_ID and EDCR.I_Invoice_Header_ID=@iInvoiceHeaderID
INNER JOIN 
	T_ERP_User as ClaimUser on EDCR.I_User_Claim_By=ClaimUser.I_User_ID
LEFT JOIN 
    (
        SELECT 
            DCAD.I_Saas_Header_ID,
            DCAD.I_ERP_Discount_Claim_Request_ID,
            DCAD.I_Discount_Claim_Approver_DetailID,
            DCAD.Remarks RemarksOfAction,
            PH.N_help ApproverLevel,
            EU.S_Username ApproverUser,
            EU.S_First_Name + ' ' + ISNULL(EU.S_Middle_Name + ' ', '') + EU.S_Last_Name AS ApproverFullName,
            EU.I_User_ID ApproverUserID,
            DCAD.I_Action_Taken_By ActionTakenUserID,
            DCAD.Dt_Action_Taken_At ActionTakenAt
        FROM 
            T_ERP_Discount_Claim_Approver_Details AS DCAD
        INNER JOIN 
            T_ERP_Saas_Pattern_Header AS PH 
            ON DCAD.I_Saas_Header_ID = PH.I_Pattern_HeaderID
        INNER JOIN 
            T_ERP_Saas_Pattern_Child_Header AS PCH 
            ON PH.I_Pattern_HeaderID = PCH.I_Pattern_HeaderID
        INNER JOIN 
            T_ERP_User AS EU 
            ON PCH.N_Value = EU.I_User_ID 
    ) AS LastActionBy 
    ON LastActionBy.I_Discount_Claim_Approver_DetailID = EDCR.I_Last_Action_Claim_Detail_ID
LEFT JOIN 
    (
        SELECT 
            TOP 1 
            DCAD.I_Saas_Header_ID WaitOn_I_Saas_Header_ID,
            DCAD.I_ERP_Discount_Claim_Request_ID WaitOn_I_ERP_Discount_Claim_Request_ID,
            DCAD.I_Discount_Claim_Approver_DetailID WaitOn_I_Discount_Claim_Approver_DetailID,
            PH.N_help WaitOnLevel,
            EU.S_Username WaitOnUserName,
            EU.S_First_Name + ' ' + ISNULL(EU.S_Middle_Name + ' ', '') + EU.S_Last_Name AS WaitOnFullName,
            EU.I_User_ID WaitOnUserID
        FROM 
            T_ERP_Discount_Claim_Approver_Details AS DCAD
        INNER JOIN 
            T_ERP_Saas_Pattern_Header AS PH 
            ON DCAD.I_Saas_Header_ID = PH.I_Pattern_HeaderID
        INNER JOIN 
            T_ERP_Saas_Pattern_Child_Header AS PCH 
            ON PH.I_Pattern_HeaderID = PCH.I_Pattern_HeaderID
        INNER JOIN 
            T_ERP_User AS EU 
            ON PCH.N_Value = EU.I_User_ID 
        WHERE 
            DCAD.Is_Approved IS NULL 
            AND DCAD.Is_Rejected IS NULL
        ORDER BY 
            DCAD.I_Approver_Seq 
    ) AS nextapprover 
    ON nextapprover.WaitOn_I_ERP_Discount_Claim_Request_ID = EDCR.I_ERP_Discount_Claim_Request_ID
	where TIP.I_Invoice_Header_ID=@iInvoiceHeaderID



	----Credit note 
	select DISTINCT creditnote.*
	,
	ICD.S_Invoice_Number as installmentinvoicenumber
	--,Partialwrite.*
	
	from



(	SELECT DISTINCT I_Invoice_Header_ID, I_Installment_No,   
     Dt_Installment_Date Dt_Installment_Date,  
     (-1)*SUM(ISNULL(N_Amount_Due,0)) N_Amount_Due,   
     0 as N_Discount_Amount,   
     CASE WHEN I_Installment_No = 0 THEN (-1)*SUM(N_Advance_Amount)   
       ELSE SUM(N_Advance_Amount)   
     END N_Advance_Amount,   
	 (-1)*ISNULL(CASE WHEN (SUM(N_Amount_Due) - SUM(N_Advance_Amount)) > 0   
    THEN (SUM(N_Amount_Due)  - SUM(N_Advance_Amount))
     ELSE 0.00  
     END,0) N_Net_Amount,  
     S_Invoice_Number as CreditNoteInvoiceNumber,
     'C' Invoice_Type,
	 (-1)*ISNULL(CreditedTotalTaxAmount,0) as CreditedTotalTaxAmount
	 
 FROM(  
    SELECT DISTINCT ICCD.I_Invoice_Header_ID, ICD.I_Installment_No, 
     --CASE WHEN 
	 CONVERT(DATE, ICD.Dt_Installment_Date) 
	 --> CONVERT(DATE, ICCD.Dt_Crtd_On) THEN ICD.Dt_Installment_Date  
  --  ELSE ICCD.Dt_Crtd_On  
  --   END AS 
	 Dt_Installment_Date,  
     SUM(CASE WHEN ISNULL(ICD.Flag_IsAdvanceTax,'N') = 'N' THEN ISNULL(ICCD.N_Amount_Due,0.00)  
    ELSE 0.00  
     END) N_Amount_Due,  
     ISNULL(ICD.N_Discount_Amount,0)AS N_Discount_Amount,  
     SUM(CASE WHEN ISNULL(ICD.Flag_IsAdvanceTax,'N') = 'N' THEN ISNULL(ICCD.N_Amount_Adv,0.00)  
   ELSE ISNULL(ICCD.N_Amount,0.00)  
     END) N_Advance_Amount,  
     ICCD.S_Invoice_Number,
	 ICCDT.CreditedTotalTaxAmount
	
 FROM T_Credit_Note_Invoice_Child_Detail ICCD  
 INNER JOIN T_Invoice_Child_Detail ICD ON ICCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID  
 INNER JOIN T_Invoice_Parent ICH ON ICCD.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
 left join
 (
 select DISTINCT ICD.S_Invoice_Number,sum(N_Tax_Value) as CreditedTotalTaxAmount
 from T_Credit_Note_Invoice_Child_Detail_Tax as CNICDT
 inner join
 T_Invoice_Child_Detail as ICD on CNICDT.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
  inner join T_invoice_Child_Header as ICH on ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID and
			   ICH.I_Invoice_Header_ID=@iInvoiceHeaderID
 group by ICD.I_Installment_No,ICD.S_Invoice_Number
 ) as ICCDT on ICCDT.S_Invoice_Number=ICD.S_Invoice_Number
 WHERE ICCD.I_Invoice_Header_ID = @iInvoiceHeaderID  
 GROUP BY ICD.I_Installment_No, ICCD.I_Invoice_Header_ID,   
    --CASE WHEN 
	CONVERT(DATE, ICD.Dt_Installment_Date) 
	--> CONVERT(DATE, ICCD.Dt_Crtd_On) THEN ICD.Dt_Installment_Date  
 --   ELSE ICCD.Dt_Crtd_On  
 --      END
 ,   
       ICD.N_Discount_Amount,ICCD.S_Invoice_Number,ICCDT.CreditedTotalTaxAmount) A  
 GROUP BY A.I_Installment_No, A.I_Invoice_Header_ID, Dt_Installment_Date, A.N_Discount_Amount,A.S_Invoice_Number, A.CreditedTotalTaxAmount 
   -- ORDER BY I_Installment_No, Invoice_Type DESC 

	) creditnote 



inner JOIN T_Invoice_Child_Detail ICD ON CONVERT(DATE,ICD.Dt_Installment_Date)= CONVERT(DATE,creditnote.Dt_Installment_Date)
inner join
T_Invoice_Child_Header as ICH on ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID
 inner JOIN T_Invoice_Parent TIP ON ICH.I_Invoice_Header_ID =TIP.I_Invoice_Header_ID and TIP.I_Invoice_Header_ID=@iInvoiceHeaderID
 


 -- partial 

 
 select 
 DISTINCT TIP.I_Invoice_Header_ID, I_Installment_No,SUM(NID.PreviousAmount) as partialamount,NID.Installment_Date,
 SUM(NID.N_Tax_Amount) as partialtaxamount
 from Nullify_Installments_Details as NID 
 inner join 
 T_Invoice_Child_Detail as ICD on CONVERT(DATE,NID.Installment_Date)=CONVERT(DATE,ICD.Dt_Installment_Date) and ICD.I_Invoice_Detail_ID=NID.Invoice_Detail_ID
 inner join
T_Invoice_Child_Header as ICH on ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID
 inner JOIN T_Invoice_Parent TIP ON ICH.I_Invoice_Header_ID =TIP.I_Invoice_Header_ID and TIP.I_Invoice_Header_ID=@iInvoiceHeaderID
 where NID.Isdone = 1
 group by NID.Installment_Date,TIP.I_Invoice_Header_ID,ICD.I_Installment_No




    END        
    
