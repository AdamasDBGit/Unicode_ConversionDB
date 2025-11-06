Create Proc USP_ERP_Get_Exam__Faculty_Dropdown_Report
(
@scheduleID int,@SubjectID int
)
As 
Begin
select Distinct FM.I_User_ID as FacultyID,FM.S_Faculty_Name as FacultyName
from T_ERP_Exam_SchedulesDetails ESD
Inner Join T_ERP_Exam_ScheduleSubjects ESS 
ON ESD.inExamScheduleDetailId=ESS.inExamScheduleDetailId
Inner Join T_Faculty_Master FM ON FM.I_User_ID=ESS.inExamInvigilatorId
Where ESD.inExamScheduleDetailId=@scheduleID and ESS.inSubjectID=@SubjectID

End 