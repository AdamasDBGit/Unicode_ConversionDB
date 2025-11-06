CREATE Proc USP_ERP_Get_ExamDropdown_Report  
(  
@SessionID int,
@schoolGroupID int,
@classID int,
@sectionID int  
)  
As   
Begin  
select Distinct ESD.inExamScheduleDetailId as Exam_ID, ESD.stExamName as ExamName  
from T_ERP_Exam_SchedulesDetails ESD  
Inner Join T_ERP_Exam_ScheduleSubjects ESS   
ON ESD.inExamScheduleDetailId=ESS.inExamScheduleDetailId  
Where ESD.inSchoolProgramId=@schoolGroupID and ESD.inAcademicSessionId=@SessionID  
and ESS.inClassId=@classID and (ESS.inSectionId=@sectionID OR @sectionID Is NULL)  
  
End