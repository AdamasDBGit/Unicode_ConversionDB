CREATE PROCEDURE [dbo].[uspModifyModuleTermMapping] 
(
	@iTermID int,
	@sModuleTermMap text,
	@sModifiedBy varchar(20),
	@dModifiedOn datetime
)

AS
BEGIN TRY

	SET NOCOUNT OFF
	
	DECLARE @iDocHandle int
	
	BEGIN TRANSACTION
    -- Insert statements for procedure here
	UPDATE dbo.T_Module_Term_Map 
	SET Dt_Valid_To = @dModifiedOn,
	S_Upd_By = @sModifiedBy,
	Dt_Upd_On = @dModifiedOn,
	I_Status = 0
	WHERE I_Term_ID = @iTermID
	
	EXEC sp_xml_preparedocument @iDocHandle output,@sModuleTermMap
	INSERT INTO T_Module_Term_Map
	(	I_Term_ID,
		I_Module_ID,
		I_Sequence,
		C_Examinable,
		Dt_Valid_From,
		I_Status,		
		S_Crtd_By,
		Dt_Crtd_On	)

	SELECT * FROM OPENXML(@iDocHandle, '/ModuleTermMap/ModuleList',2)
	WITH 
	(	I_Term_ID int, 
		I_Module_ID int, 
		I_Sequence int,
		C_Examinable char(1),		
		Dt_Valid_From datetime,
		I_Status int, 
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
