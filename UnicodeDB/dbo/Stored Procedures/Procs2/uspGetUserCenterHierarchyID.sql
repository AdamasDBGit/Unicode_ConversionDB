CREATE PROCEDURE [dbo].[uspGetUserCenterHierarchyID]  --874          
(                  
  @iCenterID INT = NULL             
                     
)                      
AS                  
BEGIN                  
SET NOCOUNT OFF;                      
                  

SELECT	I_Center_Hierarchy_Detail_ID ,
        I_Center_Id ,
        I_Hierarchy_Detail_ID ,
        I_Hierarchy_Master_ID ,
        Dt_Valid_From ,
        Dt_Valid_To ,
        I_Status FROM dbo.T_Center_Hierarchy_Details AS tchd
WHERE tchd.I_Center_Id = @iCenterID
                  
                  
END
