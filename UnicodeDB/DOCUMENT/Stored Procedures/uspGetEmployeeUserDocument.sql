CREATE PROCEDURE [DOCUMENT].[uspGetEmployeeUserDocument]  --'8/11/2011',8,292284  
(      
 -- Add the parameters for the stored procedure here      
 @dtCurrentDate DATETIME = NULL ,    
 @iRoleID INT = NULL  ,  
 @iUserID INT = NULL  
)      
          
AS        
BEGIN        
  
  SET NOCOUNT OFF       
  DECLARE @sSearchCriteria varchar(100)           
    
SELECT @sSearchCriteria = S_Hierarchy_Chain         
FROM T_Hierarchy_Mapping_Details         
WHERE I_Hierarchy_detail_id IN(  SELECT I_Hierarchy_Detail_ID FROM dbo.T_User_Hierarchy_Details WHERE I_User_ID = @iUserID AND I_Hierarchy_Master_ID <> 1 AND I_Status = 1)  
  
 SELECT I_Document_ID,I_Category_ID,I_Brand_ID,S_File_Name,S_File_Path,Dt_Expiry_Date,I_File_Size,tud.I_Hierarchy_Detail_ID,thd.S_Hierarchy_Name FROM DOCUMENT.T_User_Documents AS tud    
 INNER JOIN dbo.T_Hierarchy_Details AS thd    
 ON tud.I_Hierarchy_Detail_ID = thd.I_Hierarchy_Detail_ID    
 WHERE tud.I_Category_ID = 2    
 AND tud.I_Document_ID IN (SELECT I_DocumentID FROM DOCUMENT.T_Document_Role_Map AS tdrm WHERE    
 tdrm.I_RoleID = @iRoleID)    
 AND  tud.I_Status = 1     
 AND tud.Dt_Expiry_Date >= CONVERT(date, @dtCurrentDate)     
 AND tud.I_Hierarchy_Detail_ID IN  
 (  
 SELECT * FROM dbo.fnString2Rows(@sSearchCriteria,',') AS fsr  
)   
       
END
