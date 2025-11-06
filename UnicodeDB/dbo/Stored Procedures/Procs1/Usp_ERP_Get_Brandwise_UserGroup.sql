CREATE Proc [dbo].[Usp_ERP_Get_Brandwise_UserGroup](
@BrandID int
)
as begin
Select
I_User_Group_Master_ID as UserGroupID,
S_User_GroupName as UserGroupName,
S_Code as UserGroupCode 
from T_ERP_User_Group_Master where I_Brand_ID=@BrandID
and Is_Active=1
End
