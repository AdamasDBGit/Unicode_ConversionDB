CREATE FUNCTION [dbo].[ufnIsRoleMapped]
(
	@iRoleID INT
)
RETURNS INT

AS
BEGIN

DECLARE @iResult INT
SET @iResult=1
	
	IF EXISTS(SELECT 1 FROM dbo.T_Role_Transaction WHERE I_Role_ID = @iRoleID AND I_Status <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM dbo.T_User_Role_Details WHERE I_Role_ID = @iRoleID AND I_Status <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Employee_Role_Map WHERE I_Role_ID = @iRoleID AND I_Status_ID <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Employee_Role_Map_Audit WHERE I_Role_ID = @iRoleID AND I_Status_ID <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Role_Assessor WHERE I_Role_ID = @iRoleID)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Role_KRA_Map WHERE I_Role_ID = @iRoleID AND I_Status <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Role_KRA_SubKRA WHERE I_Role_ID = @iRoleID AND I_Status <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Role_Skill_Map WHERE I_Role_ID = @iRoleID AND I_Status <> 0)
	BEGIN
		SET @iResult=0
	END
	IF EXISTS(SELECT 1 FROM EOS.T_Role_Skill_Map_Audit WHERE I_Role_ID = @iRoleID AND I_Status <> 0)
	BEGIN
		SET @iResult=0
	END

RETURN @iResult

END