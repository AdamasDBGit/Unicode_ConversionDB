/**************************************************************************************************************
Created by  : Swagata De
Date		: 13.05.2007
Description : This SP will validate the login for access to offline examination system
Parameters  : Login ID,Password
Returns     : Dataset
exec [dbo].[uspValidateOTP] '9609492010',6048
**************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspParentTokenValidate]
	(
		@sToken NVARCHAR(200)	
	)
AS
BEGIN
	IF EXISTS (select * from T_Parent_Master where S_Token = @sToken and I_IsTokenActive=1)
	BEGIN
	SELECT 
	I_Parent_Master_ID ID,
	S_Token Token,
	I_Brand_ID BrandID,
	1 StatusFlag,
	'Valid Token' Message
	from T_Parent_Master where S_Token = @sToken
	END
	else
	BEGIN
	select 0 StatusFlag,'Invalid Token' Message
	END


END
