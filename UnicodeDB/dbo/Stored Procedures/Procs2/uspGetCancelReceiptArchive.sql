
CREATE PROCEDURE [dbo].[uspGetCancelReceiptArchive]   
(      
       @iInvoiceHeaderID INT,  
       @dtReceiptDate DATETIME             
)      
      
AS      
BEGIN      
      
SELECT RH.* FROM T_Receipt_Header RH       
INNER JOIN T_Invoice_Parent IP      
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID      
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderID      
AND RH.I_Status = 0 AND @dtReceiptDate BETWEEN rh.Dt_Crtd_On AND rh.Dt_Upd_On
option (MAXDOP 1)        
      
SELECT RCD.* FROM T_Receipt_Component_Detail RCD      
INNER JOIN T_Receipt_Header RH      
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID      
INNER JOIN T_Invoice_Parent IP      
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID      
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderID      
AND RH.I_Status = 0 AND @dtReceiptDate BETWEEN rh.Dt_Crtd_On AND rh.Dt_Upd_On option (MAXDOP 1)    
  
SELECT RTD.* FROM T_Receipt_Tax_Detail RTD      
INNER JOIN T_Receipt_Component_Detail RCD      
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID      
INNER JOIN T_Receipt_Header RH      
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID      
INNER JOIN T_Invoice_Parent IP      
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID      
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderID      
AND RH.I_Status = 0 AND @dtReceiptDate BETWEEN rh.Dt_Crtd_On AND rh.Dt_Upd_On option (MAXDOP 1)      
END
