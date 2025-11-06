CREATE PROCEDURE [dbo].[uspCheckTermModuleSemEndExam] 
(
	 @iCourseId int,
	 @iTermId int,
	 @iModuleID int,
	 @iExamTypeID int
)
 AS
BEGIN TRY
	
	IF @iModuleID = 0
	BEGIN
		select * from dbo.T_Term_Eval_Strategy
		where I_Course_ID = @iCourseId
		and I_Term_ID = @iTermId
		--and I_Exam_Type_Master_ID = @iExamTypeID
		and I_Status = 1
	END
	ELSE
	BEGIN
		SELECT * FROM dbo.T_Module_Eval_Strategy
		where I_Course_ID = @iCourseId
		and I_Term_ID = @iTermId
		and I_Module_ID = @iModuleID
		and I_Exam_Component_ID IN 
		(select I_Exam_Component_ID from dbo.T_Exam_Component_Master
			WHERE I_Status = 1
			--AND I_Exam_Type_Master_ID = @iExamTypeID
		)
		and I_Status = 1 
	END
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
