CREATE PROCEDURE [dbo].[uspModifyModuleGroupModuleMapping] 
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
	--UPDATE dbo.T_Module_Term_Map 
	--SET Dt_Valid_To = @dModifiedOn,
	--S_Upd_By = @sModifiedBy,
	--Dt_Upd_On = @dModifiedOn,
	--I_Status = 0
	--WHERE I_Term_ID = @iTermID
	CREATE TABLE #tempModuleTermMap
        (
         I_Term_ID INT ,
		 I_Module_ID INT ,
		 I_ModuleGroup_ID INT ,
		 I_Status INT ,
         S_Crtd_By VARCHAR(100) NULL,
		 Dt_Crtd_On datetime NULL  
        )
	EXEC sp_xml_preparedocument @iDocHandle output,@sModuleTermMap
	INSERT INTO #tempModuleTermMap
	(	I_Term_ID,
		I_Module_ID,
		I_ModuleGroup_ID,
		I_Status,		
		S_Crtd_By,
		Dt_Crtd_On
	)

	SELECT * FROM OPENXML(@iDocHandle, '/ModuleTermMap/ModuleList',2)
	WITH 
	(	I_Term_ID int, 
		I_Module_ID int, 
		I_ModuleGroup_ID int, 
		I_Status int, 
		S_Crtd_By varchar(20), 
		Dt_Crtd_On datetime	)
		
		UPDATE MT
		SET MT.I_ModuleGroup_ID=tmpMT.I_ModuleGroup_ID,
		S_Upd_By=tmpMT.S_Crtd_By,
		Dt_Upd_On=tmpMT.Dt_Crtd_On
		FROM T_Module_Term_Map MT
		INNER JOIN (SELECT I_Term_ID,
		I_Module_ID,
		Case WHEN I_ModuleGroup_ID=0 then NULL else  I_ModuleGroup_ID end as I_ModuleGroup_ID,		
		I_Status,		 
		S_Crtd_By,
		Dt_Crtd_On FROM #tempModuleTermMap WHERE I_Term_ID=@iTermID) tmpMT ON tmpMT.I_Term_ID=MT.I_Term_ID
		 AND tmpMT.I_Module_ID=MT.I_Module_ID
		-- WHERE MT.I_ModuleGroup_ID IS NULL

		-- AND tmpMT.I_ModuleGroup_ID=MT.I_ModuleGroup_ID
		DROP TABLE  #tempModuleTermMap
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
