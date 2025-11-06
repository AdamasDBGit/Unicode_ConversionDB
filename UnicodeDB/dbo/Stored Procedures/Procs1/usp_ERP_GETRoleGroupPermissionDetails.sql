
-- =============================================
-- Author:		<Susmita >
-- Create date: <2024-April-18>
-- Description:	<Get Role-Group-permission>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GETRoleGroupPermissionDetails]
	-- Add the parameters for the stored procedure here
	@iBrandID INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select UGM.I_User_Group_Master_ID as UserGroupID,
	UGM.S_User_GroupName as UserGroupName,
	ISNULL(UGM.S_Code,'NA') as UserGroupCode,
	UGM.Is_Active as IsGroupActive,
	RM.I_Role_ID as RoleID 
,RM.S_Role_Code RoleCode,
EP.S_Name as permissionName,
EP.Description  as Menuname,
EP.Permission_Type as PermissionType,
EP.RequestType,
EP.S_PageUrl PageURL

from T_ERP_Role_Master as RM 
inner join
T_ERP_UserGroup_Role_Brand_Map as EUBM on RM.I_Role_ID=EUBM.I_Role_ID
inner join
T_ERP_User_Group_Master as UGM on EUBM.I_User_Group_Master_ID=UGM.I_User_Group_Master_ID
inner join
T_ERP_Permission_Role_Map as PRM on PRM.I_Role_ID=RM.I_Role_ID
inner join
T_ERP_Permission as EP on EP.I_Permission_ID=PRM.I_Permission_ID
where S_Role_Code != 'ACADEMIC_HEAD' and RM.I_Status=1 and EUBM.Is_Active=1 and UGM.Is_Active=1
and PRM.I_Status=1 and EP.I_Status=1
and UGM.I_Brand_ID = ISNULL(@iBrandID,UGM.I_Brand_ID)
END
