-- =============================================    
-- Author:  Sayan Basu    
-- Create date: 26/03/2006    
-- Description: GETS center list for hierarchy   
-- =============================================    
CREATE PROCEDURE [dbo].[uspGetCenterForHierarchy] --231  
 @iHierarchyDetailID INT       
AS    
BEGIN    
 SET NOCOUNT OFF;    
   
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
    
  SELECT DISTINCT CM.I_Centre_Id,CM.S_Center_Name,CM.I_Status,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE    
  FROM dbo.T_Centre_Master CM     
  INNER JOIN @TempCenter   cmTemp    
  ON CM.I_Centre_Id = cmTemp.I_Center_Id    
  
END
