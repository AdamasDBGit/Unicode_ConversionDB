/*******************************************************************************************************
* Author		: Sandeep Acharyya
* Create date	: 14/06/2007
* Description	: This Function returns the Roles for an Employee in a comma seperated format
* Return		: EProjectSpecID Integer
*******************************************************************************************************/
CREATE FUNCTION [EOS].[fnEmployeeRoleDetails]
(
	@iEmployeeID INT
)
RETURNS VARCHAR(1000)

AS
BEGIN
	DECLARE @sEmployeeRoles VARCHAR(1000)
	SET @sEmployeeRoles = ''
	SELECT @sEmployeeRoles = @sEmployeeRoles + ',' + CONVERT(VARCHAR,I_Role_ID) FROM EOS.T_Employee_Role_Map
		WHERE I_Employee_ID = @iEmployeeID

	IF (LEN(@sEmployeeRoles) > 0)
	BEGIN
		SET @sEmployeeRoles = @sEmployeeRoles + ','
	END
	 
	RETURN @sEmployeeRoles
END