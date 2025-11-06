Create Proc Usp_ERP_GetParametersforTeacherTermWiseReport(
@brandID int,@SessionID INT
)
as
Begin
--Declare @brandID int=107,@SessionID INT=3
select Distinct TC.S_Class_Name AS Class_name,SM.I_Class_ID AS Class_ID,
SM.S_Subject_Name AS Subject_Name, FS.I_Subject_ID
,FS.I_Faculty_Master_ID as Faculty_ID,FM.S_Faculty_Name as Faculty_Name
,T1.inExamScheduleDetailId,ESD.stExamName
from T_ERP_Faculty_Subject FS
Inner Join T_Faculty_Master FM ON FM.I_Faculty_Master_ID=FS.I_Faculty_Master_ID
and FM.I_Brand_ID=@brandID
Inner Join T_Subject_Master SM ON SM.I_Subject_ID=FS.I_Subject_ID
Inner Join T_Class TC ON TC.I_Class_ID=SM.I_Class_ID and Tc.I_Brand_ID=@brandID
Inner Join T_School_Academic_Session_Master SS ON SS.I_Brand_ID=TC.I_Brand_ID
and SS.I_School_Session_ID=@SessionID
Inner Join
(
select Distinct ESS.inExamScheduleDetailId,ESS.inClassId,ESS.inSubjectID
,EFS.I_Faculty_Master_ID
from T_ERP_Exam_ScheduleSubjects ESS
Inner Join T_ERP_Faculty_Subject EFS ON EFS.I_Subject_ID=ESS.inSubjectID
Inner Join T_Subject_Master SM ON SM.I_Subject_ID=ESS.inSubjectID
and SM.I_Class_ID=ESS.inClassId and SM.I_Brand_ID=@brandID
Inner Join T_School_Academic_Session_Master SS ON SS.I_Brand_ID=SM.I_Brand_ID
and SS.I_School_Session_ID=@SessionID
) T1 ON T1.inClassId=TC.I_Class_ID and T1.inSubjectID=SM.I_Subject_ID
and T1.I_Faculty_Master_ID=FM.I_Faculty_Master_ID
Inner Join T_ERP_Exam_SchedulesDetails ESD 
ON ESD.inExamScheduleDetailId=T1.inExamScheduleDetailId
order by  FM.S_Faculty_Name, SM.I_Class_ID
End