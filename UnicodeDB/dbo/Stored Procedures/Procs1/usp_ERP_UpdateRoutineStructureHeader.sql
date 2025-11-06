-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_UpdateRoutineStructureHeader]
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

		DECLARE @RoutineStructureHeaderID AS INT;
		set @RoutineStructureHeaderID = (select I_Routine_Structure_Header_ID from T_ERP_Routine_Structure_Header where (I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) and (I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) and (I_Class_ID=@ClassID OR @ClassID IS NULL) and (I_Stream_ID=@StreamID OR @StreamID IS NULL) and (I_Section_ID=@SectionID OR @SectionID IS NULL))			
			
		UPDATE T_ERP_Routine_Structure_Header SET I_Total_Periods=@TotalPeriods, T_Start_Slot=@StartSlot, T_Duration=@Duration, T_Period_Gap=@PeriodGap, I_Break_Period_No=@BreakPeriodNo, T_Break_Period_Duration=@BreakPeriodDuration, I_No_Of_WeekDays=@NoOfWeekDays, I_CreatedAt=@CreatedAt, Dt_CreatedAt=GETDATE(),I_FacultyClassTeacher=@ClassFacultyID WHERE I_Routine_Structure_Header_ID = @RoutineStructureHeaderID;
		DELETE FROM T_ERP_Routine_Structure_Detail WHERE I_Routine_Structure_Header_ID = @RoutineStructureHeaderID; 	

		select 1 StatusFlag,'Previous routine deleted successfully' Message,@RoutineStructureHeaderID as HeaderID;				
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
