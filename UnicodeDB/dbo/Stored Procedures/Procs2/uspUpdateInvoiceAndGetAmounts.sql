-- transfer receipts from old invoice to new invoice and get excess amounts      
CREATE PROCEDURE [dbo].[uspUpdateInvoiceAndGetAmounts]   --296722,296723    
(      
    @iInvoiceIDOld INT     
)      
      
      
AS      
BEGIN      
       
        
 --find excess amount paid for each invoice detail      
 SELECT ICD.I_Invoice_Detail_ID,ICD.I_Installment_No,ICD.I_Sequence,( - SUM(RCD.N_Amount_Paid)) AS [ExcessAmountPaid]      
 FROM dbo.T_Receipt_Component_Detail RCD      
 INNER JOIN dbo.T_Invoice_Child_Detail ICD      
 ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID      
 INNER JOIN dbo.T_Invoice_Child_Header ICH      
 ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID    
 INNER JOIN dbo.T_Receipt_Header RH    
 ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID      
 WHERE ICH.I_Invoice_Header_ID = @iInvoiceIDOld      
 AND RH.I_Status = 1    
 GROUP BY ICD.I_Invoice_Detail_ID,ICD.I_Installment_No,ICD.I_Sequence,ICD.N_Amount_Due      
      
 --find excess amount paid for each invoice detail tax      
 SELECT ICD.I_Invoice_Detail_ID,ICD.I_Installment_No,ICD.I_Sequence,RTD.I_Tax_ID,(- SUM(RTD.N_Tax_Paid)) AS [ExcessTaxPaid]      
 FROM dbo.T_Invoice_Detail_Tax IDT      
 INNER JOIN dbo.T_Invoice_Child_Detail ICD      
 ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID      
 INNER JOIN dbo.T_Invoice_Child_Header ICH      
 ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID      
 INNER JOIN dbo.T_Receipt_Tax_Detail RTD      
 ON ICD.I_Invoice_Detail_ID = RTD.I_Invoice_Detail_ID      
 AND IDT.I_Tax_ID = RTD.I_Tax_ID      
 INNER JOIN dbo.T_Receipt_Component_Detail RCD    
 ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID    
 INNER JOIN dbo.T_Receipt_Header RH    
 ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID    
 WHERE ICH.I_Invoice_Header_ID = @iInvoiceIDOld     
 AND RH.I_Status = 1     
 GROUP BY IDT.N_Tax_Value,ICD.I_Installment_No,ICD.I_Sequence,ICD.I_Invoice_Detail_ID,RTD.I_Tax_ID      
       
 UPDATE dbo.T_Invoice_Parent SET I_Status = 0, Dt_Upd_On = GETDATE() WHERE I_Invoice_Header_ID = @iInvoiceIDOld      
END
