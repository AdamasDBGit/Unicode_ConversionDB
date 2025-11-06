-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddExtraClass]
(
	@ClassRoutineExtraClassID int = null,
	@FacultyMasterID int = null,
	@SubjectID int = null,
	@RoutineStrutureHeaderID int = null,
	@TFromSlot time(0) = null,
	@TToSlot time(0) = null,
	@Date date = null,
	@DayID int = null,
	@SubjectComponentID int = null,
	@CreatedBy int = null
)
AS
begin transaction
BEGIN TRY 
	SET NOCOUNT ON;

		DECLARE @maxTime time(0);
		SET @maxTime = (SELECT MAX(T_ToSlot) FROM T_ERP_Routine_Structure_Detail where I_Routine_Structure_Header_ID = @RoutineStrutureHeaderID AND I_Day_ID = @DayID)

		IF @maxTime IS NOT NULL
		BEGIN
			IF @TFromSlot <= @maxTime
			BEGIN
				SELECT 0 StatusFlag,'Class already scheduled for this time. Please choose a different time slot for the extra class' Message
			END
			ELSE 
			BEGIN 
				IF(@ClassRoutineExtraClassID IS NULL)
				BEGIN			
					INSERT INTO T_ERP_Student_Class_Routine_ExtraClass 
					(
						R_I_Faculty_Master_ID,
						R_I_Subject_ID,
						R_I_Routine_Structure_Header_ID,
						T_From_Slot,
						T_To_Slot,
						Dt_Period_Dt,
						I_Day_ID,
						I_Subject_Component_ID,
						Is_ExtraClass,
						Dtt_Created_At,
						I_Created_By,
						Is_Active
					)
					VALUES
					(
						@FacultyMasterID,
						@SubjectID,
						@RoutineStrutureHeaderID,
						@TFromSlot,
						@TToSlot,
						@Date,
						@DayID,
						@SubjectComponentID,
						1,
						GETDATE(),
						@CreatedBy,
						1
					)

					SELECT 1 StatusFlag,'Extra class added successfully' Message
				END			
				ELSE
				BEGIN
					UPDATE T_ERP_Student_Class_Routine_ExtraClass 
					SET
						R_I_Faculty_Master_ID = @FacultyMasterID,
						R_I_Subject_ID = @SubjectID,				
						T_From_Slot = @TFromSlot,
						T_To_Slot = @TToSlot,
						Dt_Period_Dt = @Date,
						I_Day_ID = @DayID,
						I_Subject_Component_ID = @SubjectComponentID,
						Dtt_Modified_At = GETDATE(),
						I_Modified_By = @CreatedBy
					WHERE I_ClassRoutine_ExtraClass_ID = @ClassRoutineExtraClassID

					SELECT 1 StatusFlag,'Extra class updated successfully' Message
				END
			END
		END		
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
