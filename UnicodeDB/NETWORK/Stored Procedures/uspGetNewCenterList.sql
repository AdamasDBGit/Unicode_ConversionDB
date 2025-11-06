CREATE PROCEDURE [NETWORK].[uspGetNewCenterList]  
 @iCenterCategory INT = NULL,  
 @sCenterName varchar(100) = NULL,  
 @sCenterShortName varchar(50) = NULL,  
 @iBrandId INT=NULL  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SELECT CM.I_Centre_Id,  
   CM.S_Center_Code,  
   CM.S_Center_Name,  
   CM.S_SAP_Customer_Id,  
   CM.I_Status,  
   CM.S_Center_Short_Name,  
   CM.I_Center_Category,  
   BM.S_Brand_Name  
 FROM dbo.T_Centre_Master CM  
 inner join T_Brand_Center_Details BCD  
 on CM.I_Centre_Id=BCD.I_Centre_Id  
 inner join T_Brand_master BM  
 on BCD.i_brand_id=BM.i_brand_id  
 WHERE ISNULL(ISNULL(@iCenterCategory,CM.I_Center_Category),0) = ISNULL(CM.I_Center_Category,0)  
 AND ISNULL(CM.S_Center_Name,'') LIKE '%' + ISNULL(@sCenterName,'') + '%'  
 AND ISNULL(CM.S_Center_Short_Name,'') LIKE '%' + ISNULL(@sCenterShortName,'') + '%'  
 --AND CM.I_Status <> 0   
 AND BM.i_brand_id=@iBrandId  
 ORDER BY CM.Dt_Crtd_On DESC  
   
END
