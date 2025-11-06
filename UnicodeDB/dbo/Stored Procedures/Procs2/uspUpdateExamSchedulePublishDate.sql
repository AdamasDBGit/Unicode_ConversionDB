--exec [uspGetAllResultByExamScheduleId] 3
CREATE PROCEDURE [dbo].[uspUpdateExamSchedulePublishDate]
(
	@inExamScheduleDetailId int = null,
	@dtDate datetime = null
)
AS

BEGIN TRY 

  UPDATE T_ERP_Exam_SchedulesDetails set dtPublishDate = @dtDate where inExamScheduleDetailId = @inExamScheduleDetailId
		select 1 StatusFlag,'Publish date and time updated' Message
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
