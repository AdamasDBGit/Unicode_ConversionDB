  
--EXEC USP_ERP_Exam_GetExamScheduleClassList '07bdd020-9492-4d27-a7f1-bdf6d471c0e7'  
  
CREATE PROCEDURE USP_ERP_Exam_GetExamScheduleClassList  
(  
 @unExamScheduleDetailId UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
 SELECT   
  DISTINCT  
  SS.inClassId,  
  C.S_Class_Name AS stClassName  
 FROM   
  T_ERP_Exam_ScheduleSubjects SS  
  JOIN T_Class C ON C.I_Class_ID = SS.inClassId  
 WHERE   
  SS.inExamScheduleDetailId =   
      (SELECT SD.inExamScheduleDetailId   
             FROM T_ERP_Exam_SchedulesDetails SD   
             WHERE SD.unExamScheduleDetailId = @unExamScheduleDetailId)  
END