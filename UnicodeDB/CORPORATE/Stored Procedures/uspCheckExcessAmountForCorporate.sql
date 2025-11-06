CREATE PROCEDURE [CORPORATE].[uspCheckExcessAmountForCorporate]   
(          
 @iCorporateInvoiceID int          
)          
          
          
AS          
          
BEGIN          
 SET NOCOUNT ON;          
 
   SELECT * FROM CORPORATE.T_Corporate_Invoice_Receipt_Map AS tcirm
   WHERE tcirm.I_Corporate_Invoice_Id =  @iCorporateInvoiceID
     
END
