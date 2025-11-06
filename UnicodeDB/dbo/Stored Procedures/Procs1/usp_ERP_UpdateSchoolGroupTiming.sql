-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <27th Sept 2023>
-- Description:	<to update the school timing>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_UpdateSchoolGroupTiming]
	-- Add the parameters for the stored procedure here
		@UTSchoolGroupTiming UT_SchoolGroupTiming readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
  UPDATE T_School_Group_Class_Timing
		SET
			Start_Time = sgct.tStartTime,
			End_Time = sgct.tEndTime
		FROM @UTSchoolGroupTiming sgct
		WHERE T_School_Group_Class_Timing.I_School_Group_Class_Timing_ID = sgct.iGroupClassTimingID;
 SELECT 1 StatusFlag,'School Timing updated' Message
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
END CATCH
END
