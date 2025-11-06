CREATE PROCEDURE [dbo].[usp_ERP_Exam_UpdateExamSchedulePublishDate]
(
    @inExamScheduleDetailId INT = NULL,
    @dtDate DATETIME = NULL,
    @ClassId INT = NULL
)
AS
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE T_ERP_Exam_ScheduleSubjectDetails 
    SET dtPublishDate = @dtDate 
    WHERE 
        inExamScheduleDetailId = @inExamScheduleDetailId
        AND inClassId = @ClassId

	--UPDATE T_ERP_Exam_SchedulesDetails 
 --   SET dtPublishDate = @dtDate 
 --   WHERE 
 --       inExamScheduleDetailId = @inExamScheduleDetailId
 --       AND inClassId = @ClassId

    IF @@ROWCOUNT = 0
    BEGIN
        -- No matching record found
        SELECT 0 AS StatusFlag, 'No matching record found to update.' AS Message;
        ROLLBACK TRANSACTION;
        RETURN;
    END

    COMMIT TRANSACTION;

    SELECT 1 AS StatusFlag, 'Publish date and time updated successfully.' AS Message;

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
