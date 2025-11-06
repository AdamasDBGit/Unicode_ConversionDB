CREATE PROCEDURE [CORPORATE].[uspAddCorporateStudentReceiptMap]    
(          
 @iCorporateReceiptId INT,          
 @sReceiptHeaderIds VARCHAR(MAX)  
)                  
  
AS           
BEGIN   
declare @xml_hndl int          
           
 --prepare the XML Document by executing a system stored procedure          
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sReceiptHeaderIds          
   
   INSERT INTO CORPORATE.T_CorporateReceipt_StudentReceipt_Map
           ( 
             I_Corporate_Receipt_Id ,
             I_Receipt_Header_ID
           )
 SELECT @iCorporateReceiptId,IDToInsert   
 FROM OPENXML( @xml_hndl,  '/Root/StudentReceipt', 1)          
 WITH    
 (    
    IDToInsert int '@ID'    
 )    
   
 END
