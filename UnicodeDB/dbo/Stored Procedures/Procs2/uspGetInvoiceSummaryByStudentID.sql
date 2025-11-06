CREATE PROCEDURE [dbo].[uspGetInvoiceSummaryByStudentID] --[dbo].[uspGetInvoiceSummaryByStudentID] 719   
(                
  @iStudentID INT               
)                
AS                
SET NOCOUNT OFF                
BEGIN TRY               
       
          
    
          
   SELECT  TCM.S_Course_Name ,TSBM.S_Batch_Name,      
                TICH.N_Amount + ISNULL(TICH.N_Discount_Amount, 0) AS Course_Amt ,      
                ISNULL(TICH.N_Tax_Amount, 0) AS TaxAmt ,      
                TICH.N_Amount + ISNULL(TICH.N_Tax_Amount, 0) AS Total      
        FROM    dbo.T_Invoice_Parent AS TIP      
                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID      
                inner join T_Invoice_Batch_Map TIBM on TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID  
                AND TIBM.I_Status = 1  
                inner join T_Student_Batch_Master TSBM on TIBM.I_Batch_ID = TSBM.I_Batch_ID  
                INNER JOIN dbo.T_Course_Master AS TCM ON TICH.I_Course_ID = TCM.I_Course_ID      
        WHERE   TIP.I_Invoice_Header_ID IN ( SELECT I_Invoice_Header_ID FROM dbo.T_Invoice_Parent AS tip WHERE tip.I_Student_Detail_ID = @iStudentID and I_Status = 1)           
                AND TIP.I_Status = 1      
                AND S_Course_Name IS NOT NULL                  
            
       
select S_Receipt_No,TSM.S_Status_Desc as ReceiptType,TRH.Dt_Receipt_Date,
N_Receipt_Amount,TRH.N_Tax_Amount,
N_Receipt_Amount+TRH.N_Tax_Amount as TotalAmount,
S_Invoice_No from T_Receipt_Header TRH
LEFT OUTER JOIN T_Invoice_Parent TIP
on TRH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
AND TIP.I_Status = 1
INNER JOIN T_Status_Master TSM
ON TRH.I_Receipt_Type = TSM.I_Status_Value
AND TSM.S_Status_Type = 'ReceiptType'
where TRH.I_Student_Detail_ID = @iStudentID
AND TRH.I_Status = 1
order by TRH.Dt_Receipt_Date

       
select TIP.S_Invoice_No,TIP.Dt_Invoice_Date,
TSIH.I_Cancellation_Reason_ID,TIP.Dt_Upd_On as Dt_Cancellation_Date 
from T_Student_Invoice_History TSIH  
inner join T_Invoice_Parent TIP  
on TSIH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID  
where TSIH.I_Student_Detail_ID = @iStudentID    
AND TSIH.I_Status = 1          
             
END TRY                
                
BEGIN CATCH                
 --Error occurred:                  
                
 DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int                
 SELECT @ErrMsg = ERROR_MESSAGE(),                
   @ErrSeverity = ERROR_SEVERITY()                
                
 RAISERROR(@ErrMsg, @ErrSeverity, 1)                
END CATCH
