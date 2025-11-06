
/**************************************************************************************************************
Created by  : Swagata De
Date		: 13.05.2007
Description : This SP will validate the login for access to offline examination system
Parameters  : Login ID,Password
Returns     : Dataset
exec [dbo].[uspValidateOTP] '9609492010',6575
**************************************************************************************************************/

CREATE PROCEDURE [dbo].[usp_ERP_MobileLogout]
	(
		@sMobile NVARCHAR(200),	
		@Type int null
	)
AS
BEGIN
    if exists(select * from T_Parent_Master where S_Mobile_No=@sMobile)
	BEGIN
	update T_Parent_Master set I_IsTokenActive=0 where S_Mobile_No=@sMobile
	select 1 as StatusFlag,'Logout success' as StatusMessage
	END
	ELSE
	BEGIN
	select 1 as StatusFlag,'Number not exist!' as StatusMessage
	END

END
