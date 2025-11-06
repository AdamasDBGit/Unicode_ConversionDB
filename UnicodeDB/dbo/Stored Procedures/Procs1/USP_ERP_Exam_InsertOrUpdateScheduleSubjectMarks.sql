-- Author: Qutub Haider  
-- Create date: 2024-08-25  

CREATE PROCEDURE [dbo].[USP_ERP_Exam_InsertOrUpdateScheduleSubjectMarks]  
(  
    @MarksStatus INT = NULL,  
    @MarksTable dbo.UT_Exam_ScheduleSubjectMarks READONLY  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
        BEGIN TRANSACTION;
		DECLARE @TotalSubjectCount INT;
        DECLARE @CompletedSubjectCount INT;
        DECLARE @ExamScheduleDetailId INT;
		-- Get the inExamScheduleDetailId from @MarksTable
        SELECT @ExamScheduleDetailId = (SELECT TOP 1 inExamScheduleDetailId
     
	 FROM @MarksTable);

		
        UPDATE T_ERP_Exam_ScheduleSubjectDetails
        SET inMarksStatus = @MarksStatus
        WHERE inExamScheduleSubjectDetailId IN (
            SELECT DISTINCT inExamScheduleSubjectDetailId
            FROM @MarksTable
        );

       
        MERGE INTO [T_ERP_Exam_ScheduleSubjectAttendanceMarks] AS target  
        USING @MarksTable AS source  
        ON target.inExamScheduleSubjectAttendanceMarksId = source.inExamScheduleSubjectAttendanceMarksId  
        
        WHEN MATCHED THEN  
            UPDATE SET  
                target.dcObtainedMarks = source.dcStudentMarks,  
                target.inModifiedBy = source.inCreatedBy,  
                target.dtModifiedDate = GETDATE(),
                target.inPaperStatus = source.inPaperStatus,
                target.stRemarks = source.stRemarks,
                target.inConduct = source.inConduct;


		-- Get the count of rows matching the inExamScheduleDetailId from @MarksTable
        SELECT @TotalSubjectCount = COUNT(1)
        FROM T_ERP_Exam_ScheduleSubjectDetails
        WHERE inExamScheduleDetailId = @ExamScheduleDetailId;


		 -- Get the count of rows where inMarksStatus = 3 for the same inExamScheduleDetailId
        SELECT @CompletedSubjectCount = COUNT(1)
        FROM T_ERP_Exam_ScheduleSubjectDetails
        WHERE inExamScheduleDetailId = @ExamScheduleDetailId
        AND inMarksStatus = 3;


				-- Check if TotalSubjectCount and CompletedSubjectCount are the same
        IF @TotalSubjectCount = @CompletedSubjectCount
        BEGIN
            -- Set iResultProcess = 2 (All subjects have inMarksStatus = 3)
            UPDATE T_ERP_Exam_SchedulesDetails
            SET inResultProcessStatus = 2
            WHERE inExamScheduleDetailId = @ExamScheduleDetailId;

            UPDATE T_ERP_Exam_ScheduleSubjectDetails
            SET inResultProcessStatus = 2
            WHERE inExamScheduleDetailId = @ExamScheduleDetailId;
        END
        ELSE
        BEGIN
            -- Set iResultProcess = 1 (Not all subjects have inMarksStatus = 3)
            UPDATE
                 T_ERP_Exam_SchedulesDetails
            SET inResultProcessStatus = 1
            WHERE inExamScheduleDetailId = @ExamScheduleDetailId;

            UPDATE
                 T_ERP_Exam_ScheduleSubjectDetails
            SET inResultProcessStatus = 1
            WHERE inExamScheduleDetailId = @ExamScheduleDetailId;

        END
  
        COMMIT TRANSACTION;  

        SELECT 1 AS StatusFlag, 'Exam Attendance saved successfully!' AS Message;  
  
    END TRY  
    BEGIN CATCH  
        IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION;  
        SELECT  
            ERROR_NUMBER() AS ErrorNumber,  
            ERROR_SEVERITY() AS ErrorSeverity,  
            ERROR_STATE() AS ErrorState,  
            ERROR_PROCEDURE() AS ErrorProcedure,  
            ERROR_LINE() AS ErrorLine,  
            ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH  
END;
