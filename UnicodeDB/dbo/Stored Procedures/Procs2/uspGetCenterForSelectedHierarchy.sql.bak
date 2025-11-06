CREATE PROCEDURE [dbo].[uspGetCenterForSelectedHierarchy]  
  
 (  
  @iSelectedHierarchyId int,  
  @iSelectedBrandId int = null  
 )  
 
AS  
  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @sSearchCriteria varchar(max)  
   
 IF @iSelectedBrandId IS NULL  
 BEGIN  
  SET @iSelectedBrandId = 0  
 END  
   
 SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId    
   
 IF @iSelectedBrandId = 0   
  BEGIN  
   SELECT TCHD.I_Center_Id,CM.S_Center_Name,CM.S_Center_Short_Name,CM.S_Center_Code  
   FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_Centre_Master CM WHERE   
   TCHD.I_Hierarchy_Detail_ID IN   
   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details WHERE  
   S_Hierarchy_Chain LIKE @sSearchCriteria + '%' AND I_Status=1)   
   AND TCHD.I_Center_Id = CM.I_Centre_Id  
  END  
 ELSE  
  BEGIN  
   SELECT TCHD.I_Center_Id,CM.S_Center_Name,CM.S_Center_Short_Name,CM.S_Center_Code  
   FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD,T_Centre_Master CM WHERE  
   TCHD.I_Hierarchy_Detail_ID IN   
     (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%' AND I_Status=1) AND  
   TBCD.I_Brand_ID=@iSelectedBrandId AND  
   TBCD.I_Centre_Id = TCHD.I_Center_Id  
   AND TCHD.I_Center_Id = CM.I_Centre_Id
   AND TCHD.I_Status = 1  
   AND TBCD.I_Status = 1
   AND CM.I_Status = 1
      
  END  
END
