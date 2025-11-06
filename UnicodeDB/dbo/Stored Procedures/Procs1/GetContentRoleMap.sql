CREATE PROCEDURE [dbo].[GetContentRoleMap]
( 
 @iBatchContentDetailsID int,      
 @iHierarchyDetailID INT  
)      
As      
BEGIN 
SELECT I_RoleID FROM dbo.T_Content_Role_Map WHERE I_Content_Emp_Dtl_ID IN
(SELECT I_Content_Emp_Dtl_ID FROM dbo.T_Content_Employee_Dtl 
WHERE I_Batch_Content_Details_ID = @iBatchContentDetailsID AND I_Hierarchy_Detail_ID = @iHierarchyDetailID)

END
