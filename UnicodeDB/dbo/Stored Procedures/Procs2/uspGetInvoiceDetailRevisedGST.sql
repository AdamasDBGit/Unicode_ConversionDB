/*--------------------------------------------------------------------------------------------------------------------------------------  
NAME           -  [dbo].[uspGetInvoiceDetailRevisedGST]  
CREATED DATE   -  21st June 2017  
--------------------------------------------------------------------------------------------------------------------------------------*/  
-- exec uspGetInvoiceDetailRevisedGST 160281  
CREATE PROCEDURE [dbo].[uspGetInvoiceDetailRevisedGST]  --[dbo].[uspGetInvoiceDetailRevisedGST] 157738      
    (      
      @iInvoiceHeaderID INT            
    )      
AS       
BEGIN   

 SELECT ICH.I_Invoice_Header_ID, ICD.I_Installment_No,   
     REPLACE(CONVERT(NVARCHAR(256),ICD.Dt_Installment_Date,106),' ','/') Dt_Installment_Date,  
     SUM(ICD.N_Amount_Due) N_Amount_Due,   
     ISNULL(ICD.N_Discount_Amount,0) AS N_Discount_Amount,   
     SUM(ICD.N_Amount_Adv_Coln) N_Advance_Amount,  
     CASE WHEN (SUM(ICD.N_Amount_Due) - ISNULL(ICD.N_Discount_Amount,0) - SUM(ICD.N_Amount_Adv_Coln)) > 0 THEN (SUM(ICD.N_Amount_Due) - ISNULL(ICD.N_Discount_Amount,0) - SUM(ICD.N_Amount_Adv_Coln))  
     ELSE 0.00  
     END N_Net_Amount,  
     ICD.S_Invoice_Number,  
     CASE WHEN ISNULL(ICD.Flag_IsAdvanceTax, 'N') <> 'Y' THEN 'I'  
    ELSE 'Y'  
     END Invoice_Type  
 FROM T_Invoice_Child_Detail ICD  
 INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID  
 WHERE ICH.I_Invoice_Header_ID = @iInvoiceHeaderID  
 GROUP BY ICD.I_Installment_No, ICH.I_Invoice_Header_ID, ICD.Dt_Installment_Date, ICD.N_Discount_Amount,ICD.S_Invoice_Number,ICD.Flag_IsAdvanceTax  
    UNION ALL  
    SELECT I_Invoice_Header_ID, I_Installment_No,   
     REPLACE(CONVERT(VARCHAR(256),Dt_Installment_Date,106),' ','/') Dt_Installment_Date,  
     (-1)*SUM(ISNULL(N_Amount_Due,0)) N_Amount_Due,   
     0 as N_Discount_Amount,   
     CASE WHEN I_Installment_No = 0 THEN (-1)*SUM(N_Advance_Amount)   
       ELSE SUM(N_Advance_Amount)   
     END N_Advance_Amount,   
    -- (-1)*ISNULL(CASE WHEN (SUM(N_Amount_Due) - ISNULL(N_Discount_Amount,0) - SUM(N_Advance_Amount)) > 0   
    --THEN (SUM(N_Amount_Due) - ISNULL(N_Discount_Amount,0) - SUM(N_Advance_Amount))  
	 (-1)*ISNULL(CASE WHEN (SUM(N_Amount_Due) - SUM(N_Advance_Amount)) > 0   
    THEN (SUM(N_Amount_Due)  - SUM(N_Advance_Amount))
     ELSE 0.00  
     END,0) N_Net_Amount,  
     S_Invoice_Number,  
     'C' Invoice_Type  
 FROM(  
    SELECT ICCD.I_Invoice_Header_ID, ICD.I_Installment_No,   
     CASE WHEN CONVERT(DATE, ICD.Dt_Installment_Date) > CONVERT(DATE, ICCD.Dt_Crtd_On) THEN ICD.Dt_Installment_Date  
    ELSE ICCD.Dt_Crtd_On  
     END AS Dt_Installment_Date,  
     SUM(CASE WHEN ISNULL(ICD.Flag_IsAdvanceTax,'N') = 'N' THEN ISNULL(ICCD.N_Amount_Due,0.00)  
    ELSE 0.00  
     END) N_Amount_Due,  
     ISNULL(ICD.N_Discount_Amount,0)AS N_Discount_Amount,  
     SUM(CASE WHEN ISNULL(ICD.Flag_IsAdvanceTax,'N') = 'N' THEN ISNULL(ICCD.N_Amount_Adv,0.00)  
   ELSE ISNULL(ICCD.N_Amount,0.00)  
     END) N_Advance_Amount,  
     ICCD.S_Invoice_Number       
 FROM T_Credit_Note_Invoice_Child_Detail ICCD  
 INNER JOIN T_Invoice_Child_Detail ICD ON ICCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID  
 INNER JOIN T_Invoice_Parent ICH ON ICCD.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID  
 WHERE ICCD.I_Invoice_Header_ID = @iInvoiceHeaderID  
 GROUP BY ICD.I_Installment_No, ICCD.I_Invoice_Header_ID,   
    CASE WHEN CONVERT(DATE, ICD.Dt_Installment_Date) > CONVERT(DATE, ICCD.Dt_Crtd_On) THEN ICD.Dt_Installment_Date  
    ELSE ICCD.Dt_Crtd_On  
       END,   
       ICD.N_Discount_Amount,ICCD.S_Invoice_Number) A  
 GROUP BY A.I_Installment_No, A.I_Invoice_Header_ID, REPLACE(CONVERT(VARCHAR(256),Dt_Installment_Date,106),' ','/'), A.N_Discount_Amount,A.S_Invoice_Number  
    ORDER BY I_Installment_No, Invoice_Type DESC  
END
