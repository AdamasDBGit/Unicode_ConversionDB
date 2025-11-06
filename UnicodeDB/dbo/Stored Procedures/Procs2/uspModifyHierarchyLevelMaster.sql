CREATE PROCEDURE [dbo].[uspModifyHierarchyLevelMaster] 
(
	@iHierarchyLevelID int = null,
	@iHierarchyMasterID int,
	@sHierarchyLevelCode NVARCHAR(max) = null,
	@sHierarchyLevelName NVARCHAR(max) = null,
	@iIsLastNode int,
	@iSequence int,
    @sHierarchyLevelBy NVARCHAR(max),
	@dHierarchyLevelOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	DECLARE @sErrorCode nvarchar(max)

    IF @iFlag = 1
	BEGIN
		BEGIN TRAN T1
			INSERT INTO dbo.T_Hierarchy_Level_Master
			( I_Hierarchy_Master_ID,
			  S_Hierarchy_Level_Code, 
			  S_Hierarchy_Level_Name, 
			  I_Is_Last_Node,
			  I_Status, 
			  I_Sequence,
			  S_Crtd_By, 
			  Dt_Crtd_On )
			VALUES
			( @iHierarchyMasterID, 
			  @sHierarchyLevelCode,
			  @sHierarchyLevelName, 
			  @iIsLastNode,
			  1, 
			  @iSequence,
			  @sHierarchyLevelBy, 
			  @dHierarchyLevelOn )
			  
			SET @iHierarchyLevelID = @@IDENTITY
		COMMIT TRAN T1		      
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Hierarchy_Level_Master
		SET S_Hierarchy_Level_Code = @sHierarchyLevelCode,
		S_Hierarchy_Level_Name = @sHierarchyLevelName,
		S_Upd_By = @sHierarchyLevelBy,
		Dt_Upd_On = @dHierarchyLevelOn
		WHERE I_Hierarchy_Level_Id = @iHierarchyLevelID
	END
	ELSE IF @iFlag = 3
	BEGIN
		IF EXISTS(SELECT I_Hierarchy_Detail_ID FROM dbo.T_Hierarchy_Details
			WHERE I_Hierarchy_Level_Id = @iHierarchyLevelID
			AND I_Status = 1)
		BEGIN
			SET @sErrorCode = 'SA_100003'
		END
		ELSE
		BEGIN
			UPDATE dbo.T_Hierarchy_Level_Master
			SET I_Status = 0,
			S_Upd_By = @sHierarchyLevelBy,
			Dt_Upd_On = @dHierarchyLevelOn
			WHERE I_Hierarchy_Level_Id = @iHierarchyLevelID
		END
	END

	SELECT @sErrorCode AS ERROR, @iHierarchyLevelID AS HierarchyLevelMasterID
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH


