CREATE PROCEDURE [dbo].[uspModifySessionModuleMap] 
(
	-- Add the parameters for the stored procedure here
	@iModuleID int,
	@iTotalSessions int,
	@sSessionModuleMap text,
	@sModifiedBy varchar(20),
	@dModifiedOn datetime
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF
	
	DECLARE @iDocHandle int
	
	BEGIN TRANSACTION
	-- Update the Total number of Sessions
	UPDATE dbo.T_Module_Master
	SET I_No_Of_Session = @iTotalSessions,
	S_Upd_By = @sModifiedBy,
	Dt_Upd_On = @dModifiedOn
	WHERE I_Module_ID = @iModuleID
	
    -- Insert statements for procedure here
	UPDATE dbo.T_Session_Module_Map 
	SET Dt_Valid_To = @dModifiedOn,
	S_Upd_By = @sModifiedBy,
	Dt_Upd_On = @dModifiedOn,
	I_Status = 0
	WHERE I_Module_ID = @iModuleID
	
	EXEC sp_xml_preparedocument @iDocHandle output,@sSessionModuleMap
	INSERT INTO T_Session_Module_Map
	(	I_Module_ID,
		I_Session_ID,
		I_Sequence,
		I_Status,
		Dt_Valid_From,
		S_Crtd_By,
		Dt_Crtd_On	)

	SELECT * FROM OPENXML(@iDocHandle, '/SessionModuleMap/SessionList',2)
	WITH 
	(	I_Module_ID int, 
		I_Session_ID int, 
		I_Sequence int,
		I_Status int, 
		Dt_Valid_From datetime,
		S_Crtd_By varchar(20), 
		Dt_Crtd_On datetime	)
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
