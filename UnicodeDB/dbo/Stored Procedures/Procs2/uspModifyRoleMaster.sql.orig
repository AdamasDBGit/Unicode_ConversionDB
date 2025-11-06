CREATE PROCEDURE [dbo].[uspModifyRoleMaster] 
(
	@iRoleID int,
	@sRoleType varchar(20) = null,	
    @sRoleCode varchar(20) = null,    
    @sRoleDescription varchar(100) = null,
	@sRoleBy varchar(20),
	@dRoleOn datetime,
    @iFlag int,
    @iHierarchyDetailID int = null
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @sErrorCode varchar(20)
	DECLARE @iOut varchar(20)

    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Role_Master( S_Role_Type,S_Role_Code,S_Role_Desc, I_Status, I_Hierarchy_Detail_ID, S_Crtd_By, Dt_Crtd_On)
		VALUES(@sRoleType, @sRoleCode, @sRoleDescription, 1, @iHierarchyDetailID, @sRoleBy, @dRoleOn)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Role_Master
		SET 		
		S_Role_Desc = @sRoleDescription,
		I_Hierarchy_Detail_ID = @iHierarchyDetailID,
		S_Upd_By = @sRoleBy,
		Dt_Upd_On = @dRoleOn
		where I_Role_ID = @iRoleID
	END
	ELSE IF @iFlag = 3
	BEGIN
		SET @iOut = (select dbo.ufnIsRoleMapped(@iRoleID))
		IF @iOut = 0
		BEGIN
			SET @sErrorCode = 'SA_100001'
		END
		ELSE
		BEGIN
			UPDATE dbo.T_Role_Master
			SET I_Status = 0,
			S_Upd_By = @sRoleBy,
			Dt_Upd_On = @dRoleOn
			where I_Role_ID = @iRoleID
		END
	END

	SELECT @sErrorCode AS ERROR
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
