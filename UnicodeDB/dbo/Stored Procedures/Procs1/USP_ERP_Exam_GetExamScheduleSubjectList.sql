CREATE PROCEDURE [dbo].[USP_ERP_Exam_GetExamScheduleSubjectList]  
 @unExamScheduleDetailId UNIQUEIDENTIFIER,  
 @inClassId INT,  
 @inSectionId INT,  
 @inStreamId INT = NULL  
AS  
BEGIN  
   
SELECT   
  SD.inExamScheduleDetailId,  
  SD.unExamScheduleDetailId,  
  SS.inClassId,  
  SS.inSectionId,  
  SS.inStreamId,  
  S.S_Stream AS stStream,  
  SS.inSubjectTypeID,  
  SS.inSubjectID,  
  SM.S_Subject_Name AS stSubjectName,  
  SS.inSubjectComponentID,  
  ESC.S_Subject_Component_Name AS stSubjectComponentName,  
  SS.inDisplaySeq,  
  SS.inExamMode,  
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
  SS.inExamPlatform,  
  UI.S_First_Name+' '+ISNULL(UI.S_Middle_Name,'')+' '+ISNULL(UI.S_Last_Name,'') AS stExamInvigilatorName,  
  SS.inExamGraderId,  
  UG.S_First_Name+' '+ISNULL(UG.S_Middle_Name,'')+' '+ISNULL(UG.S_Last_Name,'') AS stExamGraderName  
 FROM T_ERP_Exam_SchedulesDetails SD  
  LEFT JOIN T_ERP_Exam_ScheduleSubjects SS ON SS.inExamScheduleDetailId = SD.inExamScheduleDetailId  
  LEFT JOIN T_Subject_Master SM ON SM.I_Subject_ID = SS.inSubjectID   
  LEFT JOIN T_ERP_Subject_Component ESC ON ESC.I_Subject_Component_ID = SS.inSubjectComponentID  
  LEFT JOIN T_Stream S ON S.I_Stream_ID = SS.inStreamId  
  LEFT JOIN T_ERP_User UI ON UI.I_User_ID = SS.inExamInvigilatorId  
  LEFT JOIN T_ERP_User UG ON UG.I_User_ID = SS.inExamGraderId  
 WHERE  
  SD.unExamScheduleDetailId = @unExamScheduleDetailId AND  
  SS.inClassId = @inClassId AND  
  SS.inSectionId = @inSectionId AND         (@inStreamId IS NULL OR SS.inStreamId = @inStreamId)  
END  