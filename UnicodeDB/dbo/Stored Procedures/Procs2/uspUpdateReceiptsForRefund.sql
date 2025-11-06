-- transfer receipts from old invoice to new invoice for active student      
CREATE PROCEDURE [dbo].[uspUpdateReceiptsForRefund] --296817,296827 --296722,296723    
(      
    @iInvoiceIDOld INT,      
    @iInvoiceIDNew INT      
)      
      
AS      
BEGIN      
       
 UPDATE dbo.T_Receipt_Header      
 SET I_Invoice_Header_ID = @iInvoiceIDNew      
 WHERE I_Invoice_Header_ID = @iInvoiceIDOld      
 AND I_Status = 1    
       
 CREATE TABLE #temptable       
 (      
  OldInvoiceDetailID INT,      
  NewInvoiceDetailID INT       
 )      
       
 INSERT INTO #temptable      
 SELECT ICD1.I_Invoice_Detail_ID,ICD2.I_Invoice_Detail_ID      
 FROM dbo.T_Invoice_Child_Detail ICD1      
 INNER JOIN dbo.T_Invoice_Child_Header ICH1      
 ON ICD1.I_Invoice_Child_Header_ID = ICH1.I_Invoice_Child_Header_ID      
 AND ICH1.I_Invoice_Header_ID = @iInvoiceIDOld      
 INNER JOIN dbo.T_Invoice_Child_Detail ICD2      
 ON ICD1.I_Fee_Component_ID = ICD2.I_Fee_Component_ID      
 AND ICD1.I_Installment_No = ICD2.I_Installment_No      
 AND ICD1.I_Sequence = ICD2.I_Sequence      
 INNER JOIN dbo.T_Invoice_Child_Header ICH2      
 ON ICD2.I_Invoice_Child_Header_ID = ICH2.I_Invoice_Child_Header_ID      
 AND ICH2.I_Invoice_Header_ID = @iInvoiceIDNew      
 AND ICH1.I_Course_ID = ICH2.I_Course_ID  
   
      
 UPDATE T1      
 SET T1.I_Invoice_Detail_ID = T2.NewInvoiceDetailID      
 FROM dbo.T_Receipt_Component_Detail T1      
 INNER JOIN #temptable T2      
 ON T1.I_Invoice_Detail_ID = T2.OldInvoiceDetailID      
       
 UPDATE T1      
 SET T1.I_Invoice_Detail_ID = T2.NewInvoiceDetailID      
 FROM dbo.T_Receipt_Tax_Detail T1      
 INNER JOIN #temptable T2      
 ON T1.I_Invoice_Detail_ID = T2.OldInvoiceDetailID      
       
 DROP TABLE #temptable       
       
 
 UPDATE dbo.T_Invoice_Parent SET I_Status = 0, Dt_Upd_On = GETDATE() WHERE I_Invoice_Header_ID = @iInvoiceIDOld      
END
