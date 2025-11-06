

CREATE PROCEDURE [dbo].[USP_ERP_Exam_InsertOrUpdateScheduleSubjectAttendanceMarksAPI]
(
    @examScheduleSubjectDetailId INT = NULL,
    @AttendanceMarks dbo.UT_StudentExamDetails READONLY,
    @token nvarchar(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @inCreatedBy int;
        SET @inCreatedBy = (SELECT I_User_ID FROM T_ERP_User WHERE S_Token = @token);

        DECLARE @inExamScheduleDetailId int = 
            (SELECT TOP 1 inExamScheduleDetailId 
             FROM T_ERP_Exam_ScheduleSubjectDetails 
             WHERE inExamScheduleSubjectDetailId = @examScheduleSubjectDetailId);

        DECLARE @inSubjectId int = 
            (SELECT TOP 1 inSubjectID 
             FROM T_ERP_Exam_ScheduleSubjectDetails 
             WHERE inExamScheduleSubjectDetailId = @examScheduleSubjectDetailId);

        UPDATE T_ERP_Exam_ScheduleSubjectDetails
        SET inAttendanceStatus = 2
        WHERE inExamScheduleSubjectDetailId = @examScheduleSubjectDetailId;

        -- Merge statement to handle both insert and update operations
        MERGE INTO [T_ERP_Exam_ScheduleSubjectAttendanceMarks] AS target
        USING @AttendanceMarks AS source
        ON target.inExamScheduleSubjectAttendanceMarksId = source.ExamScheduleSubjectAttendanceMarksId

        WHEN MATCHED THEN
            UPDATE SET
                target.inPresent = source.Status,
                target.inModifiedBy = @inCreatedBy,
                target.dtModifiedDate = GETDATE(),
                target.inPaperStatus = source.PaperStatus,
                target.stRemarks = source.Remark

        WHEN NOT MATCHED BY TARGET AND 
             (source.ExamScheduleSubjectAttendanceMarksId IS NULL OR 
              source.ExamScheduleSubjectAttendanceMarksId = 0) THEN
            INSERT (
                inExamScheduleSubjectDetailId,
                inExamScheduleDetailId,
                inSubjectId,
                inPresent,
                inCreatedBy,
                dtCreatedDate,
                inStudentId,
                inPaperStatus,
                stRemarks
            )
            VALUES (
                @examScheduleSubjectDetailId,
                @inExamScheduleDetailId,
                @inSubjectId,
                source.Status,
                @inCreatedBy,
                GETDATE(),
                source.StudentDetailId,
                source.PaperStatus,
                source.Remark
            );

        -- Additional validation for attendance statuses
        IF @inExamScheduleDetailId IS NOT NULL
        BEGIN
            IF (
                (SELECT COUNT(*)
                 FROM T_ERP_Exam_ScheduleSubjectDetails
                 WHERE inExamScheduleDetailId = @inExamScheduleDetailId) =
                (SELECT COUNT(*)
                 FROM T_ERP_Exam_ScheduleSubjectDetails
                 WHERE inExamScheduleDetailId = @inExamScheduleDetailId
                   AND inAttendanceStatus = 3)
            )
            BEGIN
                UPDATE T_ERP_Exam_SchedulesDetails
                SET inAttendanceStatus = 3
                WHERE inExamScheduleDetailId = @inExamScheduleDetailId;
            END;
            ELSE
            BEGIN
                UPDATE T_ERP_Exam_SchedulesDetails
                SET inAttendanceStatus = 2
                WHERE inExamScheduleDetailId = @inExamScheduleDetailId;
            END;
        END;
        ELSE
        BEGIN
            PRINT 'No valid ExamScheduleDetailId found in @AttendanceMarks.';
        END;

        COMMIT TRANSACTION;

        -- Return success message
        SELECT 1 AS StatusFlag, 'Exam Attendance saved successfully!' AS Message;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Return error message
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
