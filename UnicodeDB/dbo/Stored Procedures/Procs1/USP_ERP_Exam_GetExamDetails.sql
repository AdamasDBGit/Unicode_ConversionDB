  
CREATE PROCEDURE [dbo].[USP_ERP_Exam_GetExamDetails]  
(  
 @inExamScheduleDetailId INT,  
 @ClassId INT = NULL,  
 @SubjectId INT = NULL,  
 @SubjectTypeID INT = NULL,  
 @SubjectComponentID INT = NULL  
)  
AS  
BEGIN  
 SELECT   
  SD.inExamScheduleDetailId,  
  SD.unExamScheduleDetailId,  
  SD.stExamName,  
  SD.inExamTypeId,  
  ETM.stExamTypeName,  
  SD.inExamCategoryId,  
  ECM.stExamCategoryName,  
  SSD.dcFullMarks AS dcFullMarks,  
  '0' AS dcAvgMarks  
 FROM T_ERP_Exam_SchedulesDetails SD  
  LEFT JOIN T_ERP_Exam_ScheduleSubjects SSD ON SSD.inExamScheduleDetailId = SD.inExamScheduleDetailId  
  LEFT JOIN T_School_Group SC ON SC.I_School_Group_ID = SD.inSchoolProgramId  
  LEFT JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId  
  LEFT JOIN T_ERP_Exam_Category ECM ON ECM.inExamCategoryId = SD.inExamCategoryId  
  LEFT JOIN T_ERP_Exam_Grade_Master_Header EGM ON EGM.inExamGradeHederId = SD.inExamGradeID   
 WHERE  
  SD.inExamScheduleDetailId = @inExamScheduleDetailId   
  AND SSD.inClassId = @ClassId  
  AND SSD.inSubjectID = @SubjectId  
  AND SSD.inSubjectTypeID = @SubjectTypeID  
  AND SSD.inSubjectComponentID = @SubjectComponentID  
END  
  