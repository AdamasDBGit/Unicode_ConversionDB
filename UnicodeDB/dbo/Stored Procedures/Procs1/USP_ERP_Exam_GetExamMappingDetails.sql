CREATE PROCEDURE [dbo].[USP_ERP_Exam_GetExamMappingDetails]  
(  
 @unExamScheduleDetailId UNIQUEIDENTIFIER,  
 @inSubjectID INT,  
 @inSubjectTypeID INT,  
 @inSubjectComponentID INT,  
 @SectionId INT,  
 @StreamId INT = NULL  
)  
AS  
BEGIN  
 SELECT   
  SSD.inExamScheduleSubjectDetailId,  
  SSD.unExamScheduleSubjectDetailId,  
  SD.inExamScheduleDetailId,  
  SD.unExamScheduleDetailId,  
  SD.stExamName,  
  SC.I_School_Group_ID AS  inSchoolGroupID,  
  SC.S_School_Group_Name AS stSchoolProgram,  
  SD.inAcademicSessionId AS inSessionID,  
  SD.inExamTypeId,  
  ETM.stExamTypeName,  
  SD.inExamCategoryId,  
  ECM.stExamCategoryName,  
  SD.inExamGradeID,  
  EGM.stGradeHederName AS stExamGradeName,  
  SSD.inClassId,  
  SSD.stClassName,  
  SSD.inSectionId,  
  SSD.stSectionName,  
  SSD.inStreamId,  
  SSD.stStreamName,  
  SSD.inSubjectID,  
  SSD.stSubjectName,  
  SSD.inSubjectTypeID,  
  SSD.stSubjectTypeName,  
  SSD.inSubjectComponentID,  
  SSD.stSubjectComponentName,  
  SD.inTotalWeightage  AS dcFullMarks,  
  SD.inMainInternalExamWeightage AS dcMainExamFullMarks,  
  SD.inInternalExamWeightage AS dcInternalFullMarks,  
  SSD.dcOrderallPassMarks,  
  SSD.inMappingStatus  
 FROM T_ERP_Exam_SchedulesDetails SD  
  LEFT JOIN T_ERP_Exam_ScheduleSubjectDetails SSD ON SSD.inExamScheduleDetailId = SD.inExamScheduleDetailId  
  LEFT JOIN T_School_Group SC ON SC.I_School_Group_ID = SD.inSchoolProgramId  
  LEFT JOIN T_ERP_Exam_Type_Master ETM ON ETM.inExamTypeID = SD.inExamTypeId  
  LEFT JOIN T_ERP_Exam_Category ECM ON ECM.inExamCategoryId = SD.inExamCategoryId  
  LEFT JOIN T_ERP_Exam_Grade_Master_Header EGM ON EGM.inExamGradeHederId = SD.inExamGradeID   
 WHERE  
  SD.unExamScheduleDetailId = @unExamScheduleDetailId   
  AND SSD.inSubjectID = @inSubjectID  
  AND SSD.inSubjectTypeID = @inSubjectTypeID  
  AND SSD.inSubjectComponentID = @inSubjectComponentID  
  AND SSD.inSectionId =  @SectionId  
  AND (SSD.inStreamId = @StreamId OR @StreamId IS NULL)  
END  
  