CREATE PROCEDURE [dbo].[uspGetStudentResult]
(
 @sStudentID nnvarchar(max)= null
,@iIsLatest int = null
)
AS
BEGIN
if(@iIsLatest=0)
SET @iIsLatest = null
SELECT * 
FROM (
SELECT 
  TSR.S_Student_ID StudentID
 ,TSR.I_Student_Detail_ID  StudentDetailID
 ,TRES.Title Title
,TSR.I_Batch_ID BatchId
,TSR.I_Course_ID CourseID
,TSR.I_Term_ID TermID
,ISNULL(TSR.I_Aggregate_Full_Marks,0.00) AggregateFullMarks
,ISNULL(TSR.I_Aggregate_Obtained_Marks,0.00) AggregateObtainedMarks
,ISNULL(TSR.I_Aggregate_Percentage,0.00) AggregatePercentage
,ISNULL(TSR.I_Aggregrate_Class_Average_Percentage,0.00) AggregrateClassAveragePercentage
,ISNULL(TSR.I_Aggregate_Class_Highest_Percentage,0.00) AggregateClassHighestPercentage
,ISNULL(TSR.I_Aggregate_Section_Highest_Percentage,0.00) AggregateSectionHighestPercentage
,ISNULL(TSR.I_Attendance_Percentage,0.00) AttendancePercentage
,TSR.I_IsPromoted IsPromoted
,TRES.Dt_Result_Publish_Date ResultDate
,TSR.I_Student_Rank StudentRank
,TSR.I_Total_Students TotalStudents
,TSR.S_Student_Name StudentName 
,TRES.Title TermName
,ISNULL(TRES.I_Result_Publish_Status,0) IsPublished
,ISNULL(TSR.I_IsReportCardGenerate,0) IsReportCardGenerate
,case when LATEST.S_Student_ID is not null then 1 else 0 end as IsLatest
FROM T_Student_Result TSR
inner join T_Result_Exam_Schedule as TRES ON TRES.I_Result_Exam_Schedule_ID =  TSR.I_Result_Exam_Schedule_ID
left join (select S_Student_ID,MAX(Dt_ResultDate) as Dt_ResultDate from T_Student_Result where S_Student_ID =  @sStudentID group by S_Student_ID) LATEST
ON LATEST.S_Student_ID = TSR.S_Student_ID AND TSR.Dt_ResultDate = LATEST.Dt_ResultDate
where TSR.S_Student_ID =  @sStudentID  and TSR.I_IsHold !=1 
) T1 
where IsLatest = ISNULL(0,T1.IsLatest)  order by ResultDate desc
--and case when LATEST.S_Student_ID is not null then 1 else 0 end = ISNULL(@iIsLatest,0)

select 
 TSR.S_Student_ID StudentID
,TSR.I_Batch_ID  BatchID
,TRES.I_Course_ID CourseID
,TRES.I_Term_ID TermID
,TRSR.S_Subject_Name SubjectName
,ISNULL(TSRD.I_Highest_Obtained_Marks,0.00) HighestObtainedMarks
,ISNULL(TSRD.I_Obtained_Marks,0.00) ObtainedMarks
,TSRD.I_Full_Marks FullMarks
from T_Student_Result_Detail AS TSRD 
INNER JOIN T_Student_Result AS TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID
inner join T_Result_Exam_Schedule as TRES ON TRES.I_Result_Exam_Schedule_ID =  TSR.I_Result_Exam_Schedule_ID
inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID
--inner join T_Exam_Component_Master TECM ON TECM.I_Exam_Component_ID = TSRD.I_Exam_Component_ID
where TSR.S_Student_ID = @sStudentID and TSR.I_IsHold !=1 and TRES.I_Result_Publish_Status =1
END
