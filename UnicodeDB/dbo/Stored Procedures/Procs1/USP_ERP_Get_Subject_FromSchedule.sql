CREATE Procedure [dbo].[USP_ERP_Get_Subject_FromSchedule]
(
@brandID int,@scheduleID int
)
As 
Begin
Select distinct inSubjectID,SM.S_Subject_Name SubjectName from T_ERP_Exam_ScheduleSubjects ESS
Inner join T_Subject_Master SM ON SM.I_Subject_ID=ESS.inSubjectID 
and SM.I_Brand_ID=@brandID

where inExamScheduleDetailId=@scheduleID
End