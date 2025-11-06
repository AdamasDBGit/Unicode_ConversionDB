CREATE PROCEDURE [dbo].[RoleMenuPermissionMapping] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date: 26-09-2023
-- Description:	To Map Role with Menu Permission 
-- =============================================
-- Add the parameters for the stored procedure here
@RoleID int,
@MenuPermisssionID int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
    Declare @C int,@R int ,@MP int
	---**** Validating The Role & Pemission from Role Permission Table *******----
	set @C = (select COUNT(*) from T_ERP_Role_Permission where I_Role_ID=@RoleID and 
	                                              I_Menu_Permission_ID=@MenuPermisssionID)
    
	---**** Validating Permission from Menu Permission Table*****---
	set @MP= (Select COUNT(*) from T_ERP_Menu_Permission where I_Menu_Permission_ID=@MenuPermisssionID)
	
	---**** Validating Role from Role Table*****---
	Set @R=(Select COUNT(*) from T_ERP_Role where I_Role_ID=@RoleID)

	If  (@C =0 and @MP>0 and @R>0)
	begin
	 Insert into T_ERP_Role_Permission (I_Role_ID,I_Menu_Permission_ID)
	 values (@RoleID,@MenuPermisssionID)
	 select 1 No,'Permission Added Successfully' Message
	 
    end 
	If (@C>0 and @MP>0 and @R>0)
	begin 

	Delete from T_ERP_Role_Permission where I_Role_ID=@RoleID and 
	                                              I_Menu_Permission_ID=@MenuPermisssionID
	select 1 No,'Permission Deleted Successfully' Message
	end 

	if @R=0
	begin
	select 1 No,'Role Not Present' Message
	
	end

	if @MP=0
	begin 
	select 1 No,'Permission Not Present' Message
	
	end

END
