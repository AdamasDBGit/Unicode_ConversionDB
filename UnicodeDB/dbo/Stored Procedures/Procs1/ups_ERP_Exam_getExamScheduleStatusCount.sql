-- Author: Qutub Haider  
-- Create date: 2024-08-16  
  
--EXEC ups_ERP_Exam_getExamScheduleStatusCount 52  
  
CREATE PROCEDURE [dbo].[ups_ERP_Exam_getExamScheduleStatusCount]   
(  
 @inUserId INT = NULL  
)  
AS  
BEGIN  
      
    DECLARE @inMainExam INT;  
    DECLARE @inInternalExam INT;  
 DECLARE @inNotYetStarted INT;  
 DECLARE @inInProgress INT;  
 DECLARE @inReadyForMarksEntry INT;  
     
    SELECT   
  @inMainExam = COUNT(DISTINCT SD.inExamScheduleDetailId)  
    FROM T_ERP_Exam_SchedulesDetails SD   
 JOIN T_ERP_Exam_ScheduleSubjects SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
 JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId  
    WHERE   
     ETM.IsMainExam = 0  
  --AND (SS.inExamInvigilatorId = @inUserId OR SS.inExamGraderId = @inUserId OR SD.inCreatedBy = @inUserId)  
  
 SELECT   
  @inInternalExam = COUNT(DISTINCT SD.inExamScheduleDetailId)  
    FROM T_ERP_Exam_SchedulesDetails SD   
 JOIN T_ERP_Exam_ScheduleSubjects SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
 JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId  
    WHERE   
    ETM.IsMainExam = 1  
  --AND (SS.inExamInvigilatorId = @inUserId OR SS.inExamGraderId = @inUserId OR SD.inCreatedBy = @inUserId)  
  
  
 SELECT   
  @inNotYetStarted = COUNT(DISTINCT SD.inExamScheduleDetailId)   
 FROM T_ERP_Exam_SchedulesDetails SD   
 JOIN T_ERP_Exam_ScheduleSubjects SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
 WHERE   
  inSaveType = 0  
  --AND (SS.inExamInvigilatorId = @inUserId OR SS.inExamGraderId = @inUserId OR SD.inCreatedBy = @inUserId)  
   
  
 SELECT  
  @inInProgress = COUNT(DISTINCT SD.inExamScheduleDetailId)   
 FROM T_ERP_Exam_SchedulesDetails SD   
 JOIN T_ERP_Exam_ScheduleSubjects SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
 WHERE   
  inSaveType = 1  
  --AND (SS.inExamInvigilatorId = @inUserId OR SS.inExamGraderId = @inUserId OR SD.inCreatedBy = @inUserId)  
   
  
 SELECT   
  @inReadyForMarksEntry = COUNT(DISTINCT SD.inExamScheduleDetailId)   
 FROM T_ERP_Exam_SchedulesDetails SD   
 JOIN T_ERP_Exam_ScheduleSubjects SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
 WHERE   
  inSaveType = 2  
  --AND (SS.inExamInvigilatorId = @inUserId OR SS.inExamGraderId = @inUserId OR SD.inCreatedBy = @inUserId)  
  
    -- Return the result  
    SELECT @inMainExam AS inMainExam, @inInternalExam AS inInternalExam, @inNotYetStarted AS inNotYetStarted, @inInProgress AS inInProgress, @inReadyForMarksEntry AS  inReadyForMarksEntry;  
END