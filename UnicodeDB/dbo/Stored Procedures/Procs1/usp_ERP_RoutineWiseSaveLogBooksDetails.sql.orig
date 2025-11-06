-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 Nov 27>
-- Description:	<Save LogBook Details>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_RoutineWiseSaveLogBooksDetails] 
	-- Add the parameters for the stored procedure here
	@LogBookDetails UT_LogBookTableForInsertUpdate readonly,
	@FacultyID INT = NULL,
	@sToken varchar(max)=NULL,
	@iSubjectID INT,
	@iStudentClassRoutineID INT,
	@dtClassdate Datetime
AS

BEGIN TRY


	SET NOCOUNT ON;

	begin transaction

	DECLARE @TeacherTimePlanID INT
	DECLARE @SubjectStructurePlanID INT 
	DECLARE @CompletionPercentage decimal(4,1) 
	DECLARE @TotalCompletionPercentage decimal(4,1) 
	DECLARE @Remarks varchar(max) 
	DECLARE @IsCompleted Bit
	DECLARE @CreatedBy int
	DECLARE @iTeacherTimePlan INT
	DECLARE @iRoutineHeaderID INT
	DECLARE @sLearningOutcomeAchieved varchar(max)
	--DECLARE @isubjectStructurePlanID INT


	DECLARE @ErrMessage NVARCHAR(4000)

	--select * from @LogBookDetails


	IF  @FacultyID IS NULL
	BEGIN

		IF (@sToken IS NULL)
		OR 
		NOT EXISTS
		(
		select * from 
		T_Faculty_Master as FM 
		inner join
		T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID where 
		UM.S_Token=@sToken and FM.I_Status=1 
		)
			 BEGIN

			 SELECT @ErrMessage='Invalid Token'

			 RAISERROR(@ErrMessage,11,1)

			 END

			 ELSE

			 BEGIN

				select @FacultyID=FM.I_Faculty_Master_ID,@CreatedBy=UM.I_User_ID from 
				T_Faculty_Master as FM 
				inner join
				T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID where 
				UM.S_Token=@sToken and FM.I_Status=1

				--print @FacultyID

			 END

	END

	IF @FacultyID IS NOT NULL OR @FacultyID > 0
			BEGIN

				IF not exists
				(
				select * from 
				T_ERP_Student_Class_Routine as SCR 
				inner join
				T_ERP_Routine_Structure_Detail as RSD on SCR.I_Routine_Structure_Detail_ID=RSD.I_Routine_Structure_Detail_ID
				inner join
				T_ERP_Routine_Structure_Header as RSH on RSD.I_Routine_Structure_Header_ID=RSH.I_Routine_Structure_Header_ID
				inner join
				T_Faculty_Master as FM on FM.I_Faculty_Master_ID=SCR.I_Faculty_Master_ID
				inner join
				T_ERP_User as EU on EU.I_User_ID=FM.I_User_ID 
				inner join
				T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID 
				and SM.I_School_Group_ID=RSH.I_School_Group_ID and SM.I_Class_ID=RSH.I_Class_ID
				where SCR.I_Subject_ID=@iSubjectID and SCR.I_Student_Class_Routine_ID=@iStudentClassRoutineID
				and FM.I_Faculty_Master_ID=@FacultyID and RSD.I_Day_ID=DATEPART(WEEKDAY,@dtClassdate)
				and FM.I_Status=1
				) 
				BEGIN

					 

					 SELECT @ErrMessage='Invalid Request'

					 --print @ErrMessage

					 RAISERROR(@ErrMessage,11,1)

			

				END


				ELSE

				BEGIN


						select @CreatedBy=UM.I_User_ID from 
						T_Faculty_Master as FM 
						inner join
						T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID where 
						FM.I_Faculty_Master_ID=@FacultyID and FM.I_Status=1



						DECLARE cursor_log CURSOR
						FOR SELECT 
						    TeacherTimePlanID,
							SubjectStructurePlanID,
							CompletionPercentage, 
							TotalCompletionPercentage,
							Remarks,
							LearningOutcomeAchieved,
							IsCompleted
						FROM 
						@LogBookDetails;

						OPEN cursor_log;

						FETCH NEXT FROM cursor_log INTO 
							@TeacherTimePlanID,
							@SubjectStructurePlanID,
							@CompletionPercentage, 
							@TotalCompletionPercentage,
							@Remarks,
							@sLearningOutcomeAchieved,
							@IsCompleted

						WHILE @@FETCH_STATUS = 0
						BEGIN

						print @SubjectStructurePlanID

						print @TeacherTimePlanID

						IF @TeacherTimePlanID IS NULL

							BEGIN

								print @SubjectStructurePlanID

								insert into T_ERP_Teacher_Time_Plan
								select @iStudentClassRoutineID,@SubjectStructurePlanID,@dtClassdate,null,@CreatedBy,GETDATE()

								SET @iTeacherTimePlan=SCOPE_IDENTITY()

								print @iTeacherTimePlan

								IF @iTeacherTimePlan > 0
									BEGIN

										insert into T_ERP_Subject_Structure_Plan_Execution_Remarks
										select @iTeacherTimePlan,@CompletionPercentage,@IsCompleted,@Remarks,@sLearningOutcomeAchieved,@CreatedBy,GETDATE(),@dtClassdate,null,null

									END

							END

							ELSE
								BEGIN

									select @iRoutineHeaderID=RSD.I_Routine_Structure_Header_ID from 
									T_ERP_Teacher_Time_Plan as TTP 
									inner join
									T_ERP_Student_Class_Routine as SCR on TTP.I_Student_Class_Routine_ID=SCR.I_Student_Class_Routine_ID
									inner join 
									T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
									where TTP.I_Teacher_Time_Plan_ID=@TeacherTimePlanID


									
									


									IF NOT Exists
									(
									select DISTINCT SSP.I_Subject_Structure_Plan_ID,RSH.I_Routine_Structure_Header_ID
									from T_ERP_Teacher_Time_Plan as TTP
										inner join
										T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
										inner join
										T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
										inner join
										T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID
										inner join
										T_ERP_Student_Class_Routine as SCR on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID
										inner join
										T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
										inner join
										T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
										where 
										SCR.I_Subject_ID=@iSubjectID and RSD.I_Routine_Structure_Header_ID=@iRoutineHeaderID
										and SSP.I_Subject_Structure_Plan_ID=@SubjectStructurePlanID
									and CONVERT(DATE,TTP.Dt_Class_Date)>CONVERT(DATE,@DtClassDate)
										
									) 
									BEGIN


									update T_ERP_Subject_Structure_Plan_Execution_Remarks 
									set I_Completion_Percentage=@CompletionPercentage,Is_Completed=@IsCompleted,
									S_Remarks=@Remarks,I_UpdatedBy=@CreatedBy,Dt_UpdatedAt=GETDATE()
									,S_Learning_Outcome_Achieved=@sLearningOutcomeAchieved
									where I_Teacher_Time_Plan_ID=@TeacherTimePlanID

									--print @iTeacherTimePlan

									END

									ELSE

										BEGIN

											 SELECT @ErrMessage='LogBook Already Registered'

											 RAISERROR(@ErrMessage,11,1)

										END

								END
							


						 FETCH NEXT FROM cursor_log INTO 
							@TeacherTimePlanID,
							@SubjectStructurePlanID,
							@CompletionPercentage, 
							@TotalCompletionPercentage,
							@Remarks,
							@sLearningOutcomeAchieved,
							@IsCompleted
								; 
            
							END;

						CLOSE cursor_log;

						DEALLOCATE cursor_log;

						select 1 StatusFlag,'Log Book Details Successfully Saved' Message




				END




			END



	
commit transaction

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
