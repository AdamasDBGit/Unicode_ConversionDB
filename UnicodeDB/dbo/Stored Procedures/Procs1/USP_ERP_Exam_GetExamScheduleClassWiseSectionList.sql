  
CREATE PROCEDURE USP_ERP_Exam_GetExamScheduleClassWiseSectionList  
(  
 @unExamScheduleDetailId UNIQUEIDENTIFIER,  
 @inClassId INT  
)  
AS  
BEGIN  
 SELECT   
  DISTINCT  
  SS.inSectionId,  
  S.S_Section_Name AS stSectionName  
 FROM   
  T_ERP_Exam_ScheduleSubjects SS  
  JOIN T_Section S ON S.I_Section_ID = SS.inSectionId  
 WHERE   
  SS.inExamScheduleDetailId =   
      (SELECT SD.inExamScheduleDetailId   
             FROM T_ERP_Exam_SchedulesDetails SD   
             WHERE SD.unExamScheduleDetailId = @unExamScheduleDetailId)  
  AND SS.inClassId = @inClassId  
END