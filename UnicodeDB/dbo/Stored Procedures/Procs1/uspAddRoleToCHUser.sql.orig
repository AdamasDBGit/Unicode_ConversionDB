-- =============================================
-- Author:		Soumya Sikder
-- Create date: 08/02/2008
-- Description:	Adds all the role details for a particular CH user
-- =============================================
CREATE PROCEDURE [dbo].[uspAddRoleToCHUser] 
(
	@iUserID int,	
	@sRoleIDList varchar(500),
	@sCrtdBy varchar(20),
	@dCrtdOn datetime
)
 
AS
SET NOCOUNT OFF
BEGIN TRY 

BEGIN TRANSACTION
DELETE FROM dbo.T_User_Role_Details
WHERE I_User_ID = @iUserID

DECLARE @iEmployeeID int
DECLARE @iRoleID int
DECLARE @iGetIndex int
DECLARE @sTransactionID varchar(20)
DECLARE @iLength int

SET @iEmployeeID = (SELECT I_Reference_ID FROM T_User_Master WHERE I_User_ID = @iUserID)
SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sRoleIDList)),1)

IF @iGetIndex > 1
BEGIN
	WHILE LEN(@sRoleIDList) > 0
	BEGIN
		SET @iGetIndex = CHARINDEX(',',@sRoleIDList,1)
		SET @iLength = LEN(@sRoleIDList)
		SET @iRoleID = CAST(LTRIM(RTRIM(LEFT(@sRoleIDList,@iGetIndex-1))) AS int)

		INSERT INTO T_User_Role_Details
		( I_Role_ID, 
		  I_User_ID,
		  I_Status, 
		  S_Crtd_By, 
		  Dt_Crtd_On )
		VALUES
		( @iRoleID, 
		  @iUserID, 
		  1, 
		  @sCrtdBy, 
		  @dCrtdOn )
		  
		  INSERT INTO EOS.T_Employee_Role_Map
		  ( I_Employee_ID,
			I_Role_ID,
			I_Status_ID,
			Dt_Valid_From,
			Dt_Valid_To,
			S_Crtd_By,
			Dt_Crtd_On
		  )
		  VALUES
		  ( @iEmployeeID,
			@iRoleID,
			1,
			@dCrtdOn,
			NULL,
			@sCrtdBy,
			@dCrtdOn
		  )
		
		SELECT @sRoleIDList = SUBSTRING(@sRoleIDList,@iGetIndex + 1, @iLength - @iGetIndex)
		SELECT @sRoleIDList = LTRIM(RTRIM(@sRoleIDList))

	END

END
COMMIT TRANSACTION
END TRY

BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
