


--EXEC uspGetAllResultByStudentId_Combine 147982

create  PROCEDURE [dbo].[uspGetAllResultByStudentId_Combine]            
(            
 @iStudentResultID int = null            
)            
AS            
            
BEGIN TRY   
--declare @iStudentResultID int=148125
Declare @childScheduleID int,@MainScheduleID int,@Child_iStudentResultID int ,@StudentdetailID int
SET @MainScheduleID=(
select distinct I_Result_Exam_Schedule_ID  from T_Student_Result 
where I_Student_Result_ID=@iStudentResultID
)
SET @childScheduleID=(
select Child_I_Result_Exam_Schedule_ID from T_ERP_Result_Combine_Rule 
where Main_I_Result_Exam_Schedule_ID=@MainScheduleID
)
SET @StudentdetailID=
(
select I_Student_Detail_ID  from T_Student_Result where I_Student_Result_ID=@iStudentResultID

)
SET @Child_iStudentResultID=(
select  I_Student_Result_ID from T_Student_Result where I_Student_Detail_ID=@StudentdetailID
and I_Result_Exam_Schedule_ID=@childScheduleID
)
--select @iStudentResultID, @Child_iStudentResultID


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
 --,TRES.Title   
 ,Case When 
 RCR.Exam_name is NUll Then TRES.Title
 Else RCR.Exam_name end as Title
 ,TSR.S_Student_ID StudentID            
 ,TSG.S_School_Group_Code as SchoolGroupCode            
 ,ISNULL(TS.S_Section_Name,'A') Section            
 ,TSR.I_Total_Class  TotalClass             
 ,TSR.I_Total_Attendance  TotalAttendance            
 ,CAST(TSR.D_Attendance_Pecentage AS INT)  AttendancePerentage            
 ,CAST(TSR.I_Aggregate_Obtained_Marks AS decimal(18,2)) AggregateObtainedMarks             
 ,TSR.S_CT_Remarks Remarks            
 ,'https://adamasworldschool.s3.ap-south-1.amazonaws.com/result/'+TRES.S_Class_Teacher_Signature  ClassTeacherSignature            
 ,'https://adamasworldschool.s3.ap-south-1.amazonaws.com/result/'+TRES.S_Principal_Signature  PrincipalSignature            
 ,CONVERT(VARCHAR, TRES.Dt_Result_Publish_Date, 103)  ResultPublishDate            
 ,TSG.I_Brand_Id  BrandID          
 ,ISNULL(TRES.I_Is_Attendance,0) IsAttendance          
 ,ISNULL(TRES.I_Is_Remarks,0) IsRemarks          
 ,TRES.IsAnnual          
 ,TSR.Promoted_Batch PromotedTo      
 ,Case When RRD.I_Result_Exam_Schedule_ID Is null Then 0 Else 1 End as Data_Validity       
 ,TRES.Is_Online as Is_Online   
 ,Convert(varchar,TRES.dt_Exam_Dt,103) As ExamDate  
 ,Is_Internal as Is_Internal
 ,Convert(varchar,TRES.dt_Exam_Dt,103) As ExamDate  
 ,ISnull(TRES.is_CBT,0) as Is_CBT  
 --,SD.Dt_Birth_Date as DOB  
 ,SD.CBT_Email as CBT_email  
 ,TRES.WRT_Time as Writing_Time  
 ,TSR.I_Student_Rank as StudentRank
 ,TRES.TemplateID as TemplateID
 FROM T_Student_Result TSR inner join T_Result_Exam_Schedule TRES             
 ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID            
 inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID            
 inner join T_School_Group TSG ON TSG.I_School_Group_ID = TSGC.I_School_Group_ID            
 inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID            
 inner join T_School_Academic_Session_Master TSASM ON TSASM.I_School_Session_ID = TRES.I_School_Session_ID            
 left join T_School_Class_Teacher TSCM ON TSCM.I_School_Class_Teacher_ID = TSR.I_School_Class_Teacher_ID            
 left join T_Section TS ON TS.I_Section_ID =  TSR.I_Section_ID            
 left join T_Stream STREAM ON STREAM.I_Stream_ID = TSR.I_Stream_ID           
 Left Join T_Result_Rule_Dtl RRD on RRD.I_Result_Exam_Schedule_ID=TSR.I_Result_Exam_Schedule_ID 
 Left Join T_ERP_Result_Combine_Rule RCR on RCR.Main_I_Result_Exam_Schedule_ID=TSR.I_Result_Exam_Schedule_ID
  Left Join T_Student_Detail SD on SD.I_Student_Detail_ID=TSR.I_Student_Detail_ID  

 WHERE TSR.I_Student_Result_ID = ISNULL(@iStudentResultID,TSR.I_Student_Result_ID)

  -------Second Result Set -------------------------------         
      If  (@iStudentResultID  is NOt  NUll and   @Child_iStudentResultID is NOt Null)
   Begin       
 SELECT            
 TSR.I_Result_Exam_Schedule_ID as ResultExamScheduleID,            
  TSRD.I_Student_Result_Detail_ID AS StudentResultDetailID            
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
 --,TSRD.I_Sequnce_No    
 ,SQ.I_seq as I_Sequnce_No  
 ,TSRDB.S_Grade_Marks  GradeMarks            
 ,TSRDB.S_Exam_Attendance  ExamAttendance            
 ,TRSR.I_Subject_Sequence           
 ,RRD.S_Result_Exam_Schedule_Name as Result_col_Name          
 ,RRD.S_Latest_Group_Name          
  ,1 as Lebel        
  --,cast((TSRD.I_Obtained_Marks*0.6) as numeric(18,2)) as Cumalativepercentage1------New for Cumilative Percentage        
   , CASE       
        WHEN (TSRD.I_Obtained_Marks*0.6) - FLOOR((TSRD.I_Obtained_Marks*0.6)) >= 0.5 THEN CEILING((TSRD.I_Obtained_Marks*0.6))      
        ELSE FLOOR((TSRD.I_Obtained_Marks*0.6))      
    END AS Cumalativepercentage      
 from T_Student_Result_Detail TSRD             
 inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID            
 inner join T_Student_Result_Detail_Breakup TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID            
 inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Group_Rule_ID = TSRDB.I_Result_Subject_Group_Rule_ID            
 inner join T_Student_Result TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID            
 Left Join T_Result_Rule_Dtl RRD on RRD.I_Result_Exam_Schedule_ID=TRSR.I_Result_Exam_Schedule_ID
 Left Join T_ERP_EXAM_Subject_Seq SQ on SQ.S_Subject_name=TRSR.S_Subject_Name 
 --and SQ.I_Result_Exam_Schedule_ID=TSR.I_Result_Exam_Schedule_ID
 WHERE TSR.I_Student_Result_ID = ISNULL(@iStudentResultID,TSR.I_Student_Result_ID)   
 
 Union 
 SELECT            
 @MainScheduleID as ResultExamScheduleID,            
  TSRD.I_Student_Result_Detail_ID AS StudentResultDetailID            
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
 --,TSRD.I_Sequnce_No  
 ,SQ.I_seq as I_Sequnce_No  
 ,TSRDB.S_Grade_Marks  GradeMarks            
 ,TSRDB.S_Exam_Attendance  ExamAttendance            
 ,TRSR.I_Subject_Sequence           
 ,RRD.S_Result_Exam_Schedule_Name as Result_col_Name          
 ,RRD.S_Latest_Group_Name          
  ,1 as Lebel        
  --,cast((TSRD.I_Obtained_Marks*0.6) as numeric(18,2)) as Cumalativepercentage1------New for Cumilative Percentage        
   , CASE       
        WHEN (TSRD.I_Obtained_Marks*0.6) - FLOOR((TSRD.I_Obtained_Marks*0.6)) >= 0.5 THEN CEILING((TSRD.I_Obtained_Marks*0.6))      
        ELSE FLOOR((TSRD.I_Obtained_Marks*0.6))      
    END AS Cumalativepercentage      
 from T_Student_Result_Detail TSRD             
 inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID            
 inner join T_Student_Result_Detail_Breakup TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID            
 inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Group_Rule_ID = TSRDB.I_Result_Subject_Group_Rule_ID            
 inner join T_Student_Result TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID            
 Left Join T_Result_Rule_Dtl RRD on RRD.I_Result_Exam_Schedule_ID=TRSR.I_Result_Exam_Schedule_ID 
  Left Join T_ERP_EXAM_Subject_Seq SQ on SQ.S_Subject_name=TRSR.S_Subject_Name 
-- and SQ.I_Result_Exam_Schedule_ID=TSR.I_Result_Exam_Schedule_ID
 WHERE TSR.I_Student_Result_ID = ISNULL(@Child_iStudentResultID,TSR.I_Student_Result_ID) 
  Order by SQ.I_seq asc   
  End
  Else
  -----If Child ScheduleID not Exists
  Begin
  SELECT            
 TSR.I_Result_Exam_Schedule_ID as ResultExamScheduleID,            
  TSRD.I_Student_Result_Detail_ID AS StudentResultDetailID            
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
 --,TSRD.I_Sequnce_No    
 ,SQ.I_seq as I_Sequnce_No  
 ,TSRDB.S_Grade_Marks  GradeMarks            
 ,TSRDB.S_Exam_Attendance  ExamAttendance            
 ,TRSR.I_Subject_Sequence           
 ,RRD.S_Result_Exam_Schedule_Name as Result_col_Name          
 ,RRD.S_Latest_Group_Name          
  ,1 as Lebel        
  --,cast((TSRD.I_Obtained_Marks*0.6) as numeric(18,2)) as Cumalativepercentage1------New for Cumilative Percentage        
   , CASE       
        WHEN (TSRD.I_Obtained_Marks*0.6) - FLOOR((TSRD.I_Obtained_Marks*0.6)) >= 0.5 THEN CEILING((TSRD.I_Obtained_Marks*0.6))      
        ELSE FLOOR((TSRD.I_Obtained_Marks*0.6))      
    END AS Cumalativepercentage
	,Isnull(TSRD.get_correct,0) as get_correct
	,Isnull(TSRD.get_incorrect,0) as  get_incorrect
	,Isnull(TSRD.not_attempted,0) as not_attempted
	,isnull(TSRD.total_question,0) as total_question
 from T_Student_Result_Detail TSRD             
 inner join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Subject_Rule_ID = TSRD.I_Result_Subject_Rule_ID            
 inner join T_Student_Result_Detail_Breakup TSRDB ON TSRDB.I_Student_Result_Detail_ID = TSRD.I_Student_Result_Detail_ID            
 inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Group_Rule_ID = TSRDB.I_Result_Subject_Group_Rule_ID            
 inner join T_Student_Result TSR ON TSR.I_Student_Result_ID = TSRD.I_Student_Result_ID            
 Left Join T_Result_Rule_Dtl RRD on RRD.I_Result_Exam_Schedule_ID=TRSR.I_Result_Exam_Schedule_ID
 Left Join T_ERP_EXAM_Subject_Seq SQ on SQ.S_Subject_name=TRSR.S_Subject_Name 
 --and SQ.I_Result_Exam_Schedule_ID=TSR.I_Result_Exam_Schedule_ID
 WHERE TSR.I_Student_Result_ID = ISNULL(@iStudentResultID,TSR.I_Student_Result_ID) 
  Order by SQ.I_seq asc   
  End
-----------------------------------------------------------------------------
-------3rd Set-----------
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
 WHERE TSR.I_Student_Result_ID = ISNULL(@iStudentResultID,TSR.I_Student_Result_ID)            
 AND A.I_Status='1'            
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