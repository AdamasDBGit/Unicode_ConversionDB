CREATE PROCEDURE [dbo].[uspGetCenterInstances]   
 @iHierarchyMasterID INT = NULL 
     
AS  
   
BEGIN    
  
DECLARE @iBrandID INT

SELECT @iBrandID = I_Brand_Id FROM dbo.T_Hierarchy_Brand_Details
WHERE I_Hierarchy_Master_Id = @iHierarchyMasterID and I_Status = 1
  
 SELECT CM.I_Centre_Id  
  ,CM.S_Center_Code  
  ,CM.S_Center_Name   
FROM dbo.T_Centre_Master CM  
INNER JOIN dbo.T_Brand_Center_Details BCD ON   
CM.I_Centre_Id = BCD.I_Centre_Id  
WHERE CM.I_Status IN (0,1,3) AND CM.I_Centre_Id NOT IN     
(SELECT I_Center_Id FROM T_Center_Hierarchy_Details    
WHERE getdate() >= ISNULL(Dt_Valid_From,getdate())    
AND getdate() <= ISNULL(Dt_Valid_To,getdate())    
AND I_Status <> 0)  
AND BCD.I_Brand_Id = @iBrandId  
    
END
