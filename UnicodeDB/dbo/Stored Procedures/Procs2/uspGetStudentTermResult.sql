--exec [dbo].[uspGetStudentTermResult] 1,'17-0009'  
CREATE PROCEDURE [dbo].[uspGetStudentTermResult]  
(  
@iResultExamScheduleID int = null  
 ,@sStudentID nvarchar(50)= null  
)  
AS  
BEGIN  
  
SELECT   
 TSR.S_Student_ID StudentID  
,TSR.I_Batch_ID BatchId  
,TSR.I_Course_ID CourseID  
,TSR.I_Term_ID TermID  
,TSR.I_Aggregate_Full_Marks   
,TSR.I_Aggregate_Obtained_Marks   
,TSR.I_Aggregate_Percentage   
,TSR.I_Aggregrate_Class_Average_Percentage   
,TSR.I_Aggregate_Class_Highest_Percentage   
,TSR.I_Aggregate_Section_Highest_Percentage   
,TSR.I_Total_Class  
,TSR.I_Total_Attendance  
,TSR.I_Attendance_Percentage   
,TSR.I_IsPromoted   
,TSR.Dt_ResultDate   
,TSR.I_Student_Rank   
,TSR.I_Total_Students   
,TSR.S_Student_Name    
,TSR.S_Guardian_FM_Name  
,TSR.S_DOB  
,TSR.S_CT_Remarks  
  
,TCM.S_Course_Name+' ('+TTM.S_Term_Name+')' TermName  
FROM T_Student_Result TSR  
inner join T_Result_Exam_Schedule as TRES ON TRES.I_Result_Exam_Schedule_ID =  TSR.I_Result_Exam_Schedule_ID  
inner join T_Student_Detail TSD on TSD.S_Student_ID = TSR.S_Student_ID  
inner join T_Course_Master TCM ON TCM.I_Course_ID = TSR.I_Course_ID  
inner join T_Term_Master TTM ON TTM.I_Term_ID = TSR.I_Term_ID  
  
where TSR.S_Student_ID =  @sStudentID   
AND TRES.I_Result_Exam_Schedule_ID =  @iResultExamScheduleID   
  
--and case when LATEST.S_Student_ID is not null then 1 else 0 end = ISNULL(@iIsLatest,0)  
  
select   
 TSR.S_Student_ID StudentID  
,TSR.I_Batch_ID  BatchID  
,TRES.I_Course_ID CourseID  
,TRES.I_Term_ID TermID  
--,TECM.S_Component_Name SubjectName  
,TSRD.I_Highest_Obtained_Marks HighestObtainedMarks  
,TSRD.I_Obtained_Marks ObtainedMarks  
,TSRD.I_Full_Marks FullMarks  
from T_Student_Result_Detail AS TSRD   
INNER JOIN T_Student_Result AS TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID  
inner join T_Result_Exam_Schedule as TRES ON TRES.I_Result_Exam_Schedule_ID =  TSR.I_Result_Exam_Schedule_ID  
--inner join T_Exam_Component_Master TECM ON TECM.I_Exam_Component_ID = TSRD.I_Exam_Component_ID  
where TSR.S_Student_ID = @sStudentID  
AND TRES.I_Result_Exam_Schedule_ID =  @iResultExamScheduleID   
END
