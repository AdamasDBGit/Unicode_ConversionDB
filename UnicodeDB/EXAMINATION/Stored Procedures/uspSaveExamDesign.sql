CREATE PROCEDURE [EXAMINATION].[uspSaveExamDesign]
	@iExamComponentID int,
	@iEvalStrategyID int = NULL,
	@sQuestionBankID varchar(500),
	@sQuestionPattern xml,
	@sCreatedBy varchar(20),
	@DtCreatedOn datetime,
	@sUpdatedBy  varchar(20),
	@DtUpdatedOn datetime,
	@iCourseID int,
	@iTermID int,
	@iModuleID int
AS
BEGIN
	DECLARE @iTestDesignID INT, @RowCount INT, @iCourseFamilyID INT, @iBrandID INT, @iCertificateID INT
	
	SELECT	@iBrandID = I_Brand_ID,
			@iCourseFamilyID = I_CourseFamily_ID,
			@iCertificateID = I_Certificate_ID
	FROM
		dbo.T_Course_Master WITH(NOLOCK)
	WHERE	I_Course_ID = @iCourseID
		
	DECLARE @tblCourse TABLE(I_Course_ID INT)
	
	INSERT INTO @tblCourse
	SELECT I_Course_ID FROM dbo.T_Course_Master 
	WHERE	I_Brand_ID = @iBrandID
		AND I_CourseFamily_ID = @iCourseFamilyID
		AND I_Certificate_ID = ISNULL(@iCertificateID,I_Certificate_ID)
		
	DECLARE @tblEvalStrategy TABLE(ID INT IDENTITY(1,1), I_Eval_Strategy_ID INT)
	
	IF (@iModuleID IS NULL OR @iModuleID = 0)
		BEGIN
			INSERT INTO @tblEvalStrategy
			SELECT I_Term_Strategy_ID 
			FROM dbo.T_Term_Eval_Strategy TES WITH(NOLOCK)
			INNER JOIN @tblCourse TC
			ON TES.I_Course_ID = TC.I_Course_ID
			WHERE	I_Term_ID = @iTermID
			AND I_Exam_Component_ID = @iExamComponentID
		END
	ELSE
		BEGIN
			INSERT INTO @tblEvalStrategy
			SELECT I_Module_Strategy_ID 
			FROM dbo.T_Module_Eval_Strategy TMS WITH(NOLOCK)
			INNER JOIN @tblCourse TC
			ON TMS.I_Course_ID = TC.I_Course_ID
			WHERE	I_Term_ID = @iTermID
			AND		I_Module_ID = @iModuleID
			AND I_Exam_Component_ID = @iExamComponentID
		END
						
--	Before any update insert the values in the Audit table
	INSERT INTO EXAMINATION.T_Test_Design_Audit
	(I_Test_Design_ID,I_Exam_Component_ID,I_Eval_Strategy_ID,
	I_Bank_Pool_Mapping_ID,I_No_Of_Questions,I_Complexity_ID,N_Marks,
	I_Status_ID,S_Crtd_By,S_Upd_by,Dt_Crtd_On,Dt_Upd_On)
	SELECT 
	TD.I_Test_Design_ID,TD.I_Exam_Component_ID,TD.I_Eval_Strategy_ID,
	BPM.I_Bank_Pool_Mapping_ID,TDP.I_No_Of_Questions,TDP.I_Complexity_ID,
	TDP.N_Marks,TD.I_Status_ID,@sCreatedBy,@sUpdatedBy,@DtCreatedOn,@DtUpdatedOn
	FROM EXAMINATION.T_Test_Design TD WITH(NOLOCK)
	INNER JOIN EXAMINATION.T_Test_Design_Pattern TDP WITH(NOLOCK)
	ON TD.I_Test_Design_ID = TDP.I_Test_Design_ID
	INNER JOIN EXAMINATION.T_Bank_Pool_Mapping BPM
	ON BPM.I_Pool_ID = TDP.I_Pool_ID
	WHERE TD.I_Exam_Component_ID = @iExamComponentID
	AND TD.I_Eval_Strategy_ID IN (SELECT I_Eval_Strategy_ID FROM @tblEvalStrategy)

--	Delete relevant rows from Design Pattern table
	DELETE FROM EXAMINATION.T_Test_Design_Pattern
	WHERE I_Test_Design_ID IN
	(SELECT I_Test_Design_ID FROM EXAMINATION.T_Test_Design
		WHERE I_Exam_Component_ID = @iExamComponentID
		AND I_Eval_Strategy_ID IN (SELECT I_Eval_Strategy_ID FROM @tblEvalStrategy) )
	
	
	DECLARE @iEvalStratCount INT, @iLoopCount INT
	SELECT @iEvalStratCount = COUNT(I_Eval_Strategy_ID) FROM @tblEvalStrategy
	SET @iLoopCount = 1
	
	--	Create Temporary Table To store values from XML
		CREATE TABLE #tempTable
		(            
			I_Pool_ID int,
			I_No_Of_Questions int,
			I_Complexity_ID int,
			N_Marks numeric(8,2)
		)

	--	INsert Values into Temporary Table
		INSERT INTO #tempTable
		SELECT T.c.value('@QuestionPoolID','int'),
				T.c.value('@NoOfQuestion','int'),
				T.c.value('@Complexity','int'),
				T.c.value('@Marks','numeric(8,2)')
		FROM   @sQuestionPattern.nodes('/ExamDesign/QuestionPattern') T(c)
	
	WHILE (@iLoopCount <= @iEvalStratCount)
	BEGIN
		SELECT @iEvalStrategyID = I_Eval_Strategy_ID FROM @tblEvalStrategy WHERE ID = @iLoopCount
	
		--	Delete relevant rows from Test design Table
		IF EXISTS (SELECT I_Exam_Component_ID FROM EXAMINATION.T_Test_Design
					WHERE I_Exam_Component_ID = @iExamComponentID
					AND I_Eval_Strategy_ID = ISNULL(@iEvalStrategyID,I_Eval_Strategy_ID))
		BEGIN
			UPDATE EXAMINATION.T_Test_Design
			SET S_Question_Bank_ID = @sQuestionBankID,
				S_Upd_By = @sUpdatedBy,
				Dt_Upd_On = @DtUpdatedOn		
			WHERE I_Exam_Component_ID = @iExamComponentID
				AND I_Eval_Strategy_ID = ISNULL(@iEvalStrategyID,I_Eval_Strategy_ID)

			SELECT @iTestDesignID = I_Test_Design_ID 
			FROM EXAMINATION.T_Test_Design
			WHERE I_Exam_Component_ID = @iExamComponentID
				AND I_Eval_Strategy_ID = ISNULL(@iEvalStrategyID,I_Eval_Strategy_ID)
		END
		ELSE
		BEGIN
			--	INSERT into the test design table
			INSERT INTO EXAMINATION.T_Test_Design
			(I_Exam_Component_ID,I_Eval_Strategy_ID,S_Question_Bank_ID,
			I_Status_ID,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On)
			VALUES
			(@iExamComponentID,@iEvalStrategyID,@sQuestionBankID,
			1,@sCreatedBy,@sUpdatedBy,@DtCreatedOn,@DtUpdatedOn)

			SELECT @iTestDesignID = @@IDENTITY 
		END

	--	Insert values into the test design pattern table from temporary table
		INSERT INTO EXAMINATION.T_Test_Design_Pattern
		(I_Test_Design_ID,I_Pool_ID,I_No_Of_Questions,I_Complexity_ID,
		N_Marks,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On)
		SELECT 
		@iTestDesignID,I_Pool_ID,I_No_Of_Questions,I_Complexity_ID,
		N_Marks,@sCreatedBy,@sUpdatedBy,@DtCreatedOn,@DtUpdatedOn 
		FROM #tempTable
		
		SET @iLoopCount = @iLoopCount + 1
				
	END
	TRUNCATE TABLE #tempTable
	DROP TABLE #tempTable
END
