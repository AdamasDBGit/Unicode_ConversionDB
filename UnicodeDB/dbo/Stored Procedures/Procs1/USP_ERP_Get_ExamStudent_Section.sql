--exec [USP_ERP_Get_ExamStudent_Section] 1,8
CREATE Proc [dbo].[USP_ERP_Get_ExamStudent_Section]
( @isectionid int,@ischeduleid int)
as
Begin
select distinct count(am.inExamScheduleSubjectDetailId) as cnt
,am.inStudentId as inStudentId 
,am.sReportCardUrl
,SD.S_Student_ID as sStudentID
,Sd.S_First_Name + 
    CASE 
        WHEN sd.S_Middle_Name IS NOT NULL AND sd.S_Middle_Name != '' 
        THEN ' ' + sd.S_Middle_Name 
        ELSE '' 
    END + 
    ' ' + sd.S_Last_Name AS sStudentName
,am.inExamScheduleDetailId
,TC.I_Class_ID		inClassId
,TC.S_Class_Name	stClassName
,TS.I_Section_ID	inSectionId
,TS.S_Section_Name	stSectionName
,TSS.I_Stream_ID	inStreamId
,TSS.S_Stream		stStreamName
from T_ERP_Exam_ScheduleSubjectAttendanceMarks  am
Inner Join T_ERP_Exam_ScheduleSubjectDetails ssd 
ON ssd.inExamScheduleDetailId=am.inExamScheduleDetailId 
and ssd.inExamScheduleSubjectDetailId=am.inExamScheduleSubjectDetailId
Inner Join T_Student_Detail SD ON SD.I_Student_Detail_ID=am.inStudentId
left join T_Class TC ON TC.I_Class_ID=ssd.inClassId
left join T_Section TS ON TS.I_Section_ID=ssd.inSectionId
LEFT join T_Stream TSS ON TSS.I_Stream_ID = ssd.inStreamId
where am.inExamScheduleDetailId=@ischeduleid and ssd.inSectionId=@isectionid
Group by inStudentId
,SD.S_Student_ID
,am.inExamScheduleDetailId
,am.sReportCardUrl
,TC.I_Class_ID		
,TC.S_Class_Name	
,TS.I_Section_ID	
,TS.S_Section_Name	
,TSS.I_Stream_ID	
,TSS.S_Stream		
,Sd.S_First_Name + 
    CASE 
        WHEN sd.S_Middle_Name IS NOT NULL AND sd.S_Middle_Name != '' 
        THEN ' ' + sd.S_Middle_Name 
        ELSE '' 
    END + 
    ' ' + sd.S_Last_Name
	End