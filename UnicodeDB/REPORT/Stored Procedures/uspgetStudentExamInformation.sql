CREATE PROCEDURE [REPORT].[uspgetStudentExamInformation]
(
@iStudentID int
)
as
begin

select

chn.S_Center_Name,cm.S_Course_Name,sbm.S_Batch_Name,sd.S_Student_ID,sbd.I_Student_ID,--ecm.I_Exam_Component_ID,
(

sd.S_First_Name+' '+(case when isnull(sd.S_Middle_Name,'')='' then '' else sd.S_Middle_Name end) +' '+
(

case when isnull(sd.S_Last_Name,'')='' then '' else sd.S_Last_Name end)) as Student_Name
,

sd.S_Mobile_No,tm.S_Term_Name,tm.I_Term_ID,
ecm

.S_Component_Name,sm.I_Exam_Total as Marks_Obtained,table1.highest_marks_batch,tes.I_TotMarks,ed.I_Employee_ID,
(

ed.S_First_Name+' '+(case when isnull(ed.S_Middle_Name,'')='' then '' else ed.S_Middle_Name end)+' '+
(

case when isnull(ed.S_Last_Name,'')='' then '' else ed.S_Last_Name end)) as FACULTY_NAME,ed.S_Phone_No

from T_Center_Hierarchy_Name_Details chn
inner

join T_Center_Batch_Details cb on cb.I_Centre_Id=chn.I_Center_ID
inner

join T_Student_Batch_Details sbd on sbd.I_Batch_ID=cb.I_Batch_ID
inner

join T_Student_Batch_Master sbm on sbm.I_Batch_ID=sbd.I_Batch_ID
inner

join T_Student_Course_Detail sc on sc.I_Student_Detail_ID=sbd.I_Student_ID
inner

join T_Course_Master cm on cm.I_Course_ID=sc.I_Course_ID
inner

join T_Student_Detail sd on sd.I_Student_Detail_ID=sbd.I_Student_ID
inner

join T_Term_Course_Map tc on tc.I_Course_ID=sc.I_Course_ID
inner

join T_Term_Master tm on tm.I_Term_ID=tc.I_Term_ID
inner

join T_Term_Eval_Strategy tes on tes.I_Term_ID=tm.I_Term_ID
inner

join T_Exam_Component_Master ecm on ecm.I_Exam_Component_ID=tes.I_Exam_Component_ID
inner

join EXAMINATION.T_Batch_Exam_Map bem on bem.I_Batch_ID=sbd.I_Batch_ID
left

join EXAMINATION.T_Batch_Exam_Faculty_Map bef on bef.I_Batch_Exam_ID=bem.I_Batch_Exam_ID
left

join T_Employee_Dtls ed on ed.I_Employee_ID=bef.I_Employee_ID
left

join EXAMINATION.T_Student_Marks sm on sm.I_Student_Detail_ID=sd.I_Student_Detail_ID
left

join
(

select I_Batch_Exam_ID, max(I_Exam_Total)as highest_marks_batch from EXAMINATION.T_Student_Marks group by I_Batch_Exam_ID) as table1
on

table1.I_Batch_Exam_ID=bem.I_Batch_Exam_ID
where sm.I_Batch_Exam_ID=bem.I_Batch_Exam_ID
and bem.I_Exam_Component_ID=ecm.I_Exam_Component_ID
and tes.I_Term_ID=bem.I_Term_ID
and tes.I_Status=1
--and sbm.I_Batch_ID=@batchID
and sd.I_Student_Detail_ID=@iStudentID
group

by chn.S_Center_Name,cm.S_Course_Name,sbm.S_Batch_Name,sbd.I_Student_ID,tes.I_Term_ID,sd.S_Student_ID,
sd

.S_First_Name,sd.S_Middle_Name,sd.S_Last_Name,sd.S_Mobile_No,tm.S_Term_Name,
ecm

.S_Component_Name,ed.S_First_Name,ed.I_Employee_ID,ed.S_Middle_Name,ed.S_Last_Name,ed.S_Phone_No,tes.I_TotMarks,
sm

.I_Exam_Total,table1.highest_marks_batch,tm.I_Term_ID,

cb.I_Centre_Id,cb.I_Batch_ID--,ecm.I_Exam_Component_ID
order

by S_Center_Name,ecm.S_Component_Name



end
