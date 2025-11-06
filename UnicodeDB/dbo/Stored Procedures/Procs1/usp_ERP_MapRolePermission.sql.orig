-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-April-18>
-- Description:	<Map Role-Permission>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_ERP_MapRolePermission]
	-- Add the parameters for the stored procedure here
	@iPermissionID INT,
	@sRoleName varchar(max),
	@sRoleDesc varchar(max)=NULL,
	@iBrandID INT,
	@iCreatedBy INT
AS
BEGIN

DECLARE @iRoleId INT
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	DECLARE @parentPermissionID INT = NULL

	select @parentPermissionID=I_Parent_Menu_ID from T_ERP_Permission where I_Permission_ID=@iPermissionID

	IF NOT EXISTS(select * from T_ERP_Role_Master where S_Role_Code=@sRoleName and I_Brand_ID=@iBrandID)
		BEGIN
			INSERT INTO T_ERP_Role_Master 
			(S_Role_Code, S_Role_Desc, I_Status, S_Crtd_By, Dt_Crtd_On, I_Brand_ID)
			VALUES (@sRoleName,@sRoleDesc,1,@iCreatedBy,GETDATE(),@iBrandID); 

			SET @iRoleId = SCOPE_IDENTITY();

		END
	ELSE
		BEGIN
		select @iRoleId=I_Role_ID from T_ERP_Role_Master where S_Role_Code=@sRoleName and I_Brand_ID=@iBrandID
		END


	IF NOT EXISTS(select * from T_ERP_Permission_Role_Map where I_Permission_ID=@iPermissionID AND I_Role_ID=@iRoleId)
		BEGIN
			INSERT INTO T_ERP_Permission_Role_Map (I_Role_ID, I_Permission_ID, I_Status, I_CreatedBy, Dt_CreatedDt)
			values (@iRoleId,@iPermissionID,1,@iCreatedBy,GETDATE())

		END

print @parentPermissionID

	IF @parentPermissionID IS NOT NULL 
	AND NOT EXISTS(select * from T_ERP_Permission_Role_Map where I_Permission_ID=@parentPermissionID and I_Role_ID=@iRoleId)
		BEGIN
		print @parentPermissionID
			INSERT INTO T_ERP_Permission_Role_Map (I_Role_ID, I_Permission_ID, I_Status, I_CreatedBy, Dt_CreatedDt)
			values (@iRoleId,@parentPermissionID,1,@iCreatedBy,GETDATE())

		END


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
		select Distinct new.I_User_Id,new.RoleID,new.Permission_ID,new.User_GroupID,new.BrandID,1,@iCreatedBy,GETDATE()  from
(select Distinct Users.I_User_Id,Users.Role_Id as RoleID,PRM.I_Permission_ID as Permission_ID,
Users.User_Group_ID as User_GroupID,@iBrandID as BrandID from 
(select I_User_Id,Role_Id,User_Group_ID from T_ERP_Users_Role_Permission_Map where Role_Id=@iRoleId and Is_Active=1 and Brand_ID=@iBrandID) as Users
 inner join
 (select I_Role_ID,I_User_Group_Master_ID from T_ERP_UserGroup_Role_Brand_Map where Is_Active=1 and I_Brand_ID=@iBrandID) 
 as UsergroupRole on Users.Role_Id=UsergroupRole.I_Role_ID and UsergroupRole.I_User_Group_Master_ID=Users.User_Group_ID
 inner join
 (select I_Role_ID,I_Permission_ID from T_ERP_Permission_Role_Map where I_Status=1) as PRM on PRM.I_Role_ID=Users.Role_Id
 where Users.Role_Id=@iRoleId
 ) as new
 left join
 T_ERP_Users_Role_Permission_Map as URP on URP.I_User_Id=new.I_User_Id and URP.Role_Id=new.RoleID 
 and URP.Permission_ID=new.Permission_ID and URP.User_Group_ID=new.User_GroupID and Brand_ID=@iBrandID
 where URP.I_User_Id IS NULL


END
