-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[usp_ERP_getRoleAddPermisionDetails]
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_getRoleAddPermisionDetails]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from T_ERP_Menu

	SELECT TEM.I_Menu_ID AS MenuID,
	TEM.S_Code AS SCode,
	TEM.S_Name AS SName,
	TEMP.I_Menu_Permission_ID AS MenuPermissionID,
	TEMP.S_Permission_Name AS PermissionName,
	TERP.I_Role_ID AS RoleID,
	TERP.I_Role_Permission_ID AS RolePermissionID,
	case when ISNULL(TERP.I_Role_ID,0)=0 then 0
	else 1 
	end IsSelected
	FROM T_ERP_Menu TEM
	inner join T_ERP_Menu_Permission TEMP ON TEMP.I_Menu_ID = TEM.I_Menu_ID
	left join T_ERP_Role_Permission TERP ON TERP.I_Menu_Permission_ID = TEMP.I_Menu_Permission_ID
END
