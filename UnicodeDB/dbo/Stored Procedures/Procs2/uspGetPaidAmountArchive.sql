
CREATE PROCEDURE [dbo].[uspGetPaidAmountArchive] 
(    @iInvoiceDetailID INT,
     @dtReceiptDate datetime    
)    
    
AS    
BEGIN    
    

 SELECT SUM(rcd.N_Amount_Paid)N_Amount_Paid FROM T_Receipt_Component_Detail RCD    
INNER JOIN T_Receipt_Header RH    
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID    
INNER JOIN T_Invoice_Parent IP    
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID    
WHERE RCD.I_Invoice_Detail_ID = @iInvoiceDetailID    
AND RH.I_Status = 0 AND @dtReceiptDate BETWEEN rh.Dt_Receipt_Date AND rh.Dt_Upd_On
GROUP BY rcd.I_Invoice_Detail_ID
   
END
