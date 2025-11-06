-- =============================================
-- Description:	Modifies the Module Group Master Table

-- =============================================

CREATE PROCEDURE [dbo].[uspCreateModifyModuleGroupMaster] 
(
	@iModuleGroupID INT,
	@iBrandID INT = NULL,
	@sModuleGroupName VARCHAR(50) = NULL,
	@sModuleGroupCode VARCHAR(10) = NULL,
	@sSequence INT = NULL,
    @sModuleGroupBy VARCHAR(20),
    @iFlag INT
)
AS

BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT OFF
	DECLARE @sErrorCode VARCHAR(20)

	BEGIN TRAN 
    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_ModuleGroup_Master
		(I_Brand_ID, 
		 S_ModuleGroup_Code,
		 S_ModuleGroup_Name, 
		 I_Sequence,
		 I_Status, 
		 S_Crtd_By, 
		 Dt_Crtd_On
		 )
		VALUES
		( @iBrandID, 
	      @sModuleGroupCode,
		  @sModuleGroupName, 
		  @sSequence,
          1, 
		  @sModuleGroupBy, 
		  GETDATE()
		)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_ModuleGroup_Master
		SET S_ModuleGroup_Code = @sModuleGroupCode,
			S_ModuleGroup_Name = @sModuleGroupName,
			I_Sequence=@sSequence,
			S_Upd_By = @sModuleGroupBy,
			Dt_Upd_On = GETDATE()
		WHERE I_ModuleGroup_ID = @iModuleGroupID
	END

	ELSE IF @iFlag = 3

	BEGIN

		IF EXISTS(SELECT I_ModuleGroup_ID 
				FROM dbo.T_ModuleGroup_Master
				WHERE I_ModuleGroup_ID = @iModuleGroupID
				AND I_Status = 1)
		BEGIN
			SET @sErrorCode = 'CM_100001'
		END

		

	END
	ELSE IF @iFlag = 4
		BEGIN
			UPDATE T_Module_Term_Map
			SET I_ModuleGroup_ID = NULL,
				S_Upd_By = @sModuleGroupBy,
				Dt_Upd_On = GETDATE()
			WHERE I_ModuleGroup_ID = @iModuleGroupID

			UPDATE dbo.T_ModuleGroup_Master
			SET I_Status = 0,
				S_Upd_By = @sModuleGroupBy,
				Dt_Upd_On = GETDATE()
			WHERE I_ModuleGroup_ID = @iModuleGroupID			

		END

	SELECT @sErrorCode AS ERROR
	COMMIT
END TRY

BEGIN CATCH

	--Error occurred:  
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
		SELECT	@ErrMsg = ERROR_MESSAGE(),

			@ErrSeverity = ERROR_SEVERITY()


	ROLLBACK
	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
