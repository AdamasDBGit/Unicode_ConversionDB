/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateUserWiseRoleMapping] 
(
	@iuserID int,
	@Roles UT_Recipient readonly

	--@UtRecipient UT_Recipient readonly
)
AS
begin transaction
BEGIN TRY 
delete from T_ERP_User_Role where I_User_ID = @iuserID
insert T_ERP_User_Role 
(
I_Role_ID,
I_User_ID
)
select Recipient,@iuserID from @Roles


SELECT 1 StatusFlag,'Role mapping done ' Message
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
