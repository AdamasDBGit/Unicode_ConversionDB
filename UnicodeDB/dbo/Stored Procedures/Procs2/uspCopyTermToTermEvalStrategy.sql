CREATE PROCEDURE [dbo].[uspCopyTermToTermEvalStrategy] 
(
	@iSourceCourseID Int,
	@iSourceTermID Int,
	@sDestinationCourseList Nnvarchar(max),
	@sUpdatedBy Nnvarchar(max),
	@dUpdatedOn DateTime
)

As

Begin Try

	Set NoCount On;

	Declare @iDestinationCourseId Int
	
	Declare @Source_I_Exam_Component_ID Int 
	Declare @Source_I_Exam_Type_Master_ID Int
	Declare @Source_I_TotMarks Int
	Declare @Source_N_Weightage Numeric(8,2)
	Declare @Source_S_Remarks nvarchar(max)
	Declare @Source_I_IsPSDate Bit
	Declare @Source_I_Template_ID Int
	Declare @Source_I_Exam_Duration Int
	Declare @Source_Module_Id Int

	Create Table #ContainingExamTypeMasterID
	(
		I_Exam_Type_Master_ID Int
	)
	
	Create Table #ContainingExamComponentID
	(
		I_Exam_Component_ID Int
	)
	
	BEGIN TRANSACTION
	--------------Populating Destination Course for which the Evaluation Strategy will be copied-----
	Declare _DestinationCourseCursor Cursor For
	Select Val From dbo.fnString2Rows(@sDestinationCourseList,',')

	Open _DestinationCourseCursor
	Fetch Next From _DestinationCourseCursor Into @iDestinationCourseId

	While (@@Fetch_Status=0)
	Begin

		--------------------Copying the Term Level Evaluation Strategy for Source Course------------------
		Declare _SourceCourseTermCursor Cursor For
		Select
		I_Exam_Component_ID, 
		I_Exam_Type_Master_ID, 
		I_TotMarks, 
		N_Weightage, 
		S_Remarks, 
		I_IsPSDate, 
		I_Template_ID, 
		I_Exam_Duration
		From DBO.T_TERM_EVAL_STRATEGY Where I_COURSE_ID=@iSourceCourseID AND I_TERM_ID=@iSourceTermID AND I_STATUS=1 

		Open _SourceCourseTermCursor
		Fetch Next From _SourceCourseTermCursor Into 
		@Source_I_Exam_Component_ID, @Source_I_Exam_Type_Master_ID, @Source_I_TotMarks, @Source_N_Weightage,
		@Source_S_Remarks, @Source_I_IsPSDate, @Source_I_Template_ID, @Source_I_Exam_Duration

		While (@@Fetch_Status=0)
		Begin
			If Exists(Select 'True' From DBO.T_TERM_EVAL_STRATEGY Where I_Course_Id=@iDestinationCourseId And I_Term_Id=@iSourceTermID And I_Exam_Type_Master_ID=@Source_I_Exam_Type_Master_ID And I_STATUS=1)
				Begin
					Update [dbo].[T_Term_Eval_Strategy]
					Set
					[I_Exam_Component_ID] = @Source_I_Exam_Component_ID
					,[I_Exam_Type_Master_ID] = @Source_I_Exam_Type_Master_ID
					,[I_TotMarks] = @Source_I_TotMarks
					,[N_Weightage] = @Source_N_Weightage
					,[S_Remarks] = @Source_S_Remarks
					,[I_IsPSDate] = @Source_I_IsPSDate
					,[I_Template_ID] = @Source_I_Template_ID
					,[S_Upd_By] = @sUpdatedBy	
					,[Dt_Upd_On] = @dUpdatedOn
					,[I_Exam_Duration] = @Source_I_Exam_Duration
					Where I_Course_Id=@iDestinationCourseId And I_Term_Id=@iSourceTermID And I_Exam_Type_Master_ID=@Source_I_Exam_Type_Master_ID And I_STATUS=1
				End
			Else
				Begin
					Insert Into [dbo].[T_Term_Eval_Strategy]
					(
						[I_Course_ID]
					   ,[I_Term_ID]
					   ,[I_Exam_Component_ID]
					   ,[I_Exam_Type_Master_ID]
					   ,[I_TotMarks]
					   ,[N_Weightage]
					   ,[S_Remarks]
					   ,[I_IsPSDate]
					   ,[I_Template_ID]
					   ,[I_Status]
					   ,[S_Crtd_By]
					   ,[S_Upd_By]
					   ,[Dt_Crtd_On]
					   ,[Dt_Upd_On]
					   ,[I_Exam_Duration]
					)
					Values
					(
						@iDestinationCourseId
					   ,@iSourceTermID
					   ,@Source_I_Exam_Component_ID
					   ,@Source_I_Exam_Type_Master_ID
					   ,@Source_I_TotMarks
					   ,@Source_N_Weightage
					   ,@Source_S_Remarks
					   ,@Source_I_IsPSDate
					   ,@Source_I_Template_ID
					   ,1
					   ,@sUpdatedBy
					   ,Null
					   ,@dUpdatedOn
					   ,Null
					   ,@Source_I_Exam_Duration
					)
				End
				
				Insert Into #ContainingExamTypeMasterID Values(@Source_I_Exam_Type_Master_ID)

			Fetch Next From _SourceCourseTermCursor Into 
			@Source_I_Exam_Component_ID, @Source_I_Exam_Type_Master_ID, @Source_I_TotMarks, @Source_N_Weightage,
			@Source_S_Remarks, @Source_I_IsPSDate, @Source_I_Template_ID, @Source_I_Exam_Duration
		End

		Close _SourceCourseTermCursor
		DeAllocate _SourceCourseTermCursor
		
		--Making The Status=0 For extra row, which is not present in the source term eval strategy
		Update [dbo].[T_Term_Eval_Strategy]
		Set I_Status=0
		Where I_Course_Id=@iDestinationCourseId And I_Term_Id=@iSourceTermID And I_Exam_Type_Master_ID Not In(Select I_Exam_Type_Master_ID From #ContainingExamTypeMasterID) And I_STATUS=1
		-------------------------------------------------------------------------------------------------



		--------------------Copying the Module Level Evaluation Strategy for Source Course------------------
		Declare _SourceCourseModuleCursor Cursor For
		Select
		[I_Module_ID]
		,[I_Exam_Component_ID]
		,[I_TotMarks]
		,[N_Weightage]
		,[S_Remarks]
		,[I_Exam_Duration]
		From DBO.T_MODULE_EVAL_STRATEGY Where I_COURSE_ID=@iSourceCourseID AND I_TERM_ID=@iSourceTermID AND I_STATUS=1 

		Open _SourceCourseModuleCursor
		Fetch Next From _SourceCourseModuleCursor Into 
		@Source_Module_Id, @Source_I_Exam_Component_ID, @Source_I_TotMarks, @Source_N_Weightage,
		@Source_S_Remarks, @Source_I_Exam_Duration

		While (@@Fetch_Status=0)
		Begin
			If Exists(Select 'True' From DBO.T_MODULE_EVAL_STRATEGY 
					Where I_Course_Id=@iDestinationCourseId And I_Term_Id=@iSourceTermID And I_Module_Id=@Source_Module_Id And
					I_Exam_Component_ID=@Source_I_Exam_Component_ID And I_STATUS=1)
				Begin
					Update [dbo].[T_Module_Eval_Strategy]
					Set
					[I_Exam_Component_ID] = @Source_I_Exam_Component_ID
					,[I_TotMarks] = @Source_I_TotMarks
					,[N_Weightage] = @Source_N_Weightage
					,[S_Remarks] = @Source_S_Remarks
					,[S_Upd_By] = @sUpdatedBy	
					,[Dt_Upd_On] = @dUpdatedOn
					,[I_Exam_Duration] = @Source_I_Exam_Duration
					Where I_Course_Id=@iDestinationCourseId And I_Term_Id=@iSourceTermID And I_Module_Id=@Source_Module_Id And
					I_Exam_Component_ID=@Source_I_Exam_Component_ID And I_STATUS=1
				End
			Else
				Begin
					Insert Into [dbo].[T_Module_Eval_Strategy]
					(
						[I_Course_ID]
					   ,[I_Term_ID]
					   ,[I_Module_ID]
					   ,[I_Exam_Component_ID]
					   ,[I_TotMarks]
					   ,[N_Weightage]
					   ,[S_Remarks]
					   ,[I_Status]
					   ,[S_Crtd_By]
					   ,[S_Upd_By]
					   ,[Dt_Crtd_On]
					   ,[Dt_Upd_On]
					   ,[I_Exam_Duration]
					)
					Values
					(
						@iDestinationCourseId
					   ,@iSourceTermID
					   ,@Source_Module_Id
					   ,@Source_I_Exam_Component_ID
					   ,@Source_I_TotMarks
					   ,@Source_N_Weightage
					   ,@Source_S_Remarks
					   ,1
					   ,@sUpdatedBy
					   ,Null
					   ,@dUpdatedOn
					   ,Null
					   ,@Source_I_Exam_Duration
					)
				End
				
				Insert Into #ContainingExamComponentID Values(@Source_I_Exam_Component_ID)

			Fetch Next From _SourceCourseModuleCursor Into 
			@Source_Module_Id, @Source_I_Exam_Component_ID, @Source_I_TotMarks, @Source_N_Weightage,
			@Source_S_Remarks, @Source_I_Exam_Duration
		End

		Close _SourceCourseModuleCursor
		DeAllocate _SourceCourseModuleCursor

		--Making The Status=0 For extra row, which is not present in the source module eval strategy
		Update [dbo].[T_Module_Eval_Strategy]
		Set I_Status=0
		Where I_Course_Id=@iDestinationCourseId And I_Term_Id=@iSourceTermID And I_Module_Id=@Source_Module_Id And I_Exam_Component_ID Not In(Select I_Exam_Component_ID From #ContainingExamComponentID) And I_STATUS=1
		-----------------------------------------------------------------------------------------
		
		Fetch Next From _DestinationCourseCursor Into @iDestinationCourseId
	End

	Close _DestinationCourseCursor
	DeAllocate _DestinationCourseCursor
	------------------------------------------------------------------------------------------------

	Drop Table #ContainingExamTypeMasterID
	Drop Table #ContainingExamComponentID
	COMMIT TRANSACTION
End Try

Begin Catch
	ROLLBACK TRANSACTION
	Declare @ErrMsg Nnvarchar(max), @ErrSeverity int
	Select	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RaisError(@ErrMsg, @ErrSeverity, 1)

End Catch

