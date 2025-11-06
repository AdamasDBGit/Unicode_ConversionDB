CREATE PROCEDURE [CORPORATE].[uspAddCorporateInvoiceReceipt]                
(              
 @iCorporateInvoiceID INT,              
 @iReceiptHeaderID INT        
)              
AS               
BEGIN              
        
 INSERT INTO CORPORATE.T_Corporate_Invoice_Receipt_Map
         ( 
           I_Corporate_Invoice_Id ,
           I_Receipt_Header_ID
         )
 VALUES  ( 
           @iCorporateInvoiceID , -- I_Corporate_Invoice_Id - int
           @iReceiptHeaderID  -- I_Receipt_Header_ID - int
         )
       
                
        
END
