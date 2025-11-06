-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-April-22>
-- Description:	<User Group and Role Added>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_UserGroup_Role_Map] 
	-- Add the parameters for the stored procedure here
	@iUserGroupID INT,
	@iRoleIds NVARCHAR(MAX),
	@iBrandID INT,
	@CreatedBy int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SET NOCOUNT ON;
	 -- Create a temporary table to hold the split roles
    CREATE TABLE #SplitRoles (RoleID INT)
	DECLARE @RoleID INT

    -- Split the input string and insert into the temporary table
    INSERT INTO #SplitRoles (RoleID)
    SELECT CAST(Val as int) as RoleID  FROM dbo.fnString2Rows(@iRoleIds, ',')



	--IF NOT Exists (select * from T_ERP_Users_Role_Permission_Map 
	--where User_Group_ID=@iUserGroupID and Is_Active='true')

	--BEGIN

	update URB set URB.Is_Active=0 from
	T_ERP_UserGroup_Role_Brand_Map as URB 
	left join
	#SplitRoles as r on URB.I_Role_ID=r.RoleID
	where URB.I_User_Group_Master_ID=@iUserGroupID and r.RoleID IS NULL and I_Brand_ID=@iBrandID


	--select * from T_ERP_UserGroup_Role_Brand_Map as URB 
	--left join
	--#SplitRoles as r on URB.I_Role_ID=r.RoleID
	--where URB.I_User_Group_Master_ID=@iUserGroupID and r.RoleID IS NULL

	insert into T_ERP_UserGroup_Role_Brand_Map
	(
	I_User_Group_Master_ID,
	I_Role_ID,
	I_Brand_ID,
	Is_Active,
	I_Created_By,
	Dt_created_Dt
	)
	select @iUserGroupID as I_User_Group_Master_ID
	,RoleID as I_Role_ID,@iBrandID as I_Brand_ID,1 as Is_Active,@CreatedBy as I_Created_By,GETDATE() as Dt_created_Dt from 
	#SplitRoles as SR
	inner join
	T_ERP_Role_Master as ERM on SR.RoleID=ERM.I_Role_ID and ERM.I_Status=1 and ERM.I_Brand_ID=@iBrandID
	left join
	T_ERP_UserGroup_Role_Brand_Map as URB on SR.RoleID=URB.I_Role_ID and URB.I_Brand_ID=@iBrandID and URB.I_User_Group_Master_ID=@iUserGroupID 
	where URB.I_Role_ID IS NULL

	
	--select @iUserGroupID,RoleID,@iBrandID,1,@CreatedBy,GETDATE() from 
	--#SplitRoles as SR
	--left join
	--T_ERP_UserGroup_Role_Brand_Map as URB on SR.RoleID=URB.I_Role_ID and URB.I_Brand_ID=@iBrandID and URB.I_User_Group_Master_ID=@iUserGroupID 
	--where URB.I_Role_ID IS NULL



	update URB set URB.Is_Active=1 from
	#SplitRoles as SR
	inner join
	T_ERP_UserGroup_Role_Brand_Map as URB on SR.RoleID=URB.I_Role_ID and URB.I_Brand_ID=@iBrandID and URB.I_User_Group_Master_ID=@iUserGroupID 
	where SR.RoleID IS NOT NULL and  URB.I_Brand_ID=@iBrandID
	


	update EYRPM set EYRPM.Is_Active=0 from
	T_ERP_Users_Role_Permission_Map as EYRPM 
	left join
	#SplitRoles as r on EYRPM.Role_Id=r.RoleID
	where EYRPM.User_Group_ID=@iUserGroupID and r.RoleID IS NULL and EYRPM.Brand_ID=@iBrandID 


	update EYRPM set EYRPM.Is_Active=1 from
	T_ERP_Users_Role_Permission_Map as EYRPM 
	inner join
	#SplitRoles as r on EYRPM.Role_Id=r.RoleID
	inner join
	T_ERP_User as EU on EU.I_User_ID= EYRPM.I_User_Id and EU.I_Status=1
	inner join 
	T_ERP_Permission_Role_Map as PRM on PRM.I_Status=1 and PRM.I_Role_ID=EYRPM.Role_Id
	inner join
	T_ERP_Permission as EP on EP.I_Permission_ID=EYRPM.Permission_ID and EP.I_Status=1
	inner join
	T_ERP_UserGroup_Role_Brand_Map as URBM 
	on URBM.I_Role_ID=EYRPM.Role_Id and URBM.I_User_Group_Master_ID=EYRPM.User_Group_ID and URBM.Is_Active=1
	where EYRPM.User_Group_ID=@iUserGroupID and r.RoleID IS NOT NULL and EYRPM.Brand_ID=@iBrandID


	insert into T_ERP_Users_Role_Permission_Map
		(
		I_User_Id,
		Role_Id,
		Permission_ID,
		User_Group_ID,
		Brand_ID,
		Is_Active,
		I_Created_By,
		dt_Created_Dt
		)
	select Distinct new.I_User_Id,new.RoleID,new.Permission_ID,new.User_GroupID,new.BrandID,1,@CreatedBy,GETDATE() from
(select Distinct EU.I_User_Id,UsergroupRole.I_Role_ID as RoleID,PRM.I_Permission_ID as Permission_ID,
UsergroupRole.I_User_Group_Master_ID as User_GroupID,@iBrandID as BrandID from 

 (select I_Role_ID,I_User_Group_Master_ID from T_ERP_UserGroup_Role_Brand_Map where Is_Active=1 and I_User_Group_Master_ID=@iUserGroupID) 
 as UsergroupRole 
 inner join
 (select I_Role_ID,I_Permission_ID from T_ERP_Permission_Role_Map as PRM where I_Status=1)as PRM 
 on PRM.I_Role_ID=UsergroupRole.I_Role_ID 
 inner join
 T_ERP_Users_Role_Permission_Map as URP on URP.User_Group_ID=UsergroupRole.I_User_Group_Master_ID and Is_Active=1 and Brand_ID=@iBrandID
 inner join
 T_ERP_User as EU on EU.I_User_ID=URP.I_User_Id and EU.I_Status=1
 inner join
 T_ERP_User_Brand as EUB on EU.I_User_ID=EUB.I_User_ID and EUB.I_Brand_ID=@iBrandID
 inner join
 #SplitRoles as roles on roles.RoleID=UsergroupRole.I_Role_ID
 where UsergroupRole.I_User_Group_Master_ID=@iUserGroupID) as new
 left join
 T_ERP_Users_Role_Permission_Map as URP on URP.I_User_Id=new.I_User_Id and URP.Role_Id=new.RoleID 
 and URP.Permission_ID=new.Permission_ID and URP.User_Group_ID=new.User_GroupID and URP.Brand_ID=@iBrandID and Is_Active=1
 where URP.I_User_Id IS NULL


	--select * from #SplitRoles as SR
	--inner join
	--T_ERP_UserGroup_Role_Brand_Map as URB on SR.RoleID=URB.I_Role_ID and URB.I_Brand_ID=@iBrandID and URB.I_User_Group_Master_ID=@iUserGroupID 
	--where SR.RoleID IS NOT NULL

	select  1 as StatusFlag ,'User Group Role Mapping done sucessfully' as Message



	--END
	--ELSE
	--BEGIN
	--	select  0 as StatusFlag ,'Invalid!User Exists' as Message
	--END



    
END

