CREATE PROCEDURE [dbo].[USP_ERP_Exam_GetExamAttendanceSubjectList]  
 @unExamScheduleDetailId UNIQUEIDENTIFIER,  
 @inClassId INT,  
 @inSectionId INT,  
 @inStreamId INT=NULL  
AS  
BEGIN  
 SELECT   
  SD.inExamScheduleDetailId,  
  SD.unExamScheduleDetailId,  
  SS.inClassId,  
  SS.stClassName,  
  SS.inSectionId,  
  SS.stSectionName,  
  SS.inStreamId,  
  SS.stStreamName,  
  SS.inSubjectTypeID,  
  SS.inSubjectID,  
  SS.stSubjectName,  
  SS.inSubjectComponentID,  
  SS.stSubjectComponentName,  
  SS.inDisplaySeq,  
  SS.inExamMode,  
  SS.inExamPlatform,  
  SS.dcFullMarks,  
  SS.dcMainExamFullMarks,  
  SS.dcInternalFullMarks,  
  SS.dcOrderallPassMarks,  
  SS.isPassMandatory,  
  SS.dtStartDate,  
  SS.dtEndDate,  
  SS.inExamSlotId,  
  SS.isDisplayOnApp,  
  SS.inExamInvigilatorId,  
  UI.S_First_Name + ' ' + ISNULL(UI.S_Middle_Name,'') + ' ' + ISNULL(UI.S_Last_Name,'') AS stExamInvigilatorName,  
  SS.inExamGraderId,  
  UG.S_First_Name + ' ' + ISNULL(UG.S_Middle_Name,'') + ' ' + ISNULL(UG.S_Last_Name,'') AS stExamGraderName,  
     SS.inAttendanceStatus  
 FROM   
  T_ERP_Exam_SchedulesDetails SD  
  LEFT JOIN T_ERP_Exam_ScheduleSubjectDetails SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
  LEFT JOIN T_ERP_User UI ON UI.I_User_ID = SS.inExamInvigilatorId  
  LEFT JOIN T_ERP_User UG ON UG.I_User_ID = SS.inExamGraderId  
 WHERE  
  SD.unExamScheduleDetailId = @unExamScheduleDetailId AND  
  SS.inClassId = @inClassId AND  
  SS.inSectionId = @inSectionId AND  
        (@inStreamId IS NULL OR SS.inStreamId = @inStreamId)  
END  