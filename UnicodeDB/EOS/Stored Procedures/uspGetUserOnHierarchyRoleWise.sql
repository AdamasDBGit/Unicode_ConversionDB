/*****************************************************************************************************************            
Created by: Utpal      
Date: 18/08/2011          
Description: GET User Details For Video List         
Parameters:             
Returns:             
Modified By:             
******************************************************************************************************************/            
    
CREATE PROCEDURE [EOS].[uspGetUserOnHierarchyRoleWise] --1204,'2,3,8'             
(                    
 -- Add the parameters for the stored procedure here                    
 @iHierarchyDetailID INT,            
 @sRoleIDs VARCHAR(50) = NULL                      
)                    
AS                    
BEGIN         
        
  
SELECT DISTINCT tum.I_User_ID,tum.S_First_Name,tum.S_Middle_Name,tum.S_Last_Name,tuhd.I_Hierarchy_Detail_ID,thd.S_Hierarchy_Name,turd.I_Role_ID,trm.S_Role_Code    
INTO #temp     
FROM dbo.T_User_Master AS tum    
INNER JOIN dbo.T_User_Hierarchy_Details AS tuhd    
ON tum.I_User_ID = tuhd.I_User_ID    
INNER JOIN dbo.T_Hierarchy_Details AS thd      
ON tuhd.I_Hierarchy_Detail_ID = thd.I_Hierarchy_Detail_ID    
INNER JOIN dbo.T_User_Role_Details AS turd    
ON tum.I_User_ID = turd.I_User_ID    
INNER JOIN dbo.T_Role_Master AS trm    
ON turd.I_Role_ID = trm.I_Role_ID    
WHERE tuhd.I_Hierarchy_Detail_ID IN (SELECT I_Hierarchy_Detail_ID FROM dbo.T_Hierarchy_Mapping_Details AS THMD WHERE THMD.S_Hierarchy_Chain  LIKE '%' + CAST(@iHierarchyDetailID AS VARCHAR(10)) + '%' )     
AND turd.I_Role_ID IN (SELECT * FROM dbo.fnString2Rows(@sRoleIDs,',') AS fsr)    
    
SELECT  DISTINCT t2.I_User_ID,t2.S_First_Name,t2.S_Middle_Name,t2.S_Last_Name,t2.I_Hierarchy_Detail_ID,t2.S_Hierarchy_Name ,    
 RoleIds = STUFF((SELECT ','+CAST(t1.I_Role_ID AS VARCHAR(5))      
 FROM #temp AS t1      
 WHERE  t1.I_User_ID = t2.I_User_ID    
 ORDER BY t1.I_User_ID      
 FOR XML PATH('')),1,1,'')   ,    
 RoleName = STUFF((SELECT ', '+t1.S_Role_Code      
 FROM #temp AS t1      
 WHERE t1.I_User_ID = t2.I_User_ID    
 ORDER BY t1.I_User_ID      
 FOR XML PATH('')),1,1,'')    
     
 FROM #temp AS t2    
       
DROP TABLE #temp      
      
END
