  
  
CREATE PROCEDURE [dbo].[USP_ERP_Exam_UpdateExamReportCardUrlAndStatus]  
    @inExamScheduleDetailId INT,  
    @inStudentId INT,  
    @sReportCardUrl NVARCHAR(max)  
AS  
BEGIN  
    -- Start the transaction  
    BEGIN TRANSACTION;  
      
    -- Try to update the record  
    BEGIN TRY  
        UPDATE T_ERP_Exam_ScheduleSubjectAttendanceMarks  
        SET sReportCardUrl = @sReportCardUrl,  
            inReportCardStatus = 1  
        WHERE inExamScheduleDetailId = @inExamScheduleDetailId  
          AND inStudentId = @inStudentId;  
    SELECT 1 AS StatusFlag, 'Report Card saved successfully!' AS Message;  
        -- If successful, commit the transaction  
        COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        -- If there is an error, rollback the transaction  
        ROLLBACK TRANSACTION;  
  
        -- Optionally, you can log the error message here or rethrow it  
        THROW;  
    END CATCH  
END;  
