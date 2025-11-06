CREATE PROCEDURE [DOCUMENT].[uspGetDocumentsForAll]    
(        
 -- Add the parameters for the stored procedure here        
 @dtCurrentDate DATETIME = NULL        
)        
            
AS          
BEGIN          
   SET NOCOUNT OFF        
            
   SELECT tud.I_Document_ID,I_Category_ID,tud.I_Brand_ID,S_File_Name,S_File_Path,Dt_Expiry_Date,I_File_Size,tcm.S_Course_Name FROM DOCUMENT.T_User_Documents AS tud      
   LEFT OUTER JOIN dbo.T_Course_Master AS tcm      
   ON tud.I_Course_ID = tcm.I_Course_ID      
   WHERE tud.I_Status = 1       
   AND tud.Dt_Expiry_Date >=  CONVERT(date, @dtCurrentDate)  
   AND tud.I_Category_ID = 1      
         
         
END
