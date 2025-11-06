CREATE PROCEDURE [dbo].[uspGetUserRoleDetails] 

-- Add the parameters for the stored procedure here

	@iUserID INT

AS
BEGIN

	
	--Select USERRDTL.I_Role_ID,ROLEMST.S_Role_Code  from dbo.T_User_Role_Details USERRDTL
	--inner join dbo.T_Role_Master ROLEMST
	--on USERRDTL.I_Role_ID=ROLEMST.I_Role_ID 
	Select USERRDTL.I_Role_ID,ROLEMST.S_Role_Code,USERMST.S_Email_ID,USERMST.S_First_Name,USERMST.S_Login_ID from dbo.T_User_Role_Details USERRDTL
    INNER JOIN  dbo.T_User_Master USERMST
    ON USERRDTL.I_User_ID= USERMST.I_User_ID
	inner join dbo.T_Role_Master ROLEMST
	on USERRDTL.I_Role_ID=ROLEMST.I_Role_ID 
	WHERE USERRDTL.I_User_ID = @iUserID
	AND USERRDTL.I_Status <> 0
	

END
