Create Proc USP_ERP_Get_Exam_Subject_Dropdown_Report
(
@scheduleID int
)
As 
Begin
select Distinct ESS.inSubjectID as SubjectID,SM.S_Subject_Name as SubjectName
from T_ERP_Exam_SchedulesDetails ESD
Inner Join T_ERP_Exam_ScheduleSubjects ESS 
ON ESD.inExamScheduleDetailId=ESS.inExamScheduleDetailId
Inner Join T_Subject_Master SM ON SM.I_Subject_ID=ESS.inSubjectID
Where ESD.inExamScheduleDetailId=@scheduleID

End 
