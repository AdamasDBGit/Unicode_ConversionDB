-- =============================================
-- Author:	Debarshi Basu
-- Create date: 02/03/2007
-- Description:	Create/Modify the Hierarchy Details
-- Updated By: Abhisek Bhattacharya
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateHierarchyDetails] 
(
	@iInstanceHDid int,
	@iInstanceParentid int = null,
	@iInstanceLevelid int,
	@iParentHDid int,
	@sLoginID varchar(50)
)

AS
BEGIN TRY

	SET NOCOUNT ON;
	DECLARE @sOldParentHierarchyChain	varchar(100)
	DECLARE @sOldParentLevelChain		varchar(100)
	DECLARE @sNewParentHierarchyChain	varchar(100)
	DECLARE @sNewParentLevelChain		varchar(100)
	DECLARE @sOldHierarchyChain			varchar(100)
	DECLARE @sOldLevelChain				varchar(100)
	DECLARE @sNewHierarchyChain			varchar(100)
	DECLARE @sNewLevelChain				varchar(100)
	DECLARE @sTempHiearchyChain			varchar(100)
	DECLARE @sTempLevelChain			varchar(100)
	
	DECLARE @iMax int
	DECLARE @iCount int
	
	CREATE TABLE #tempTable
	(
		seq int identity(1,1),
		intanceID int,
		hierarchyChain varchar(100),
		levelChain varchar(100)
	)	
	
	-- Select the Previous Instance Chain....
	SELECT @sOldHierarchyChain = S_Hierarchy_Chain,
	@sOldLevelChain = S_Hierarchy_Level_Chain
	FROM dbo.T_Hierarchy_Mapping_Details
	WHERE I_Hierarchy_Detail_ID = @iInstanceHDid
	AND I_Status = 1
	--AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	--AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())

	--SELECT @sOldHierarchyChain, @sOldLevelChain
	
	-- Select the Previous Parent Chain....
	SELECT @sOldParentHierarchyChain = S_Hierarchy_Chain,
	@sOldParentLevelChain = S_Hierarchy_Level_Chain
	FROM dbo.T_Hierarchy_Mapping_Details
	WHERE I_Hierarchy_Detail_ID = @iInstanceParentid
	AND I_Status = 1
	--AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	--AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())

	--SELECT @sOldParentHierarchyChain, @sOldParentLevelChain
	
	-- Select the Current Parent Chain....
	SELECT @sNewParentHierarchyChain = S_Hierarchy_Chain,
	@sNewParentLevelChain = S_Hierarchy_Level_Chain
	FROM dbo.T_Hierarchy_Mapping_Details
	WHERE I_Hierarchy_Detail_ID = @iParentHDid
	AND I_Status = 1
	--AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	--AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())

	--SELECT @sNewParentHierarchyChain, @sNewParentLevelChain
	
	BEGIN TRANSACTION
	-- Update the status of the existing Mapping details....
	UPDATE dbo.T_Hierarchy_Mapping_Details
	SET I_Status = 0,
	Dt_Valid_To = GETDATE(),
	S_Upd_By = @sLoginID,
	Dt_Upd_On = GETDATE()
	WHERE I_Hierarchy_Detail_ID = @iInstanceHDid
	AND I_Status = 1

	IF @iParentHDid = 0 SET @iParentHDid = NULL
	
	IF @sNewParentHierarchyChain IS NULL 
	BEGIN
		SET @sNewParentHierarchyChain = ''
	END
	ELSE
	BEGIN
		SET @sNewParentHierarchyChain = @sNewParentHierarchyChain + ','
	END
	
	IF @sNewParentLevelChain IS NULL 
	BEGIN
		SET @sNewParentLevelChain = ''
	END
	ELSE
	BEGIN
		SET @sNewParentLevelChain = @sNewParentLevelChain + ','
	END
	
	-- Insert the new Mapping details for the Hierarchy Instance
	INSERT INTO T_Hierarchy_Mapping_Details 
		(	I_Hierarchy_Detail_ID,
			I_Parent_ID,
			S_Hierarchy_Chain,
			S_Hierarchy_Level_Chain,
			Dt_Valid_From,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On	) 
		VALUES 
		(	@iInstanceHDid,
			@iParentHDid,
			@sNewParentHierarchyChain + CONVERT(varchar(5),@iInstanceHDid),
			@sNewParentLevelChain + CONVERT(varchar(5),@iInstanceLevelid),
			GETDATE(),
			1,
			@sLoginID,
			GETDATE()	)
			
	-- Select the New Instance Chain....
	SELECT @sNewHierarchyChain = S_Hierarchy_Chain,
	@sNewLevelChain = S_Hierarchy_Level_Chain
	FROM dbo.T_Hierarchy_Mapping_Details
	WHERE I_Hierarchy_Detail_ID = @iInstanceHDid
	AND I_Status = 1
	--AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	--AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())	

	--SELECT @sNewHierarchyChain, @sNewLevelChain	
	
	-- Get all the child details
	INSERT INTO #tempTable
	(
		intanceID,
		hierarchyChain,
		levelChain
	)
	SELECT	I_Hierarchy_Detail_ID,
			S_Hierarchy_Chain,
			S_Hierarchy_Level_Chain
	FROM dbo.T_Hierarchy_Mapping_Details	
	WHERE S_Hierarchy_Chain LIKE @sOldHierarchyChain + ',%'  
	AND I_Status <> 0
	--AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	--AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
	
	-- Set the status of all the child instances as 0
	UPDATE dbo.T_Hierarchy_Mapping_Details
	SET I_Status = 0,
	S_Upd_By = @sLoginID,
	Dt_Upd_On = GETDATE(),
	Dt_Valid_To = GETDATE()
	WHERE S_Hierarchy_Chain LIKE @sOldHierarchyChain + ',%'  
	AND I_Status <> 0
	--AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	--AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
	
	-- Set default value
	SET @iMax = 0
	SET @iCount = 1
	
	-- Select the max count of child instances
	SELECT @iMax = MAX(seq) FROM #tempTable
	
	IF @iMax > 0
	BEGIN
		WHILE (@iCount <= @iMax )  
		BEGIN
			SET @sTempHiearchyChain = ''
			SET @sTempLevelChain = ''
			
			SELECT	@sTempHiearchyChain = hierarchyChain,
			@sTempLevelChain = levelChain
			FROM #tempTable
			WHERE seq = @iCount
			
			SET @sTempHiearchyChain = REPLACE(@sTempHiearchyChain, @sOldHierarchyChain + ',', @sNewHierarchyChain + ',')
			SET @sTempLevelChain = REPLACE(@sTempLevelChain, @sOldLevelChain + ',', @sNewLevelChain + ',')

			UPDATE #tempTable
			SET hierarchyChain = @sTempHiearchyChain,
			levelChain = @sTempLevelChain
			WHERE seq = @iCount

			SET @iCount = @iCount + 1
		END
	END		

	-- Insert the child instances....
	INSERT INTO T_Hierarchy_Mapping_Details 
		(	I_Hierarchy_Detail_ID,
			I_Parent_ID,
			S_Hierarchy_Chain,
			S_Hierarchy_Level_Chain,
			Dt_Valid_From,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On	) 
	SELECT  intanceID,
			@iInstanceHDid,
			hierarchyChain,
			levelChain,
			GETDATE(),
			1,
			@sLoginID,
			GETDATE()	
	FROM #tempTable
	COMMIT TRANSACTION
	DROP TABLE #tempTable 
	
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
