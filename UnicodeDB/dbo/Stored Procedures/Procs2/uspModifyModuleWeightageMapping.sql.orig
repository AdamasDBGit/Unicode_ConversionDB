
CREATE PROCEDURE [dbo].[uspModifyModuleWeightageMapping] 
(
	@iTermID INT,
	@sModuleTermMap TEXT,
	@sModifiedBy VARCHAR(20),
	@dModifiedOn DATETIME
)

AS
BEGIN TRY

	SET NOCOUNT OFF
	
	DECLARE @iDocHandle INT
	
	BEGIN TRANSACTION
    -- Insert statements for procedure here
	
	CREATE TABLE #tempModuleTermMap
        (I_Term_ID INT ,
		 I_Module_ID INT ,
		 I_ModuleGroup_ID INT ,
		 N_Weightage NUMERIC(8,2) ,
         S_Remarks VARCHAR(200) ,
		 I_Status INT  
        )
	EXEC sp_xml_preparedocument @iDocHandle OUTPUT,@sModuleTermMap
	INSERT INTO #tempModuleTermMap
	(	I_Term_ID,
		I_Module_ID,
		I_ModuleGroup_ID,
		N_Weightage,
		S_Remarks,
		I_Status
	)

	SELECT * FROM OPENXML(@iDocHandle, '/ModuleWeightage/ModuleList',2)
	WITH 
		(I_Term_ID INT, 
		I_Module_ID INT, 
		I_ModuleGroup_ID INT, 
		N_Weightage NUMERIC(8,2),
		S_Remarks VARCHAR(200),
		I_Status INT)
		
	UPDATE MT
	SET		
		MT.N_Weightage=tmpMT.N_Weightage,
		MT.S_Remarks=tmpMT.S_Remarks,
		S_Upd_By=@sModifiedBy,
		Dt_Upd_On=@dModifiedOn
	FROM T_Module_Term_Map MT
		INNER JOIN (SELECT I_Term_ID,
						I_Module_ID,
						I_ModuleGroup_ID,
						N_Weightage,
						S_Remarks,		
						I_Status
					FROM #tempModuleTermMap WHERE I_Term_ID=@iTermID) tmpMT ON tmpMT.I_Term_ID=MT.I_Term_ID
										AND tmpMT.I_Module_ID=MT.I_Module_ID
										AND MT.I_Status =1
		
		CREATE TABLE #tempModuleEvalStrategy
			(I_Course_ID INT ,
			 I_Term_ID INT ,
			 I_Module_ID INT ,
			 I_Exam_Component_ID INT ,
			 N_Weightage NUMERIC(8,2) )

		INSERT INTO  #tempModuleEvalStrategy(
			I_Course_ID
			,I_Term_ID
			,I_Module_ID
			,I_Exam_Component_ID
			,N_Weightage)
		SELECT * FROM OPENXML(@iDocHandle, '/ModuleWeightage/ExamComponenentList',2)
		WITH 
			(I_Course_ID INT,
			I_Term_ID INT, 
			I_Module_ID INT, 
			I_Exam_Component_ID INT, 
			N_Weightage NUMERIC(8,2))

		UPDATE T
			SET T.N_Weightage = MES.N_Weightage
				,S_Upd_By=@sModifiedBy
				,Dt_Upd_On=@dModifiedOn
		FROM T_Module_Eval_Strategy T
		INNER JOIN #tempModuleEvalStrategy MES ON MES.I_Course_ID = T.I_Course_ID 
											AND MES.I_Term_ID = T.I_Term_ID 
											AND MES.I_Module_ID = T.I_Module_ID 
											AND MES.I_Exam_Component_ID = T.I_Exam_Component_ID
											AND T.I_Status = 1


		DROP TABLE #tempModuleTermMap
		DROP TABLE #tempModuleEvalStrategy

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
