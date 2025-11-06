CREATE Proc [dbo].[ERP_Usp_Get_Roles_Brandwise](@brandid int)
As 
Begin
Select I_Role_ID as RoleID ,S_Role_Code as RoleCode,S_Role_Desc as RoleName from T_Role_Master where I_Brand_ID=@brandid
and I_Status=1
End
