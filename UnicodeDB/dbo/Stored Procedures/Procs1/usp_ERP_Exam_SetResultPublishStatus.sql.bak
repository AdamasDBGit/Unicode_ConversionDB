CREATE PROCEDURE [dbo].[usp_ERP_Exam_SetResultPublishStatus]
(
    @inExamScheduleDetailId INT = NULL,
    @ClassId INT = NULL
)
AS
BEGIN TRY
    UPDATE T_ERP_Exam_ScheduleSubjectDetails
    SET inResultProcessStatus = 3
    WHERE 
        inExamScheduleDetailId = @inExamScheduleDetailId
        AND inClassId = @ClassId

	IF (
		(SELECT COUNT(*)
		 FROM T_ERP_Exam_ScheduleSubjectDetails
		 WHERE inExamScheduleDetailId = @inExamScheduleDetailId AND inClassId = @ClassId) =
		(SELECT COUNT(*)
		 FROM T_ERP_Exam_ScheduleSubjectDetails
		 WHERE inExamScheduleDetailId = @inExamScheduleDetailId
		   AND inClassId = @ClassId AND inResultProcessStatus = 3)
	)
	BEGIN
		UPDATE T_ERP_Exam_SchedulesDetails
		SET inResultProcessStatus = 3
		WHERE inExamScheduleDetailId  = @inExamScheduleDetailId
	END;
	ELSE 
	BEGIN
		UPDATE T_ERP_Exam_SchedulesDetails
		SET inResultProcessStatus = 2
		WHERE inExamScheduleDetailId = @inExamScheduleDetailId
	END

    SELECT 1 AS StatusFlag, 'Result is set for publish.' AS Message

END TRY
BEGIN CATCH
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT

    SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()

    RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH