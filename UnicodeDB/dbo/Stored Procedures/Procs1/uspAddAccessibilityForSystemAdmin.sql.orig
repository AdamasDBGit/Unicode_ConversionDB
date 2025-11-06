CREATE PROCEDURE [dbo].[uspAddAccessibilityForSystemAdmin] 
(
	@iHierarchyDetailID int,
	@sLoginID varchar(200)
)

AS
SET NOCOUNT OFF

DECLARE @iHierarchyMasterID int 
DECLARE @iUserID int

BEGIN TRY
	
	SELECT @iHierarchyMasterID = I_Hierarchy_Master_ID
	FROM dbo.T_Hierarchy_Details
	WHERE I_Hierarchy_Detail_ID = @iHierarchyDetailID
	
	SELECT @iUserID = I_User_ID
	FROM dbo.T_User_Master
	WHERE S_Login_ID = @sLoginID
	
	BEGIN TRANSACTION
	IF EXISTS(SELECT I_User_Hierarchy_Detail_ID FROM dbo.T_User_Hierarchy_Details
				WHERE I_Hierarchy_Master_ID = @iHierarchyMasterID
				AND I_User_ID = @iUserID)
	BEGIN
		UPDATE dbo.T_User_Hierarchy_Details
		SET Dt_Valid_To = GETDATE(),
		I_Status = 0
		WHERE I_User_ID = @iUserID
		AND	I_Hierarchy_Master_ID = @iHierarchyMasterID
		AND I_Status = 1
	END

	INSERT INTO dbo.T_User_Hierarchy_Details
	( I_User_Id,
	  I_Hierarchy_Master_ID,
	  I_Hierarchy_Detail_ID,
	  Dt_Valid_From,
	  I_Status
	)
	VALUES
	(   @iUserID,
		@iHierarchyMasterID,
		@iHierarchyDetailID,
		GETDATE(),
		1
	)
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
