-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 27/12/2006
-- Description:	Adds all the transaction for the Role
-- =============================================
CREATE PROCEDURE [dbo].[uspAddTransactionsToRole] 
(
	@iRoleID int,
	@iMenuGroupID int,
	@sTransactionList varchar(500),
	@sTransactionBy varchar(20),
	@dTransactionOn datetime
)

AS
SET NOCOUNT OFF
BEGIN TRY

DECLARE @iTransactionID int
DECLARE @iGetIndex int
DECLARE @sTransactionID varchar(20)
DECLARE @iLength int

BEGIN TRANSACTION
DELETE FROM dbo.T_Role_Transaction
WHERE I_Role_ID = @iRoleID
AND I_Transaction_ID IN
(SELECT I_Transaction_ID 
FROM dbo.T_Transaction_Master
WHERE I_Menu_Group_ID = @iMenuGroupID)

SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sTransactionList)),1)

IF @iGetIndex > 1
BEGIN
	WHILE LEN(@sTransactionList) > 0
	BEGIN
		SET @iGetIndex = CHARINDEX(',',@sTransactionList,1)
		SET @iLength = LEN(@sTransactionList)
		SET @iTransactionID = CAST(LTRIM(RTRIM(LEFT(@sTransactionList,@iGetIndex-1))) AS int)

		INSERT INTO T_Role_Transaction
		( I_Transaction_ID, 
		  I_Role_ID, 
		  I_Status, 
		  S_Crtd_By, 
		  Dt_Crtd_On )
		VALUES
		( @iTransactionID, 
		  @iRoleID, 
		  1, 
		  @sTransactionBy, 
		  @dTransactionOn )
		
		SELECT @sTransactionList = SUBSTRING(@sTransactionList,@iGetIndex + 1, @iLength - @iGetIndex)
		SELECT @sTransactionList = LTRIM(RTRIM(@sTransactionList))

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
