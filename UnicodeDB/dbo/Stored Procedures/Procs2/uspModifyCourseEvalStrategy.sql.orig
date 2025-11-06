-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create Date: 18/03/2007
-- Modified Date: 29/05/2007
-- Description:	Get the Course Details For Eval Strategy
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyCourseEvalStrategy] 
(
	-- Add the parameters for the stored procedure here
	@iCourseID int,
	@iTermID int,
	@iModuleID int = null,
	@sEvalStrategy xml,
	@sUser varchar(20),
	@dDate datetime,
	@iCertificateTemplateID int
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON 

	-- Declare Statement
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT 
	DECLARE @EvalStrategyXML XML, @ComponentXML XML
	DECLARE @iExamCompId INT, @iTotMarks INT, @iExamTypeID INT, @iIsPSDate INT,@I_Exam_Duration INT
	DECLARE @nWeightage NUMERIC(8,2)
	DECLARE @sRemarks VARCHAR(200)

	BEGIN TRANSACTION
	-- Update the T_Course_Master for the given Course
	UPDATE dbo.T_Course_Master
	SET S_Upd_By = @sUser,
	Dt_Upd_On = @dDate
	WHERE I_Course_ID = @iCourseID
	
	SET @AdjPosition = 1
	SET @AdjCount = @sEvalStrategy.value('count((ComponentList/Component))','int')

	IF @iModuleID  IS NULL OR @iModuleID = 0 
	-- Term Evaluation Strategy
	BEGIN
		UPDATE dbo.T_Term_Master
		SET S_Upd_By = @sUser,
		Dt_Upd_On = @dDate
		WHERE I_Term_ID = @iTermID
		
		UPDATE dbo.T_Term_Eval_Strategy
		SET	S_Upd_By = @sUser,
		Dt_Upd_On = @dDate,
		I_Status = 0
		WHERE I_Course_ID = @iCourseID
		AND I_Term_ID = @iTermID
		AND I_Status = 1
		
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @ComponentXML = @sEvalStrategy.query('/ComponentList/Component[position()=sql:variable("@AdjPosition")]')
			SELECT	@iExamCompId = T.a.value('@I_Exam_Component_ID','int'),
			@iExamTypeID = T.a.value('@I_Exam_Type_Master_ID','int'),
			@iTotMarks = T.a.value('@I_TotMarks','int'),		
			@I_Exam_Duration = T.a.value('@I_Exam_Duration','int'),	
			@nWeightage = T.a.value('@N_Weightage','numeric(8,2)'),
			@sRemarks = T.a.value('@S_Remarks','varchar(200)'),
			@iIsPSDate = T.a.value('@I_IsPSDate','int')
			FROM @ComponentXML.nodes('/Component') T(a)
			
			IF @iExamCompId = 0 SET @iExamCompId = NULL
			IF @iExamTypeID = 0 SET @iExamTypeID = NULL

			INSERT INTO dbo.T_Term_Eval_Strategy
			(
				I_Course_ID,
				I_Term_ID,
				I_Exam_Type_Master_ID,
				I_Exam_Component_ID,
				I_TotMarks,
				N_Weightage,
				S_Remarks,
				I_IsPSDate,
				I_Template_ID,
				I_Status,
				S_Crtd_By,
				Dt_Crtd_On,
				I_Exam_Duration
			)
			VALUES
			(
				@iCourseID,
				@iTermID,
				@iExamTypeID,
				@iExamCompId,
				@iTotMarks,
				@nWeightage,
				@sRemarks,
				@iIsPSDate,
				@iCertificateTemplateID,
				1,
				@sUser,
				@dDate,
				@I_Exam_Duration
			)

		SET @AdjPosition=@AdjPosition+1
		END
	
	END
	ELSE 
	-- Module Evaluation Strategy 
	BEGIN
		UPDATE dbo.T_Module_Master
		SET S_Upd_By = @sUser,
		Dt_Upd_On = @dDate
		WHERE I_Module_ID = @iModuleID

		UPDATE dbo.T_Module_Eval_Strategy
		SET	S_Upd_By = @sUser,
		Dt_Upd_On = @dDate,
		I_Status = 0
		WHERE I_Course_ID = @iCourseID
		AND I_Term_ID = @iTermID
		AND I_Module_ID = @iModuleID
		AND I_Status = 1
		
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @ComponentXML = @sEvalStrategy.query('/ComponentList/Component[position()=sql:variable("@AdjPosition")]')
			SELECT	@iExamCompId = T.a.value('@I_Exam_Component_ID','int'),
			@iTotMarks = T.a.value('@I_TotMarks','int'),
			@I_Exam_Duration = T.a.value('@I_Exam_Duration','int'),
			@nWeightage = T.a.value('@N_Weightage','numeric(8,2)'),
			@sRemarks = T.a.value('@S_Remarks','varchar(200)')
			FROM @ComponentXML.nodes('/Component') T(a)

			INSERT INTO dbo.T_Module_Eval_Strategy
			(
				I_Course_ID,
				I_Term_ID,
				I_Module_ID,
				I_Exam_Component_ID,
				I_TotMarks,
				N_Weightage,
				S_Remarks,
				I_Status,
				S_Crtd_By,
				Dt_Crtd_On,
				I_Exam_Duration
			)
			VALUES
			(
				@iCourseID,
				@iTermID,
				@iModuleID,
				@iExamCompId,
				@iTotMarks,
				@nWeightage,
				@sRemarks,
				1,
				@sUser,
				@dDate,
				@I_Exam_Duration
			)

		SET @AdjPosition=@AdjPosition+1
		END
	
	END
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
