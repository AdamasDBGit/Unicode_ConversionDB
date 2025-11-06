-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-06>
-- Description:	<Save Subject Plan Details>
-- =============================================
CREATE PROCEDURE [dbo].[ERP_uspSaveSubjectPlanDetails] 
	-- Add the parameters for the stored procedure here
	@SubjectPlanDetails UT_SubjectStructurePlanDetailsForInsertUpdate READONLY,
	@iAcademicSessionID INT=NULL
AS
begin transaction
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @iAcademicSessionID IS NULL
		BEGIN
			SET @iAcademicSessionID=2
		END

	DELETE from T_ERP_Subject_Structure_Plan_Detail 
	where I_Subject_Structure_Plan_Detail_ID in (
	select SSPD.I_Subject_Structure_Plan_Detail_ID from
	T_ERP_Subject_Structure_Plan as SSP
					inner join
					T_ERP_Subject_Structure_Plan_Detail as SSPD on SSP.I_Subject_Structure_Plan_ID=SSPD.I_Subject_Structure_Plan_ID
					inner join
					@SubjectPlanDetails as S on  SSP.I_Subject_ID=S.SubjectID and SSP.I_Month_No=S.MonthNo
					left join
					T_ERP_Teacher_Time_Plan as TTP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
					where TTP.Dt_Class_Date IS NULL
					and SSP.I_School_Session_ID=@iAcademicSessionID
					)

	DECLARE 
	@SubjectID int,
	@MonthNo int,
	@DayNo int,
	@SubjectStructureID int,
	@CreatedBy int,
	@SubjectPlanID int
	


	DECLARE cursor_log CURSOR
			FOR SELECT 
					SubjectID,
					MonthNo,
					DayNo,
					SubjectStructureID,
					CreatedBy
				FROM 
					@SubjectPlanDetails;

			OPEN cursor_log;

			FETCH NEXT FROM cursor_log INTO 
			   @SubjectID,
			   @MonthNo,
			   @DayNo,
			   @SubjectStructureID,
			   @CreatedBy

			WHILE @@FETCH_STATUS = 0
				BEGIN


				 

				if not exists(
				select * from T_ERP_Subject_Structure_Plan where I_Subject_ID=@SubjectID
				and I_Month_No=@MonthNo and I_Day_No=@DayNo and I_School_Session_ID=@iAcademicSessionID
				)	


				BEGIN

					insert into T_ERP_Subject_Structure_Plan 
					(
					I_Subject_ID,
					I_Day_No,
					I_Month_No,
					I_CreatedBy,
					Dt_CreatedAt,
					I_School_Session_ID
					)
					select @SubjectID,@DayNo,@MonthNo,@CreatedBy,GETDATE(),@iAcademicSessionID

					
					SELECT @SubjectPlanID=SCOPE_IDENTITY()

					
					
					

				END

				ELSE
					BEGIN

					select @SubjectPlanID=I_Subject_Structure_Plan_ID from T_ERP_Subject_Structure_Plan where I_Subject_ID=@SubjectID
				and I_Month_No=@MonthNo and I_Day_No=@DayNo and I_School_Session_ID=@iAcademicSessionID

					END


				if not exists(
					select * from T_ERP_Subject_Structure_Plan as SSP
					inner join
					T_ERP_Subject_Structure_Plan_Detail as SSPD on SSP.I_Subject_Structure_Plan_ID=SSPD.I_Subject_Structure_Plan_ID
					where SSPD.I_Subject_Structure_Plan_ID=@SubjectPlanID
					and SSP.I_Subject_ID=@SubjectID and SSP.I_Month_No=@MonthNo and SSP.I_Day_No=@DayNo 
					and SSPD.I_Subject_Structure_ID=@SubjectStructureID
					)

					BEGIN


						insert into T_ERP_Subject_Structure_Plan_Detail
						(
						I_Subject_Structure_Plan_ID,
						I_Subject_Structure_ID,
						I_CreatedBy,
						Dt_CreatedAt
						)
						select @SubjectPlanID,@SubjectStructureID,@CreatedBy,GETDATE()


					END




			   FETCH NEXT FROM cursor_log INTO 
				 @SubjectID,
				 @MonthNo,
				 @DayNo,
				 @SubjectStructureID,
			     @CreatedBy
					; 
            
				END;

			CLOSE cursor_log;

			DEALLOCATE cursor_log;

select 1 StatusFlag,'Lesson Plan Details Successfully Saved' Message
	
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
