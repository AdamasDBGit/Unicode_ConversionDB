-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec [dbo].[usp_ERP_GetRoutineDetails] 35, 1, 15, 1, 1
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetRoutineDetails]
(
	-- Add the parameters for the stored procedure here
	@SchoolSessionID INT = NULL,
    @SchoolGroupID INT = NULL,
    @ClassID INT = NULL,
    @StreamID INT = NULL,
    @SectionID INT = NULL    
)
AS
begin transaction
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	DECLARE @RoutineStructureHeaderID AS INT;
	set @RoutineStructureHeaderID = (select I_Routine_Structure_Header_ID from T_ERP_Routine_Structure_Header where (I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) and (I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) and (I_Class_ID=@ClassID OR @ClassID IS NULL) and (I_Stream_ID=@StreamID OR @StreamID IS NULL) and (I_Section_ID=@SectionID OR @SectionID IS NULL))			
								 
	select 
	TERSD.I_Period_No AS PeriodNumber, TERSD.I_Day_ID AS DayID, TERSD.T_FromSlot AS StartTime, TERSD.T_ToSlot AS EndTime, TERSD.I_Is_Break AS IsBreak
	from T_ERP_Routine_Structure_Detail AS TERSD INNER JOIN T_ERP_Routine_Structure_Header AS TERSH ON TERSD.I_Routine_Structure_Header_ID = TERSH.I_Routine_Structure_Header_ID
	WHERE TERSD.I_Routine_Structure_Header_ID=@RoutineStructureHeaderID
	order by TERSD.I_Day_ID asc,TERSD.I_Period_No asc;

	select 
	I_Total_Periods AS TotalPeriods, T_Start_Slot AS StartTimeOfFirstPeriod, T_Duration AS DurationOfEachPeriod, T_Period_Gap AS IntervalTimeBetweenTwoPeriods, I_Break_Period_No AS PeriodNumberBeforeLunchBreak, T_Break_Period_Duration AS LunchBreakDuration, I_No_Of_WeekDays AS NumberOfWeekDays, I_Routine_Structure_Header_ID AS HeaderID
	,I_FacultyClassTeacher as ClassFaculty
	from T_ERP_Routine_Structure_Header WHERE I_Routine_Structure_Header_ID=@RoutineStructureHeaderID;			

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
	
