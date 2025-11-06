CREATE PROCEDURE [dbo].[uspModifyHierarchyMaster]
(
		@iHierarchyId int,
		@sHierarchyCode varchar(20),
		@sHierarchyType varchar(20),
		@sHierarchyDesc varchar(200),
		@sCreatedBy varchar(20),
		@dCreatedOn datetime,
		@iFlag int
)
AS

BEGIN TRY
	SET NOCOUNT ON;

	IF(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Hierarchy_Master
			(
				S_Hierarchy_Code,
				S_Hierarchy_Desc,
				S_Hierarchy_Type,
				I_Status,
				DT_Crtd_On,
				S_Crtd_By
			)
			VALUES
			(
				@sHierarchyCode,
				@sHierarchyDesc,
				@sHierarchyType,
				1,
				@dCreatedOn,
				@sCreatedBy
			)
			
			SET @iHierarchyId = SCOPE_IDENTITY()
		END
			
				
		ELSE IF(@iFlag=2)
			BEGIN
				UPDATE dbo.T_Hierarchy_Master 
				SET S_Hierarchy_Code =  @sHierarchyCode,
				S_Hierarchy_Desc = @sHierarchyDesc,
				Dt_Upd_On = @dCreatedOn,
				S_Upd_By = @sCreatedBy
				WHERE I_Hierarchy_Master_ID = @iHierarchyId  
			END 
		
		ELSE IF(@iFlag=3)
			BEGIN
				UPDATE dbo.T_Hierarchy_Master 
				SET I_Status =  0,
				Dt_Upd_On = @dCreatedOn,
				S_Upd_By = @sCreatedBy
				WHERE I_Hierarchy_Master_ID = @iHierarchyId
			END 	
			
		SELECT 	@iHierarchyId HierarchyMasterID, '' ERROR

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
