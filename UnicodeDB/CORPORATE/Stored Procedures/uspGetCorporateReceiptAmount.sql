CREATE PROCEDURE [CORPORATE].[uspGetCorporateReceiptAmount] --7           
(                          
 -- Add the parameters for the stored procedure here                          
 @iCorporateReceiptID INT = NULL                    
                    
)                          
AS                          
BEGIN       
  
SELECT I_Corporate_Receipt_Id,SUM(trh1.N_Receipt_Amount) AS NetAmount,SUM(trh1.N_Tax_Amount) AS TTax  FROM CORPORATE.T_CorporateReceipt_StudentReceipt_Map AS tcrsrm1
INNER JOIN dbo.T_Receipt_Header AS trh1
ON tcrsrm1.I_Receipt_Header_ID = trh1.I_Receipt_Header_ID
WHERE tcrsrm1.I_Corporate_Receipt_Id = @iCorporateReceiptID
GROUP BY tcrsrm1.I_Corporate_Receipt_Id


END
