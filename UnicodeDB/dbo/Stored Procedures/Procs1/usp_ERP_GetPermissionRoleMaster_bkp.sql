-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetPermissionRoleMaster_bkp]
	-- Add the parameters for the stored procedure here
	@iBrandID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		select DISTINCT
		RM.I_Role_ID as RoleID,
		ISNULL(RM.Role_Group,'Others') RoleGroup,
		ISNULL(RM.S_Role_Code,'NA') RoleCode,
		ISNULL(RM.S_Role_Desc,'NA') as RoleDesc
		from 
		T_ERP_Role_Master_bkp as RM
		inner join
		T_ERP_Permission_Role_Map as RPRM on RM.I_Role_ID=RPRM.I_Role_ID
		inner join
		T_ERP_Permission as EP on RPRM.I_Permission_ID=EP.I_Permission_ID
		where RM.I_Status=1 and RPRM.I_Status=1 and EP.I_Status=1
		and RM.I_Brand_ID=1

END
