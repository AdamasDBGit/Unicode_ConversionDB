CREATE PROCEDURE [dbo].[uspModifyLevelInstanceMaster]
(
	@iLevelInstanceID int,
	@iHierarchyLevelID int,
	@iHierarchyMasterID int,
	@sInstanceName varchar(100),
    @sLevelInstanceBy varchar(20),
	@dLevelInstanceOn datetime,
    @iFlag int
)
AS
BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF
	Declare @iHierarchyDetailID int;
	Declare @iCenterID int;

    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Hierarchy_Details
		(	I_Hierarchy_Level_Id,
			I_Hierarchy_Master_ID, 
			S_Hierarchy_Name, 
			I_Status, 
			S_Crtd_By, 
			Dt_Crtd_On	)
		VALUES
		(	@iHierarchyLevelID, 
			@iHierarchyMasterID,
			@sInstanceName,
			1, 
			@sLevelInstanceBy, 
			@dLevelInstanceOn	)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Hierarchy_Details
		SET S_Hierarchy_Name = @sInstanceName,
		S_Upd_By = @sLevelInstanceBy,
		Dt_Upd_On = @dLevelInstanceOn
		where I_Hierarchy_Detail_ID = @iLevelInstanceID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Hierarchy_Details
		SET I_Status = 0,
		S_Upd_By = @sLevelInstanceBy,
		Dt_Upd_On = @dLevelInstanceOn
		WHERE I_Hierarchy_Detail_ID = @iLevelInstanceID
	END
	ELSE IF @iFlag = 4
	BEGIN
		INSERT INTO dbo.T_Hierarchy_Details
		(	I_Hierarchy_Level_Id,
			I_Hierarchy_Master_ID, 
			S_Hierarchy_Name, 
			I_Status, 
			S_Crtd_By, 
			Dt_Crtd_On	)
		VALUES
		(	@iHierarchyLevelID, 
			@iHierarchyMasterID,
			@sInstanceName,
			1, 
			@sLevelInstanceBy, 
			@dLevelInstanceOn	)    

		SET @iHierarchyDetailID = SCOPE_IDENTITY()

		Select @iCenterID = I_Centre_Id
		from dbo.T_Centre_Master 
		where S_Center_Name = @sInstanceName
	
		Insert into dbo.T_Center_Hierarchy_Details 
		(	I_Center_Id,
			I_Hierarchy_Detail_ID,
			I_Hierarchy_Master_ID,
			Dt_Valid_From,
			I_Status	)
		Values 
		(	@iCenterID,
			@iHierarchyDetailID,
			@iHierarchyMasterID,
			getdate(),
			1	)
	END
	ELSE IF @iFlag = 5
	BEGIN
		UPDATE dbo.T_Hierarchy_Details
		SET I_Status = 0,
		S_Upd_By = @sLevelInstanceBy,
		Dt_Upd_On = @dLevelInstanceOn
		WHERE
			I_Hierarchy_Detail_ID = @iLevelInstanceID
		
		UPDATE dbo.T_Center_Hierarchy_Details
		SET I_Status = 0,
		Dt_Valid_To = getdate()
		WHERE I_Hierarchy_Detail_ID = @iLevelInstanceID			
			AND I_Status = 1

		UPDATE dbo.T_Centre_Master SET I_Status = 0
		where I_Centre_Id IN
			(SELECT I_Center_Id from dbo.T_Center_Hierarchy_Details
				where I_Hierarchy_Detail_ID = @iLevelInstanceID
				)
	END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
