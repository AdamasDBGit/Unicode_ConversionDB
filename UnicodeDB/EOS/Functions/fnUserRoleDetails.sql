/*******************************************************************************************************
* Author		: Sandeep Acharyya
* Create date	: 14/06/2007
* Description	: This Function returns the Roles for User in a comma seperated format
* Return		: EProjectSpecID Integer
*******************************************************************************************************/
CREATE FUNCTION [EOS].[fnUserRoleDetails]
(
	@iUserID INT
)
RETURNS VARCHAR(1000)

AS
BEGIN
	DECLARE @sUserRoles VARCHAR(1000)
	SET @sUserRoles = ''
	SELECT @sUserRoles = @sUserRoles + ',' + CONVERT(VARCHAR,I_Role_ID) FROM dbo.T_User_Role_Details
		WHERE I_User_ID = @iUserID

	IF (LEN(@sUserRoles) > 0)
	BEGIN
		SET @sUserRoles = @sUserRoles + ','
	END
	 
	RETURN @sUserRoles
END