--exec [uspGetAllResultByExamScheduleId] 3  
CREATE PROCEDURE [dbo].[uspGetAllResultByExamScheduleId_Bak_22122023]  
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
 ,ISNULL(TSR.S_Guardian_FM_Name,'NA') AS GuardianName  
 ,REPLACE(TC.S_Class_Name,'Class ', '') +' '+ISNULL(STREAM.S_Stream,'') ClassName  
 ,CONVERT(VARCHAR, TSR.S_DOB, 103)  DOB  
 ,TSASM.S_Label SessionName  
 ,TRES.Title  
 ,TSR.S_Student_ID StudentID  
 ,ISNULL(TS.S_Section_Name,'NA') Section  
 ,TSR.I_Total_Class  TotalClass   
 ,TSR.I_Total_Attendance  TotalAttendance  
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
  
 SELECT  
  TSRD.I_Student_Result_Detail_ID AS StudentResultDetailID  
  ,TSR.I_Student_Result_ID StudentResultID  
 ,TRSR.S_Subject_Name SubjectName  
 ,TRSR.S_Subject_Code SubjectCode  
 ,TSRD.I_Full_Marks SubjectFullMarks  
 ,TSRD.I_Obtained_Marks SubjectObtainedMarks  
 ,TRSGR.S_Group_Name GroupName  
 ,TSRDB.I_Full_Marks GroupFullMarks  
 ,TSRDB.I_Obtained_Marks AS GroupObtainedMarks  
 ,TSRDB.S_Grade_Marks  GradeMarks  
 ,TSRDB.S_Exam_Attendance  ExamAttendance  
 from T_Student_Result_Detail TSRD   
 inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID  
 inner join T_Student_Result_Detail_Breakup TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID  
 inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Group_Rule_ID = TSRDB.I_Result_Subject_Group_Rule_ID  
 inner join T_Student_Result TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID  
 inner join  T_Result_Exam_Schedule TRES  ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID  
  WHERE TRES.I_Result_Exam_Schedule_ID = ISNULL(@iExamScheduleID,TRES.I_Result_Exam_Schedule_ID)  
   order by TSRD.I_Sequnce_No asc  
    
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
