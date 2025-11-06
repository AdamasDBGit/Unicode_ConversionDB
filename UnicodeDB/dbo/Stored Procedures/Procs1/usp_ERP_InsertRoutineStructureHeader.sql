-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec [dbo].[usp_ERP_InsertRoutineStructureHeader] 2, 1, 14, null, null, 6, '08:00:00', '00:40:00', '00:05:00', 4,'01:00:00', 6,1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_InsertRoutineStructureHeader]
(
	-- Add the parameters for the stored procedure here
	@SchoolSessionID INT = NULL,
    @SchoolGroupID INT = NULL,
    @ClassID INT = NULL,
    @StreamID INT = NULL,
    @SectionID INT = NULL,
    @TotalPeriods INT = NULL,
    @StartSlot time(0),
    @Duration time(0),
    @PeriodGap time(0),
	@BreakPeriodNo INT = NULL,
	@BreakPeriodDuration time(0),
	@NoOfWeekDays INT=NULL,
    @CreatedAt INT = NULL,
	@ClassFacultyID INT= NULL
)
AS
begin transaction
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF EXISTS(select I_Routine_Structure_Header_ID from T_ERP_Routine_Structure_Header where (I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) and (I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) and (I_Class_ID=@ClassID OR @ClassID IS NULL) and (I_Stream_ID=@StreamID OR @StreamID IS NULL) and (I_Section_ID=@SectionID OR @SectionID IS NULL))
		BEGIN
			DECLARE @RoutineStructureHeaderID AS INT;
			set @RoutineStructureHeaderID = (select I_Routine_Structure_Header_ID from T_ERP_Routine_Structure_Header where (I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) and (I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) and (I_Class_ID=@ClassID OR @ClassID IS NULL) and (I_Stream_ID=@StreamID OR @StreamID IS NULL) and (I_Section_ID=@SectionID OR @SectionID IS NULL))									


			select 0 StatusFlag,'Routine already exists for this school information' Message,@RoutineStructureHeaderID as HeaderID;
		END
	ELSE
		BEGIN
			-- Insert statements for procedure here
			INSERT INTO [dbo].[T_ERP_Routine_Structure_Header] 
			(
				I_School_Session_ID, 
				I_School_Group_ID, 
				I_Class_ID, 
				I_Stream_ID, 
				I_Section_ID, 
				I_Total_Periods, 
				T_Start_Slot, 
				T_Duration, 
				T_Period_Gap, 
				I_Break_Period_No,
				T_Break_Period_Duration,
				I_No_Of_WeekDays,
				I_CreatedAt, 
				Dt_CreatedAt,
				I_FacultyClassTeacher -- added : 2024-Oct-01
			)
			VALUES 
			(
				@SchoolSessionID, 
				@SchoolGroupID, 
				@ClassID, 
				@StreamID, 
				@SectionID, 
				@TotalPeriods, 
				@StartSlot, 
				@Duration, 
				@PeriodGap, 
				@BreakPeriodNo,
				@BreakPeriodDuration,
				@NoOfWeekDays,
				@CreatedAt, 
				GETDATE(),
				@ClassFacultyID
			);
			select 1 StatusFlag,'School and relevant information saved succesfully' Message, SCOPE_IDENTITY() as HeaderID;
		END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	select 0 StatusFlag,@ErrMsg Message
END CATCH
commit transaction
END
	
