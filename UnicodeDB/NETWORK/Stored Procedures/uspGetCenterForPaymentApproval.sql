-- =============================================  
-- Author:  Sayan Basu  
-- Create date: 12/01/2009  
-- Description: GETS center list for country  
-- =============================================  
CREATE PROCEDURE [NETWORK].[uspGetCenterForPaymentApproval] 
 @iHierarchyDetailId INT = NULL  
   
AS  
BEGIN 
 
 SET NOCOUNT OFF;
 
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
          
   
 
  SELECT DISTINCT CM.I_Centre_Id,CM.S_Center_Name,CM.I_Status,ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE,ISNULL(CM.S_SAP_Customer_Id,'') AS S_SAP_Customer_ID  
  FROM dbo.T_Centre_Master CM WITH(NOLOCK)  
  INNER JOIN @TempCenter TC
  ON TC.I_Center_ID=CM.I_Centre_Id
  INNER JOIN NETWORK.T_Center_Payment_Details CPD WITH(NOLOCK)  
  ON CPD.I_Centre_Id=TC.I_Center_Id
  WHERE ISNULL(CM.I_Status,1) <> 0  
       AND CPD.I_Status=1 
  ORDER BY S_Center_Name 
 END
