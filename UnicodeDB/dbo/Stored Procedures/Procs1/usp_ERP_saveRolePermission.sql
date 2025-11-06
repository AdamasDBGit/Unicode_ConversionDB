-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_saveRolePermission]
	-- Add the parameters for the stored procedure here
	@I_Role_ID INT = NULL,
	@UTRolePermission [UT_RolePermission] readonly
AS
BEGIN
		BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
       SET NOCOUNT ON;

	   --DECLARE @RoleID INT;

	   --SET @RoleID  = (SELECT TOP 1 I_Role_ID FROM @UTRolePermission);

	   BEGIN TRANSACTION;

	   IF EXISTS (SELECT I_Role_ID FROM T_ERP_Role_Permission WHERE I_Role_ID = @I_Role_ID)
	   BEGIN
			DELETE FROM T_ERP_Role_Permission WHERE I_Role_ID = @I_Role_ID;
	   END

	   INSERT INTO T_ERP_Role_Permission
	   (
		   I_Role_ID,
		   I_Menu_Permission_ID
	   )
	   SELECT I_Role_ID, I_Menu_Permission_ID FROM  @UTRolePermission;

	   SELECT 1 AS statusFlag, 'Permission added successfully' AS Message

	END TRY
	BEGIN CATCH  
		Rollback Transaction;

		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		SELECT 0 StatusFlag,@ErrMsg Message		          
	END CATCH; 

	COMMIT TRANSACTION;
END
