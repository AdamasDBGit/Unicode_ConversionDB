-- =============================================  
-- Author:      Qutub Haider  
-- Create date: 22 Aug 2024  
-- =============================================  
--EXEC [ups_ERP_Exam_getExamScheduleStudentListForSubject_New] 5,26,1  
  
--SELECT * FROM T_ERP_Exam_ScheduleSubjectAttendanceMarks  
  
CREATE PROCEDURE [dbo].[ups_ERP_Exam_getExamScheduleStudentListForSubject_New]  
(  
    @inExamScheduleDetailId INT,  
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
  TEESSD.I_Student_Detail_ID AS StudentID,
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
        --DISTINCT  
 -- TEESSAM.inExamScheduleSubjectAttendanceMarksId,   
  TEESSD.inExamScheduleDetailId,  
  TEESSD.inExamScheduleSubjectDetailId,  
  ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '') AS stStudentName       
  ,TEESSD.inSubjectID AS inSubjectID,  
  TEESSD.inSubjectComponentID,          
  TEESSD.stClassName,  
  TEESSD.stSectionName,  
  TEESSD.stStreamName  ,
  TSD.I_Student_Detail_ID
  --TEESSAM.inPresent  ,
  --TEESSAM.stAttendanceRemarks,  
  --TEESSAM.dcObtainedMarks,  
  --TEESSAM.inConduct,  
  --TEESSAM.inRanks,  
  --TEESSAM.inPaperStatus,  
  --TEESSAM.stRemarks  
     FROM   
        T_ERP_Exam_ScheduleSubjectDetails TEESSD  
        JOIN T_ERP_Student_Subject TESS ON TESS.I_Subject_ID = TEESSD.inSubjectID  
        JOIN T_Student_Detail TSD  ON TSD.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        JOIN T_Student_Class_Section SCS ON SCS.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
     WHERE   
        TEESSD.inExamScheduleDetailId = @inExamScheduleDetailId  
        AND TESS.I_Subject_ID = @inSubjectId  
        AND (TEESSD.inSubjectComponentID = @inSubjectComponentID OR @inSubjectComponentID IS NULL)  
    ) AS  TEESSD
	Left Join
	
	T_ERP_Exam_ScheduleSubjectAttendanceMarks TEESSAM
	ON TEESSD.inExamScheduleDetailId=TEESSAM.inExamScheduleDetailId
	And TEESSD.inExamScheduleSubjectDetailId=TEESSAM.inExamScheduleSubjectDetailId
	and TEESSD.inSubjectID=TEESSAM.inSubjectId
	and TEESSAM.inStudentId=TEESSD.I_Student_Detail_ID
END
