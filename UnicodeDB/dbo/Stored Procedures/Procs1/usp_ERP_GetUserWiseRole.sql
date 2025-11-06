-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <18th September,2023>
-- Description:	<to get the details of class group>
--exec [dbo].[usp_ERP_GetClassGroup] 107,1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetUserWiseRole]
	-- Add the parameters for the stored procedure here
	@iUserId int
	
AS
BEGIN
	select 
	I_User_ID UserID, 
	S_First_Name+' '+ S_Middle_Name + ' '+S_Last_Name UserName
	from T_ERP_User where I_User_ID =@iUserId

	select I_Role_ID RoleID from T_ERP_User_Role where I_User_ID = @iUserId
	
END
