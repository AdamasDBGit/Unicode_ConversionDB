CREATE PROCEDURE [dbo].[uspGetAllResultByExamScheduleId]  
(  
 @iExamScheduleID int = null  
)  
AS  
  
BEGIN TRY   
  
  SELECT   
  TSR.I_Student_Result_ID  StudentResultID  
 ,TSR.S_Student_Name Name  
 ,TSR.I_Student_Detail_ID  StudentDetailID  
 ,ISNULL(TSCM.S_Class_Teacher_Name,'')  ClassTeacherName  
 ,TRES.S_Principal_Name PrincipalName  
 ,ISNULL(TRES.I_Grade_Marks_View,0) GradeView  
 ,ISNULL(TRES.I_Is_Term_Exam,0) IsTermExam  
 ,ISNULL(TRES.I_Subject_Total_View,0) SubjectTotalView  
 ,ISNULL(TRES.I_Subject_Total_Grade_View,0) SubjectTotalGradeView  
 ,ISNULL(TSR.S_Guardian_FM_Name,'NA') AS GuardianName  
 ,REPLACE(TC.S_Class_Name,'Class ', '') +' '+ISNULL(STREAM.S_Stream,'') ClassName  
 ,CONVERT(VARCHAR, TSR.S_DOB, 103)  DOB  
 ,TSASM.S_Label SessionName  
 ,TRES.Title  
 ,TSR.S_Student_ID StudentID  
 ,TSG.S_School_Group_Code as SchoolGroupCode  
 ,ISNULL(TS.S_Section_Name,'A') Section  
 ,TSR.I_Total_Class  TotalClass   
 ,TSR.I_Total_Attendance  TotalAttendance  
 ,CAST(TSR.D_Attendance_Pecentage AS INT)  AttendancePerentage  
 ,CAST(TSR.I_Aggregate_Obtained_Marks AS INT) AggregateObtainedMarks   
 ,TSR.S_CT_Remarks Remarks  
 ,'https://adamasworldschool.s3.ap-south-1.amazonaws.com/result/'+TRES.S_Class_Teacher_Signature  ClassTeacherSignature  
 ,'https://adamasworldschool.s3.ap-south-1.amazonaws.com/result/'+TRES.S_Principal_Signature  PrincipalSignature  
 ,CONVERT(VARCHAR, TRES.Dt_Result_Publish_Date, 103)  ResultPublishDate  
 ,STREAM.S_Stream Stream  
 ,TSG.I_Brand_Id  BrandID  
 FROM T_Student_Result TSR inner join T_Result_Exam_Schedule TRES   
 ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID  
 inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID  
 inner join T_School_Group TSG ON TSG.I_School_Group_ID = TSGC.I_School_Group_ID  
 inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID  
 inner join T_School_Academic_Session_Master TSASM ON TSASM.I_School_Session_ID = TRES.I_School_Session_ID  
 left join T_School_Class_Teacher TSCM ON TSCM.I_School_Class_Teacher_ID = TSR.I_School_Class_Teacher_ID  
 left join T_Section TS ON TS.I_Section_ID =  TSR.I_Section_ID  
 left join T_Stream STREAM ON STREAM.I_Stream_ID = TSR.I_Stream_ID  
 WHERE TRES.I_Result_Exam_Schedule_ID = ISNULL(@iExamScheduleID,TRES.I_Result_Exam_Schedule_ID)  
 order by ISNULL(TS.S_Section_Name,'A')   
  
  
  select t1.* from   
 (  
 SELECT  
 TSR.I_Student_Detail_ID  StudentDetailID,  
  TSR.I_Result_Exam_Schedule_ID as ResultExamScheduleID,  
  TSRD.I_Student_Result_Detail_ID AS StudentResultDetailID  
  ,TSR.I_Student_Result_ID StudentResultID  
 ,TRSR.S_Subject_Name SubjectName  
 ,TRSR.S_Subject_Group_Name SubjectGroupName  
 ,TRSR.S_Subject_Code SubjectCode  
 ,TSRD.I_Full_Marks SubjectFullMarks  
 ,TSRD.I_Obtained_Marks SubjectObtainedMarks  
 ,TSRD.I_Highest_Obtained_Marks HighestObtainedMarks  
 ,TSRD.S_Highest_Grade_Marks HighestGradeMarks  
 ,TSRD.S_Grade_Marks SubjectTotalGrade  
 ,TSRD.S_Overall_Exam_Sub_Attendance OverallExamSubAttendance  
 ,TRSGR.S_Group_Name GroupName  
 ,TRSGR.S_Group_Name + '__'+CONVERT(nvarchar(30), CAST(TSRDB.I_Full_Marks AS INT))  GroupNameMarks  
 ,TSRDB.I_Full_Marks GroupFullMarks  
 ,TSRDB.I_Obtained_Marks AS GroupObtainedMarks  
 ,TSRD.I_Sequnce_No  
 ,TSRDB.S_Grade_Marks  GradeMarks  
 ,TSRDB.S_Exam_Attendance  ExamAttendance  
 ,TRSR.I_Subject_Sequence  
 from T_Student_Result_Detail TSRD   
 inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID  
 inner join T_Student_Result_Detail_Breakup TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID  
 inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Group_Rule_ID = TSRDB.I_Result_Subject_Group_Rule_ID  
 inner join T_Student_Result TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID  
 inner join  T_Result_Exam_Schedule TRES  ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID  
  WHERE TRES.I_Result_Exam_Schedule_ID = ISNULL(@iExamScheduleID,TRES.I_Result_Exam_Schedule_ID)  
 -- ## This section for previous exam schedule data  
UNION   
  
SELECT  
TSR.I_Student_Detail_ID  StudentDetailID,  
TSR2.I_Result_Exam_Schedule_ID as ResultExamScheduleID,  
  TSRD.I_Student_Result_Detail_ID AS StudentResultDetailID  
   ,TSR.I_Student_Result_ID StudentResultID  
 ,TRSR.S_Subject_Name SubjectName  
 ,TRSR.S_Subject_Group_Name SubjectGroupName  
 ,TRSR.S_Subject_Code SubjectCode  
 ,TSRD.I_Full_Marks SubjectFullMarks  
 ,TSRD.I_Obtained_Marks SubjectObtainedMarks  
 ,TSRD.I_Highest_Obtained_Marks HighestObtainedMarks  
 ,TSRD.S_Highest_Grade_Marks HighestGradeMarks  
 ,TSRD.S_Grade_Marks SubjectTotalGrade  
 ,TSRD.S_Overall_Exam_Sub_Attendance OverallExamSubAttendance  
 ,TRSGR.S_Group_Name GroupName  
 ,TRSGR.S_Group_Name + '__'+CONVERT(nvarchar(30), CAST(TSRDB.I_Full_Marks AS INT))  GroupNameMarks  
 ,TSRDB.I_Full_Marks GroupFullMarks  
 ,TSRDB.I_Obtained_Marks AS GroupObtainedMarks  
 ,TSRD.I_Sequnce_No  
 ,TSRDB.S_Grade_Marks  GradeMarks  
 ,TSRDB.S_Exam_Attendance  ExamAttendance  
 ,TRSR.I_Subject_Sequence  
 from T_Student_Result TSR   
 inner join  T_Result_Exam_Schedule TRES2  ON TRES2.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID  
 JOIN T_Student_Result TSR2 ON TSR2.I_Student_Detail_ID = TSR.I_Student_Detail_ID   
 AND TSR2.I_Student_Result_ID != TSR.I_Student_Result_ID  
 join T_Student_Result_Detail TSRD on TSR2.I_Student_Result_ID = TSRD.I_Student_Result_ID  
 inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID  
 inner join T_Student_Result_Detail_Breakup TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID  
 inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Group_Rule_ID = TSRDB.I_Result_Subject_Group_Rule_ID  
 inner join T_Result_Rule_Dtl as TRRD ON TSR2.I_Result_Exam_Schedule_ID = TRRD.I_Previous_Result_Exam_Schedule_ID   
 and TSR.I_Result_Exam_Schedule_ID = TRRD.I_Result_Exam_Schedule_ID  
WHERE TRES2.I_Result_Exam_Schedule_ID = ISNULL(@iExamScheduleID,TRES2.I_Result_Exam_Schedule_ID)  
 ) as t1  
order by t1.ResultExamScheduleID,t1.StudentResultID,t1.I_Subject_Sequence,t1.I_Sequnce_No asc  
,Case When t1.GroupName = 'Theory' Then 1  
 when t1.GroupName = 'Practical/ Internal Assessment' Then 2      
    Else 3 End   
 ;  
  
  
SELECT  
TSR.I_Student_Result_ID as StudentResultID  
,B.I_Student_Detail_ID,A.I_Term_ID,E.S_Term_Name,  
  C.I_Activity_ID,C.S_Activity_Name  
  ,D.I_Evaluation_ID,D.S_Evaluation_Name,max(A.S_Student_Grade) as S_Student_Grade  
 from T_Student_Result TSR   
 inner join T_Result_Exam_Schedule TRES ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID  
 inner join T_Student_Activity_Performance A on A.I_Term_ID = TRES.I_Term_ID  
  inner join T_Student_Activity_Details B on A.I_Student_Activity_ID=B.I_Student_Activity_ID   
   and B.I_Student_Detail_ID = TSR.I_Student_Detail_ID  
  inner join T_Activity_Master C on B.I_Activity_ID=C.I_Activity_ID  
  inner join T_Activity_Evaluation_Master D on A.I_Evaluation_ID=D.I_Evaluation_ID  
  inner join T_Term_Master E on A.I_Term_ID=E.I_Term_ID  
WHERE TRES.I_Result_Exam_Schedule_ID = ISNULL(@iExamScheduleID,TRES.I_Result_Exam_Schedule_ID)  
and A.I_Status='1'  
group by TSR.I_Student_Result_ID,C.I_Activity_ID  
 ,B.I_Student_Detail_ID,A.I_Term_ID,E.S_Term_Name,C.I_Activity_ID,C.S_Activity_Name  
  ,D.I_Evaluation_ID,D.S_Evaluation_Name  
 ORDER BY C.I_Activity_ID  
    
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH