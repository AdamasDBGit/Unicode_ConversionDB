CREATE PROCEDURE [CORPORATE].[uspGetCorporateReceiptList]   --288796
(  
 -- Add the parameters for the stored procedure here  
 @iInvoiceID int = NULL
)  
  
AS  
BEGIN  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON  
  
 SELECT A.*  
 FROM   
  dbo.T_Receipt_Header A 
  INNER JOIN CORPORATE.T_CorporateReceipt_StudentReceipt_Map AS TCRSRM
  ON A.I_Receipt_Header_ID = TCRSRM.I_Receipt_Header_ID   
 WHERE  
  ISNULL(A.I_Invoice_Header_ID,'') = ISNULL(ISNULL(@iInvoiceID, A.I_Invoice_Header_ID),'')  
  AND A.I_Status = 1  
   
    
   
END
