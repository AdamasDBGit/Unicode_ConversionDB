CREATE PROCEDURE [CORPORATE].[uspAddCorporateStudentInvoiceMap]  
(        
 @iCorporateInvoiceId INT,        
 @sInvoiceHeaderIds VARCHAR(MAX)
)                

AS         
BEGIN 
declare @xml_hndl int        
         
 --prepare the XML Document by executing a system stored procedure        
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sInvoiceHeaderIds        
   
 INSERT INTO CORPORATE.T_CorporateInvoice_StudentInvoice_Map
         ( 
          I_Corporate_Invoice_Id ,
           I_Invoice_Header_ID
         )  
 SELECT @iCorporateInvoiceId,IDToInsert 
 FROM OPENXML( @xml_hndl,  '/Root/StudentInvoice', 1)        
 WITH  
 (  
    IDToInsert int '@ID'  
 )  
 
 END
