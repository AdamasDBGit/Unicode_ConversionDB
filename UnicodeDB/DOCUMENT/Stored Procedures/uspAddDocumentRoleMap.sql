CREATE PROCEDURE [DOCUMENT].[uspAddDocumentRoleMap]      
(    
    @iDocumentID INT,    
    @sUserRoleNames varchar(MAX) = NULL,   
    @iStatus INT = NULL   
       
)    
AS    
BEGIN    
DECLARE @xml_hndl INT  
  
--prepare the XML Document by executing a system stored procedure      
 exec sp_xml_preparedocument @xml_hndl OUTPUT, @sUserRoleNames      
   
   INSERT INTO DOCUMENT.T_Document_Role_Map
           (
            I_DocumentID, 
            I_RoleID, 
            I_Status 
            )
            Select @iDocumentID,RoleID,@iStatus 
            From      
            OPENXML(@xml_hndl, '/Root/UserRoleOption', 1)      
            With      
             (      
               RoleID INT '@UserRoleID'      
             )      
                        
 
        
       -- SELECT @@IDENTITY    
END
