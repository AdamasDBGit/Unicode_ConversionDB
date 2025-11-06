CREATE PROCEDURE [dbo].[USP_ERP_Exam_InsertOrUpdateScheduleSubjectAttendanceMarks]  
(  
    @MarksStatus INT = NULL,  
    @AttendanceMarks dbo.UT_Exam_ScheduleSubjectAttendanceMarks READONLY  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
        BEGIN TRANSACTION;  
	
	

		 UPDATE T_ERP_Exam_ScheduleSubjectDetails
			SET inAttendanceStatus = @MarksStatus
			WHERE inExamScheduleSubjectDetailId IN (
				SELECT DISTINCT inExamScheduleSubjectDetailId
				FROM @AttendanceMarks
			);

        -- Merge statement to handle both insert and update operations
        MERGE INTO [T_ERP_Exam_ScheduleSubjectAttendanceMarks] AS target  
        USING @AttendanceMarks AS source  
        ON target.inExamScheduleSubjectAttendanceMarksId = source.inExamScheduleSubjectAttendanceMarksId  
        --AND source.inExamScheduleSubjectAttendanceMarksId IS NOT NULL  
        --AND source.inExamScheduleSubjectAttendanceMarksId <> 0  
  
        WHEN MATCHED THEN  
            UPDATE SET  
                target.inPresent = source.inPresent,  
                target.inModifiedBy = source.inCreatedBy,  
                target.dtModifiedDate = GETDATE(),
                target.inPaperStatus = source.inPaperStatus,
				target.stRemarks = source.stRemarks
  
        WHEN NOT MATCHED BY TARGET AND (source.inExamScheduleSubjectAttendanceMarksId IS NULL OR source.inExamScheduleSubjectAttendanceMarksId = 0) THEN  
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
                source.inExamScheduleSubjectDetailId,  
                source.inExamScheduleDetailId,  
                source.inSubjectId,  
                source.inPresent,  
                source.inCreatedBy,  
                GETDATE(),  
                source.inStudentId,
				source.inPaperStatus,
				source.stRemarks
            );  
  

		DECLARE @inExamScheduleDetailId INT;
		SELECT TOP 1 @inExamScheduleDetailId = inExamScheduleDetailId
		FROM @AttendanceMarks;
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
				WHERE inExamScheduleDetailId IN (
					SELECT DISTINCT inExamScheduleDetailId
					FROM @AttendanceMarks
				);
			END;
			ELSE 
			BEGIN
				UPDATE T_ERP_Exam_SchedulesDetails
				SET inAttendanceStatus = 2
				WHERE inExamScheduleDetailId IN (
					SELECT DISTINCT inExamScheduleDetailId
					FROM @AttendanceMarks
				);
			END
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
