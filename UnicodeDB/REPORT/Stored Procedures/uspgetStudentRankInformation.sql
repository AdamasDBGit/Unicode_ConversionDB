CREATE PROCEDURE [REPORT].[uspgetStudentRankInformation]
(
@studentID int,
--@dt_from_date date,
@dt_to_date date
)
as
begin

select

chn.S_Center_Name,cm.S_Course_Name,sbm.S_Batch_Name,sbd.I_Student_ID,--ecm.I_Exam_Component_ID,
(

sd.S_First_Name+' '+(case when isnull(sd.S_Middle_Name,'')='' then '' else sd.S_Middle_Name end) +' '+
(

case when isnull(sd.S_Last_Name,'')='' then '' else sd.S_Last_Name end)) as Student_Name
,

sd.S_Mobile_No,tm.S_Term_Name,
ecm

.S_Component_Name,sm.I_Exam_Total as Marks_Obtained,table4.Total_Marks_Obtained,table1.Total_Attendance,table7.Total_Marks_Obtained as Overall_Highest_total,
table2.Center_Attendance,table3.Batch_Attendance,tes.I_TotMarks,ed.I_Employee_ID,
(

ed.S_First_Name+' '+(case when isnull(ed.S_Middle_Name,'')='' then '' else ed.S_Middle_Name end)+' '+
(

case when isnull(ed.S_Last_Name,'')='' then '' else ed.S_Last_Name end)) as FACULTY_NAME,ed.S_Phone_No,
table4.overall_rank,
table5.Center_Rank,
table6.Batch_Rank


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

select bm.I_Term_ID, COUNT(*) as Total_Attendance from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID group by bm.I_Term_ID) as table1
on

table1.I_Term_ID=tes.I_Term_ID
left

join
(

select bm.I_Term_ID,sm.I_Center_ID, COUNT(*) as Center_Attendance from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID group by bm.I_Term_ID,sm.I_Center_ID) as table2
on

table2.I_Term_ID=tes.I_Term_ID and table2.I_Center_ID=cb.I_Centre_Id
left

join
(

select bm.I_Term_ID,sm.I_Center_ID,bm.I_Batch_ID, COUNT(*) as Batch_Attendance from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID group by bm.I_Term_ID,sm.I_Center_ID,bm.I_Batch_ID) as table3
on

table3.I_Term_ID=tes.I_Term_ID and table3.I_Center_ID=cb.I_Centre_Id and table3.I_Batch_ID=cb.I_Batch_ID
left

join
(

select sm.I_Student_Detail_ID,bm.I_Term_ID, SUM(sm.I_Exam_Total) as Total_Marks_Obtained,
DENSE_RANK() over (partition by bm.I_Term_ID order by SUM(sm.I_Exam_Total) desc) as Overall_Rank
from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID
where sm.Dt_Crtd_On>@dt_to_date
 group by bm.I_Term_ID,sm.I_Student_Detail_ID

) as table4
on

table4.I_Student_Detail_ID=sm.I_Student_Detail_ID and table4.I_Term_ID=tm.I_Term_ID

left

join
(

select sm.I_Student_Detail_ID,bm.I_Term_ID,SUM(sm.I_Exam_Total) as Total_Marks_Obtained,sm.I_Center_ID,
DENSE_RANK() over (partition by bm.I_Term_ID,sm.I_Center_ID order by SUM(sm.I_Exam_Total) desc) as Center_Rank
from EXAMINATION.T_Student_Marks sm 
inner join EXAMINATION.T_Batch_Exam_Map bm on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID 
where sm.Dt_Crtd_On>@dt_to_date
group by bm.I_Term_ID,sm.I_Student_Detail_ID,SM.I_Center_ID) as table5
on

table5.I_Student_Detail_ID=sm.I_Student_Detail_ID and table5.I_Term_ID=tm.I_Term_ID and table5.I_Center_ID=cb.I_Centre_Id
left

join
(

select sm.I_Student_Detail_ID,bm.I_Term_ID,SUM(sm.I_Exam_Total) as Total_Marks_Obtained,sm.I_Center_ID,bm.I_Batch_ID,
DENSE_RANK() over (partition by bm.I_Term_ID,sm.I_Center_ID,bm.I_Batch_ID order by SUM(sm.I_Exam_Total)desc) as Batch_Rank
from EXAMINATION.T_Student_Marks sm 
inner join EXAMINATION.T_Batch_Exam_Map bm on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID
where sm.Dt_Crtd_On>@dt_to_date 
group by bm.I_Term_ID,sm.I_Student_Detail_ID,SM.I_Center_ID,bm.I_Batch_ID) as table6
on

table6.I_Student_Detail_ID=sm.I_Student_Detail_ID and table6.I_Term_ID=tm.I_Term_ID and table6.I_Center_ID=cb.I_Centre_Id
and table6.I_Batch_ID=cb.I_Batch_ID



inner join(

select bm.I_Term_ID, SUM(sm.I_Exam_Total) as Total_Marks_Obtained,
DENSE_RANK() over (partition by bm.I_Term_ID order by SUM(sm.I_Exam_Total) desc) as Overall_Rank
from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID
where sm.Dt_Crtd_On>@dt_to_date
 group by bm.I_Term_ID,sm.I_Student_Detail_ID

) as table7
on
 table7.I_Term_ID=tm.I_Term_ID





where sm.I_Batch_Exam_ID=bem.I_Batch_Exam_ID
and bem.I_Exam_Component_ID=ecm.I_Exam_Component_ID
and table7.Overall_Rank=1
and tes.I_Term_ID=bem.I_Term_ID AND sm.I_Student_Detail_ID=@studentID
and table5.Center_Rank IS not null



group

by chn.S_Center_Name,cm.S_Course_Name,sbm.S_Batch_Name,sbd.I_Student_ID,tes.I_Term_ID,
sd

.S_First_Name,sd.S_Middle_Name,sd.S_Last_Name,sd.S_Mobile_No,tm.S_Term_Name,
ecm

.S_Component_Name,ed.S_First_Name,ed.I_Employee_ID,ed.S_Middle_Name,ed.S_Last_Name,ed.S_Phone_No,tes.I_TotMarks,
sm

.I_Exam_Total,table1.Total_Attendance,table2.Center_Attendance,table3.Batch_Attendance,

cb.I_Centre_Id,sbm.I_Batch_ID,ecm.I_Exam_Component_ID,table4.Total_Marks_Obtained,tm.I_Term_ID
,table4.overall_rank,table5.Center_Rank,table6.Batch_Rank--,ecm.I_Exam_Component_ID
,table7.Total_Marks_Obtained 
order

by chn.S_Center_Name,sbm.S_Batch_Name,tm.S_Term_Name,table4.Total_Marks_Obtained
end
