--NETWORK.uspGetFilteredCenters 1,'RESURRECTION'        
CREATE PROCEDURE [NETWORK].[uspGetFilteredCenters]        
 @iHierarchyDetailID INT,        
 @sType VARCHAR(100)        
AS        
BEGIN        
      
declare @sSearchCriteria varchar(100)            
      
DECLARE @TempCenter TABLE              
(               
 I_Center_ID int              
)              
      
SELECT @sSearchCriteria= S_Hierarchy_Chain               
FROM T_Hierarchy_Mapping_Details               
WHERE I_Hierarchy_detail_id = @iHierarchyDetailID              
      
INSERT INTO @TempCenter               
SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE               
TCHD.I_Hierarchy_Detail_ID IN               
(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details               
WHERE I_Status = 1              
AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())              
AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())              
AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%'              
)         
      
IF @sType = 'CHANGEINLOCATION'        
BEGIN        
 SELECT DISTINCT CM.I_Centre_Id        
 ,CM.S_Center_Name        
 ,CM.I_Status        
 ,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE          
  FROM dbo.T_Centre_Master CM        
     INNER JOIN NETWORK.T_AddressChange_Request ACR        
   ON CM.I_CENTRE_ID = ACR.I_CENTRE_ID        
     INNER JOIN @TempCenter TCM         
   ON TCM.I_CENTER_ID = CM.I_Centre_Id   
   WHERE ACR.I_STATUS <> 7        
END        
ELSE IF @sType = 'UPGRADE'        
BEGIN        
 SELECT DISTINCT CM.I_Centre_Id        
 ,CM.S_Center_Name        
 ,CM.I_Status        
 ,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE          
  FROM dbo.T_Centre_Master CM        
     INNER JOIN NETWORK.T_Upgrade_Request UR        
   ON CM.I_CENTRE_ID = UR.I_CENTRE_ID        
     INNER JOIN @TempCenter TCM         
   ON TCM.I_CENTER_ID = CM.I_Centre_Id   
   WHERE UR.I_STATUS <> 8 AND UR.I_IS_UPGRADE = 1       
END        
ELSE IF @sType = 'RESURRECTION'        
BEGIN        
 SELECT DISTINCT CM.I_Centre_Id        
 ,CM.S_Center_Name        
 ,CM.I_Status        
 ,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE          
  FROM dbo.T_Centre_Master CM        
     INNER JOIN NETWORK.T_Resurrection_Request RR        
   ON CM.I_CENTRE_ID = RR.I_CENTRE_ID        
     INNER JOIN @TempCenter TCM         
   ON TCM.I_CENTER_ID = CM.I_Centre_Id   
   WHERE RR.I_STATUS <> 9         
END       
ELSE        
BEGIN        
 SELECT DISTINCT CM.I_Centre_Id        
 ,CM.S_Center_Name        
 ,CM.I_Status        
 ,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE          
  FROM dbo.T_Centre_Master CM        
      
     INNER JOIN @TempCenter TCM         
   ON TCM.I_CENTER_ID = CM.I_Centre_Id        
END        
      
END
