-- =============================================      
-- Author:  Sayan Basu    
-- Create date: 06/08/2007      
-- Description: Get center change in location Request according to selected hierarchy    
-- =============================================      
      
CREATE PROCEDURE [NETWORK].[uspGetCenterChangeInLocationRequestHierarchyWise]      
(      
 @iStatus int,    
 @iHierarchyDetailId INT = null      
)      
AS      
BEGIN     
 -----------------------    
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
 -----------------------      
      
    
  SELECT       
   CM.I_Centre_Id,      
   CM.S_Center_Code,      
   CM.S_Center_Name,      
   CM.I_Country_ID,      
   AR.I_Status,      
   BCD.I_Brand_ID      
      
  FROM dbo.T_Centre_Master CM      
   INNER JOIN NETWORK.T_AddressChange_Request AR      
   ON AR.I_Centre_Id = CM.I_Centre_Id      
   INNER JOIN  @TempCenter tmpCenter     
   ON tmpCenter.I_Center_Id = AR.I_Centre_Id    
   INNER JOIN dbo.T_Brand_Center_Details BCD    
   ON BCD.I_Centre_Id= tmpCenter.I_Center_Id      
  WHERE AR.I_Status = @iStatus      
    
 END
