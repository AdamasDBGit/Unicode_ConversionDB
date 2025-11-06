CREATE PROCEDURE [dbo].[uspGetUserCenterHierarchyDetails] --1262,2,'VOC301' ,'SANJAY',NULL,'KUMAR','ST '             
(                
  @iHierarchyDetailID INT = NULL,                
  @iBrandID INT = NULL,                 
  @sLoginID VARCHAR(100) = NULL ,                   
  @sFirstName varchar(50) = NULL,                
  @sMiddleName varchar(50) = NULL,                
  @sLastName varchar(50) = NULL,      
  @sUserType VARCHAR(20) = NULL                  
                   
)                    
AS                
BEGIN                
SET NOCOUNT OFF;                    
                
DECLARE @sUserFName VARCHAR(50)                  
DECLARE @sUserLName VARCHAR(50)                  
DECLARE @sUserMName VARCHAR(50)                  
                 
DECLARE @tblUsers TABLE                
(                
 I_User_Id INT,                
 S_Login_ID VARCHAR(500),                
 S_First_Name VARCHAR(50),                
 S_Middle_Name VARCHAR(50),                
 S_Last_Name VARCHAR(50),                
 Dt_DOB DATE,                
 S_Email_ID VARCHAR(100),      
 S_User_Type VARCHAR(20)                
)                
                
IF(@sFirstName IS NOT NULL)                  
  SET @sUserFName = @sFirstName + '%'                  
 IF(@sMiddleName IS NOT NULL)                   
  SET @sUserMName = @sMiddleName + '%'                  
 IF(@sLastName IS NOT NULL)                  
   SET @sUserLName = @sLastName + '%'                  
                   
INSERT INTO @tblUsers                
        ( I_User_Id , S_Login_ID , S_First_Name ,S_Middle_Name , S_Last_Name ,S_Email_ID,S_User_Type)                
SELECT tum.I_User_ID,tum.S_Login_ID,ted.S_First_Name,ISNULL(ted.S_Middle_Name,''),                
  ted.S_Last_Name, ted.S_Email_ID,tum.S_User_Type                 
FROM dbo.T_Employee_Dtls AS ted                
INNER JOIN dbo.T_User_Master AS tum ON ted.I_Employee_ID = tum.I_Reference_ID                
WHERE I_Centre_Id IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@iHierarchyDetailID,@iBrandID))                
AND  ted.S_First_Name LIKE COALESCE(@sUserFName,ted.S_First_Name)                  
AND COALESCE(ted.S_Middle_Name,'') LIKE COALESCE(COALESCE(@sUserMName,ted.S_Middle_Name),'')                   
AND ted.S_Last_Name LIKE COALESCE(@sUserLName,ted.S_Last_Name)                   
AND tum.S_Login_ID = COALESCE(@sLoginID,tum.S_Login_ID)                   
AND tum.S_User_Type='CE'               
                  
                 
INSERT INTO @tblUsers                
        ( I_User_Id , S_Login_ID , S_First_Name ,S_Middle_Name , S_Last_Name ,S_Email_ID,S_User_Type)                
SELECT tum.I_User_ID,tum.S_Login_ID,tsd.S_First_Name,ISNULL(tsd.S_Middle_Name,''),tsd.S_Last_Name,tsd.S_Email_ID,tum.S_User_Type      
FROM dbo.T_Student_Detail AS tsd                
INNER JOIN dbo.T_Student_Center_Detail AS tscd ON tsd.I_Student_Detail_ID = tscd.I_Student_Detail_ID                
INNER JOIN dbo.T_User_Master AS tum ON tsd.I_Student_Detail_ID=tum.I_Reference_ID                
WHERE I_Centre_Id IN (SELECT I_Center_ID FROM dbo.fnGetCenterIDFromHierarchy(@iHierarchyDetailID,@iBrandID))                
 AND tsd.S_First_Name LIKE COALESCE(@sUserFName,tsd.S_First_Name)                 
 AND COALESCE(tsd.S_Middle_Name,'') LIKE COALESCE(COALESCE(@sUserMName,tsd.S_Middle_Name),'')                 
 AND tsd.S_Last_Name LIKE COALESCE(@sUserLName,tsd.S_Last_Name)                
 AND tum.S_Login_ID = COALESCE(@sLoginID,tum.S_Login_ID)                   
 AND tum.S_User_Type='ST'                
    
--SELECT * FROM @tblUsers    
        
DECLARE @sSearchCriteria varchar(100)        
SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iHierarchyDetailID              
              
INSERT INTO @tblUsers                
        ( I_User_Id , S_Login_ID , S_First_Name ,S_Middle_Name , S_Last_Name  ,S_Email_ID,S_User_Type)                
SELECT tuhd.I_User_ID,tum.S_Login_ID,tum.S_First_Name,isnull(tum.S_Middle_Name,''),                
  tum.S_Last_Name, tum.S_Email_ID,tum.S_User_Type                 
  FROM dbo.T_User_Hierarchy_Details AS tuhd                
INNER JOIN dbo.T_User_Master AS tum ON tuhd.I_User_ID = tum.I_User_ID                
WHERE I_Hierarchy_Detail_ID IN (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details             
    WHERE I_Status = 1            
    AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())            
    AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())            
    AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%')         
 AND tum.S_First_Name LIKE COALESCE(@sUserFName,tum.S_First_Name)                
 AND COALESCE(tum.S_Middle_Name,'') LIKE COALESCE(COALESCE(@sUserMName,tum.S_Middle_Name),'')                
 AND tum.S_Last_Name LIKE COALESCE(@sUserLName,tum.S_Last_Name)                
 AND tum.S_Login_ID = COALESCE(@sLoginID,tum.S_Login_ID)                  
              
               
                
SELECT  DISTINCT I_User_Id ,S_Login_ID ,S_First_Name ,S_Middle_Name ,S_Last_Name  ,S_Email_ID, S_User_Type                
FROM @tblUsers AS tu WHERE S_User_Type = ISNULL(@sUserType,S_User_Type)                
                
                
END
