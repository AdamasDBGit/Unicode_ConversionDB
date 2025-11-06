-- =============================================  
-- Author:  <Susmita Paul>  
-- Create date: <2024-April-22>  
-- Description: <get UserID and RoleIDs>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_UserGroup_Details]  
 -- Add the parameters for the stored procedure here  
 @iUserGroupID INT=null,  
 @iBrandID INT  
AS  
BEGIN  
   
 select   
 I_User_Group_Master_ID UserGroupID,  
 S_User_GroupName UserGroupName,  
 ISNULL(S_Code,'NA') UserGroupCode,  
 Is_Active IsGroupActive  
 from   
 T_ERP_User_Group_Master   
 where I_User_Group_Master_ID=ISNULL(@iUserGroupID,I_User_Group_Master_ID) and I_Brand_ID=@iBrandID  
 and Is_Active=1
 ORDER BY UserGroupID DESC  
  
  
 select DISTINCT  
 UGM.I_User_Group_Master_ID  UserGroupID,  
 EU.I_User_ID as UserID  
 from   
 T_ERP_Users_Role_Permission_Map as URP   
 inner join  
 T_ERP_User_Group_Master  as UGM on URP.User_Group_ID=UGM.I_User_Group_Master_ID   
 inner join  
 T_ERP_User as EU on EU.I_User_Id=URP.I_User_Id and EU.I_Status=1   
 where UGM.I_User_Group_Master_ID=ISNULL(@iUserGroupID,I_User_Group_Master_ID) and URP.Brand_ID=@iBrandID and URP.Is_Active=1  
  
  
 select DISTINCT UGM.I_User_Group_Master_ID as UserGroupID,  
 URBM.I_Role_ID as RoleID  
 from   
 T_ERP_User_Group_Master  as UGM  
 inner join  
 T_ERP_UserGroup_Role_Brand_Map as URBM on UGM.I_User_Group_Master_ID=URBM.I_User_Group_Master_ID  
 where URBM.I_User_Group_Master_ID=ISNULL(@iUserGroupID,UGM.I_User_Group_Master_ID) and UGM.I_Brand_ID=@iBrandID  
 and URBM.Is_Active=1 and UGM.Is_Active=1  
END  