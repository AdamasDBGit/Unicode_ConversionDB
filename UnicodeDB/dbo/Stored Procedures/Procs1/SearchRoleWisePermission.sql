CREATE PROCEDURE [dbo].[SearchRoleWisePermission] 
-- =============================================
     -- Author: Tridip Chatterjee
-- Create date: 23-09-2023
-- Description:	To Show Role Wise Menu Permisssion 
-- =============================================
-- Add the parameters for the stored procedure here
@RoleID int=null,
@MenuPermissionID int=null


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	
---*** D is nothing but a veriable to store 0 or 1 to checking for validation*****----	
	declare @D int
	
	set @D=(
	
	select COUNT(*)
    
	from 
    T_ERP_Role_Permission TERP 
    left join T_Erp_Role TER on 
    TER.I_Role_ID=TERP.I_Role_ID
    left join T_ERP_Menu_Permission TEMP ON 
    TEMP.I_Menu_Permission_ID=TERP.I_Menu_Permission_ID
    Where 
	(TERP.I_Role_ID=@RoleID or @RoleID is null) and 
    (TERP.I_Menu_Permission_ID=@MenuPermissionID or @MenuPermissionID is null) 
	)
    
	
	If @D =0
	begin
	Select 1,'No Reasut Found'message
	end

	if @D>0
	
	select 
    TERP.I_Menu_Permission_ID As Pemission_ID,
    TEMP.S_Permission_Name AS Permission_Name,
    TEMP.I_Status as Permission_Status,
    TERP.I_Role_ID As Role_ID,
    TER.S_Role_Name as Role_Name,
    TER.I_Status As Role_Status

    from 
    T_ERP_Role_Permission TERP 
    left join T_Erp_Role TER on 
    TER.I_Role_ID=TERP.I_Role_ID
    left join T_ERP_Menu_Permission TEMP ON 
    TEMP.I_Menu_Permission_ID=TERP.I_Menu_Permission_ID
    Where 
	(TERP.I_Role_ID=@RoleID or @RoleID is null) and 
    (TERP.I_Menu_Permission_ID=@MenuPermissionID or @MenuPermissionID is null) 


END
