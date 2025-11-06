-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_AddRoutineDetails] 
(
	-- Add the parameters for the stored procedure here
	@SchoolSessionID INT = NULL,
    @SchoolGroupID INT = NULL,
    @ClassID INT = NULL,
    @StreamID INT = NULL,
    @SectionID INT = NULL,
	@RoutineStructureHeaderID int = null,
	@UTPeriod [UT_PeriodDetails] readonly,
	@CreatedBy int = null,
	@iClassFaculty int=null
)
AS
begin transaction
BEGIN
	BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
       SET NOCOUNT ON;
	   IF EXISTS(select I_Routine_Structure_Header_ID from T_ERP_Routine_Structure_Header where (I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) and (I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) and (I_Class_ID=@ClassID OR @ClassID IS NULL) and (I_Stream_ID=@StreamID OR @StreamID IS NULL) and (I_Section_ID=@SectionID OR @SectionID IS NULL))
		BEGIN
			DECLARE @VarRoutineStructureHeaderID AS INT;
			set @VarRoutineStructureHeaderID = (select I_Routine_Structure_Header_ID from T_ERP_Routine_Structure_Header where (I_School_Group_ID=@SchoolGroupID OR @SchoolGroupID IS NULL) and (I_School_Session_ID=@SchoolSessionID OR @SchoolSessionID IS NULL) and (I_Class_ID=@ClassID OR @ClassID IS NULL) and (I_Stream_ID=@StreamID OR @StreamID IS NULL) and (I_Section_ID=@SectionID OR @SectionID IS NULL))			
			
				update T_ERP_Routine_Structure_Header set I_FacultyClassTeacher=@iClassFaculty where I_Routine_Structure_Header_ID=@VarRoutineStructureHeaderID

			DELETE FROM T_ERP_Routine_Structure_Detail WHERE I_Routine_Structure_Header_ID = @VarRoutineStructureHeaderID; 
		END

	   INSERT INTO T_ERP_Routine_Structure_Detail
	   (
		   I_Routine_Structure_Header_ID
		   ,I_Period_No
		   ,T_FromSlot
		   ,T_ToSlot
		   ,I_Day_ID
		   ,I_Is_Break
		   ,I_CreatedBy
		   ,Dt_CreatedAt
	   )
	   select @RoutineStructureHeaderID,PeriodNumber, StartTime, EndTime, DayID, IsBreak,@CreatedBy,GETDATE() from  @UTPeriod
	   select 1 as statusFlag, 'Routine added successfully' as Message

	END TRY
	BEGIN CATCH  
		rollback transaction
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message		          
	END CATCH; 
commit transaction
END
