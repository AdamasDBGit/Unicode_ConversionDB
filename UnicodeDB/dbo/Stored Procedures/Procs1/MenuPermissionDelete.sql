CREATE PROCEDURE [dbo].[MenuPermissionDelete] 
-- =============================================
     -- Author:	Tridip Chatterjee
-- Create date:  22-09-2023 
-- Description:	Delete Menu Permission
-- =============================================
-- Add the parameters for the stored procedure here
@MenuID int,
@PermissionName Nnvarchar(max)



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
SET NOCOUNT ON;
    Declare @M int , @P nvarchar(max)
	set @M= (Select distinct I_Menu_ID from T_ERP_Menu_Permission where I_Menu_ID=@MenuID)
	set @P= (Select distinct S_Permission_Name from T_ERP_Menu_Permission where S_Permission_Name
	                                                                       =@PermissionName)
    IF @MenuID=@M And @PermissionName=@P  

    delete from T_ERP_Menu_Permission where I_Menu_ID=@M and S_Permission_Name=@P
	If @@ROWCOUNT !=0
	select 1,'Menu Permission Deleted Successfully' Message 
	else 
	    select 1,'Menu Permission not Exsist' Message 



END

