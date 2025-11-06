CREATE FUNCTION [dbo].[fnGetCHandASH]        
(        
  @iCenterId INT        
 ,@iRoleId INT        
)        
RETURNS @UserIDTable TABLE        
(        
  I_User_Id INT        
 ,S_Email_Id VARCHAR(200)        
)        
AS        
BEGIN        
        
IF @iRoleId = 8        
BEGIN        
    
IF EXISTS    
(    
SELECT UHD.I_User_Id        
  ,UM.S_Email_Id        
FROM dbo.T_Center_Hierarchy_Details CHD        
INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD         
  ON CHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID        
INNER JOIN dbo.T_User_Hierarchy_Details UHD        
  ON HMD.I_Hierarchy_Detail_ID = UHD.I_Hierarchy_Detail_ID        
INNER JOIN dbo.T_User_Role_Details URD        
  ON UHD.I_User_Id = URD.I_User_Id        
INNER JOIN dbo.T_User_Master UM        
  ON UHD.I_User_Id = UM.I_User_Id        
WHERE URD.I_Role_Id = @iRoleId AND CHD.I_Center_Id = @iCenterId        
AND CHD.I_Status = 1        
AND HMD.I_Status = 1        
AND UHD.I_Status = 1        
AND UM.I_Status = 1    
)    
 BEGIN    
  INSERT INTO @UserIDTable        
        
  SELECT UHD.I_User_Id        
    ,UM.S_Email_Id        
  FROM dbo.T_Center_Hierarchy_Details CHD        
  INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD         
    ON CHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID        
  INNER JOIN dbo.T_User_Hierarchy_Details UHD        
    ON HMD.I_Hierarchy_Detail_ID = UHD.I_Hierarchy_Detail_ID        
  INNER JOIN dbo.T_User_Role_Details URD        
    ON UHD.I_User_Id = URD.I_User_Id        
  INNER JOIN dbo.T_User_Master UM        
    ON UHD.I_User_Id = UM.I_User_Id        
  WHERE URD.I_Role_Id = @iRoleId AND CHD.I_Center_Id = @iCenterId        
  AND CHD.I_Status = 1        
  AND HMD.I_Status = 1        
  AND UHD.I_Status = 1        
  AND UM.I_Status = 1     
 END    
 ELSE    
 BEGIN    
  INSERT INTO @UserIDTable     
  SELECT UM.I_User_Id    
  ,UM.S_Login_ID+'@aptech.ac.in'    
  FROM dbo.T_User_Master UM    
  INNER JOIN dbo.T_User_Role_Details URD ON UM.I_User_Id = URD.I_User_Id    
  WHERE URD.I_Role_ID = 1    
 END       
       
        
END        
        
ELSE IF @iRoleId = 3        
BEGIN        
 DECLARE @iHierarchyDetailId INT         
 DECLARE @continue INT         
 SET @continue = 1        
        
 SELECT @iHierarchyDetailId = I_Hierarchy_Detail_Id        
 FROM dbo.T_Center_Hierarchy_Details        
 WHERE I_Center_Id = @iCenterId AND I_Status = 1        
        
 WHILE ( @continue = 1 )        
 BEGIN        
  IF EXISTS        
  (        
   SELECT UHD.I_User_Id        
   FROM dbo.T_User_Hierarchy_Details UHD        
   INNER JOIN dbo.T_User_Role_Details URD        
    ON UHD.I_User_Id = URD.I_User_Id        
   WHERE UHD.I_Hierarchy_Detail_Id = @iHierarchyDetailId        
   AND URD.I_Role_Id = @iRoleId        
   AND UHD.I_Status = 1        
   AND URD.I_Status = 1        
  )        
  BEGIN        
   INSERT INTO @UserIDTable(I_User_Id,S_Email_Id)        
   SELECT UHD.I_User_Id,ISNULL(UM.S_Email_Id,UM.S_Login_Id+'@aptech.ac.in')        
   FROM dbo.T_User_Hierarchy_Details UHD        
   INNER JOIN dbo.T_User_Role_Details URD        
    ON UHD.I_User_Id = URD.I_User_Id        
   INNER JOIN dbo.T_User_Master UM        
    ON UM.I_User_Id = UHD.I_User_Id        
   WHERE UHD.I_Hierarchy_Detail_Id = @iHierarchyDetailId        
   AND URD.I_Role_Id = @iRoleId        
   AND UHD.I_Status = 1        
   AND URD.I_Status = 1        
   AND UM.I_Status = 1        
           
   SET @continue = 0        
  END        
  ELSE        
  BEGIN        
   SELECT @iHierarchyDetailId = I_Parent_ID        
   FROM dbo.T_Hierarchy_Mapping_Details        
   WHERE I_Hierarchy_Detail_Id = @iHierarchyDetailId        
   AND I_Status = 1        
  END        
 END        
END        
RETURN;        
END