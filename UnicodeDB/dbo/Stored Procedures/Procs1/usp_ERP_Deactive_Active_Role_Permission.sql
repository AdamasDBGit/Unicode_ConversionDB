-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Aug-23>
-- Description:	<Deactive the role -permission>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Deactive_Active_Role_Permission]
	-- Add the parameters for the stored procedure here
	 @iPermissionID INT,  
	 @sRoleName NVARCHAR(MAX),
	 @IsActive bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
	update PRM set PRM.I_Status=@IsActive
	from 
	T_ERP_Permission_Role_Map as PRM
	inner join
	T_ERP_Role_Master as RM on RM.I_Role_ID=PRM.I_Role_ID
	where RM.S_Role_Code=@sRoleName and PRM.I_Permission_ID=@iPermissionID

	update URPM set URPM.Is_Active=@IsActive
	from 
	T_ERP_Users_Role_Permission_Map as URPM
	inner join
	T_ERP_Role_Master as RM on RM.I_Role_ID=URPM.Role_Id
	where RM.S_Role_Code=@sRoleName and URPM.Permission_ID=@iPermissionID

END

