-- =============================================
-- Author:		Swagata De
-- Create date: 01/03/2007
-- Description:	Adds all the role details for a particular user
-- =============================================
CREATE PROCEDURE [dbo].[uspAddRoleToUser] 
(
	@iUserID int,	
	@sRoleIDList varchar(500),
	@sCrtdBy varchar(20),
	@dCrtdOn datetime
)

AS
SET NOCOUNT OFF
BEGIN TRY 


DELETE FROM dbo.T_User_Role_Details
WHERE I_User_ID = @iUserID

DELETE FROM T_User_Hierarchy_Details
	WHERE I_User_ID = @iUserID
	AND I_Hierarchy_Master_ID = 1


DECLARE @iRoleID int
DECLARE @iGetIndex int
DECLARE @sTransactionID varchar(20)
DECLARE @iLength int

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

		INSERT INTO T_User_Hierarchy_Details
		(I_User_ID,I_Hierarchy_Master_ID,I_Hierarchy_Detail_ID,Dt_Valid_From,I_Status)
		SELECT @iUserID,HD.I_Hierarchy_Master_ID,HD.I_Hierarchy_Detail_ID,@dCrtdOn,1
			FROM T_Hierarchy_Details HD
			INNER JOIN T_Role_Master RM 
			ON HD.I_Hierarchy_Detail_ID = RM.I_Hierarchy_Detail_ID
			WHERE I_Role_ID = @iRoleID			
		
		SELECT @sRoleIDList = SUBSTRING(@sRoleIDList,@iGetIndex + 1, @iLength - @iGetIndex)
		SELECT @sRoleIDList = LTRIM(RTRIM(@sRoleIDList))

	END

END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
