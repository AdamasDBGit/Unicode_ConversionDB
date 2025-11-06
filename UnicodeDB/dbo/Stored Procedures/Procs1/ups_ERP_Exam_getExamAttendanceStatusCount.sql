-- Author: Qutub Haider  
-- Create date: 2024-08-16  
  
--EXEC [ups_ERP_Exam_getExamAttendanceStatusCount]  
  
CREATE PROCEDURE [dbo].[ups_ERP_Exam_getExamAttendanceStatusCount]  
(  
    @inExamScheduleDetailId INT,  
    @inClassId              INT,  
    @inStreamId             INT = NULL,  
    @inSectionId            INT,  
    @inExamInvigilatorId    INT = NULL,  
    @inExamGraderId         INT = NULL  
)  
AS  
BEGIN  
      
    DECLARE @inPending INT;  
    DECLARE @inProgress INT;  
    DECLARE @inCompleted INT;  
     
    SELECT @inPending = COUNT(*)  
    FROM T_ERP_Exam_ScheduleSubjectDetails  
    WHERE   
        inAttendanceStatus = 1   
        AND inExamScheduleDetailId = @inExamScheduleDetailId  
        AND inClassId = @inClassId  
        AND inSectionId = @inSectionId  
        AND (inStreamId = @inStreamId  
             OR inExamInvigilatorId = @inExamInvigilatorId   
             OR inExamGraderId = @inExamGraderId)  
  
    SELECT @inProgress = COUNT(*)  
    FROM T_ERP_Exam_ScheduleSubjectDetails  
    WHERE   
        inAttendanceStatus = 2   
        AND inExamScheduleDetailId = @inExamScheduleDetailId  
        AND inClassId = @inClassId  
        AND inSectionId = @inSectionId  
        AND (inStreamId = @inStreamId  
             OR inExamInvigilatorId = @inExamInvigilatorId   
             OR inExamGraderId = @inExamGraderId)  
      
    SELECT @inCompleted = COUNT(*)  
    FROM T_ERP_Exam_ScheduleSubjectDetails  
    WHERE   
        inAttendanceStatus = 3   
        AND inExamScheduleDetailId = @inExamScheduleDetailId  
        AND inClassId = @inClassId  
        AND inSectionId = @inSectionId  
        AND (inStreamId = @inStreamId  
             OR inExamInvigilatorId = @inExamInvigilatorId   
             OR inExamGraderId = @inExamGraderId)  
      
    SELECT @inPending AS inPending, @inProgress AS inInProgress, @inCompleted AS inCompleted;  
END  