--exec [ups_ERP_Exam_getExamScheduleStudentListForSubject] 863,848,1  
CREATE PROCEDURE [dbo].[ups_ERP_Exam_getExamScheduleMarksStudentListForSubject]        
(        
    @inExamScheduleSubjectDetailId INT,        
    @inSubjectId INT,        
    @inSubjectComponentID INT = NULL        
)        
AS        
BEGIN        
Select DISTINCT      
  TEESSAM.inExamScheduleSubjectAttendanceMarksId,      
  TEESSD.inExamScheduleDetailId,        
  TEESSD.inExamScheduleSubjectDetailId,       
  TEESSD.stStudentName,      
  TEESSD.I_Student_Detail_ID AS inStudentID,      
  TEESSD.inSubjectID ,        
  TEESSD.inSubjectComponentID,                
  TEESSD.stClassName,        
  TEESSD.stSectionName,        
  TEESSD.stStreamName  ,      
  TEESSAM.inPresent  ,      
  TEESSAM.stAttendanceRemarks,        
  TEESSAM.dcObtainedMarks,        
  TEESSAM.inConduct,        
  TEESSAM.inRanks,        
  TEESSAM.inPaperStatus,        
  TEESSAM.stRemarks       
from (      
      
     SELECT          
    TEESSD.inExamScheduleDetailId,        
    TEESSD.inExamScheduleSubjectDetailId,        
    ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '') AS stStudentName             
    ,TEESSD.inSubjectID AS inSubjectID,        
    TEESSD.inSubjectComponentID,                
    TEESSD.stClassName,      
    TEESSD.inSectionId,    
    TEESSD.stSectionName,        
    TEESSD.stStreamName ,      
    TSD.I_Student_Detail_ID       
    FROM         
    T_ERP_Exam_ScheduleSubjectDetails TEESSD        
    JOIN T_ERP_Student_Subject TESS ON TESS.I_Subject_ID = TEESSD.inSubjectID        
    JOIN T_Student_Detail TSD  ON TSD.I_Student_Detail_ID = TESS.I_Student_Detail_ID        
    JOIN T_Student_Class_Section SCS ON SCS.I_Student_Detail_ID = TESS.I_Student_Detail_ID  AND SCS.I_Section_ID= TEESSD.inSectionId     
    WHERE         
    TEESSD.inExamScheduleSubjectDetailId = @inExamScheduleSubjectDetailId        
    AND TESS.I_Subject_ID = @inSubjectId        
    AND (TEESSD.inSubjectComponentID = @inSubjectComponentID   
 OR @inSubjectComponentID IS NULL)        
   ) AS  TEESSD      
 inner  Join      
       
 T_ERP_Exam_ScheduleSubjectAttendanceMarks TEESSAM      
 ON TEESSD.inExamScheduleDetailId=TEESSAM.inExamScheduleDetailId      
 And TEESSD.inExamScheduleSubjectDetailId=TEESSAM.inExamScheduleSubjectDetailId      
 and TEESSD.inSubjectID=TEESSAM.inSubjectId      
 and TEESSAM.inStudentId=TEESSD.I_Student_Detail_ID      
END
