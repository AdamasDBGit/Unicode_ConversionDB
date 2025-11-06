CREATE PROCEDURE [dbo].[uspGetReceiptArchive]  
(  
       @iInvoiceHeaderID int  
)  
  
AS  
BEGIN  
  
SELECT RH.* FROM T_Receipt_Header_Archive RH   
INNER JOIN T_Invoice_Parent IP  
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID  
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderID  
AND RH.I_Status = 1 option (MAXDOP 1)  
  
  
SELECT RCD.* FROM T_Receipt_Component_Detail_Archive RCD  
INNER JOIN T_Receipt_Header_Archive RH  
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
INNER JOIN T_Invoice_Parent IP  
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID  
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderID  
AND RH.I_Status = 1 option (MAXDOP 1)  
  
SELECT RTD.* FROM T_Receipt_Tax_Detail_Archive RTD  
INNER JOIN T_Receipt_Component_Detail_Archive RCD  
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID  
INNER JOIN T_Receipt_Header_Archive RH  
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
INNER JOIN T_Invoice_Parent IP  
ON RH.I_Invoice_Header_ID =IP.I_Invoice_Header_ID  
WHERE IP.I_Invoice_Header_ID = @iInvoiceHeaderID  
AND RH.I_Status = 1 option (MAXDOP 1)  
END
