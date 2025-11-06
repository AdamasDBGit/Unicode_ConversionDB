CREATE PROCEDURE [REPORT].[uspGetStudentTermAttendance]
(
@studentID as int,
@batchID as int,
@dt_to_date as date
)
as 
begin 


select  tm.S_Term_Name ,chn.S_Center_Name,sb.S_Batch_Name, A.I_Term_ID,[classes taken],[classes attended]
 from T_Center_Hierarchy_Name_Details chn
inner join T_Center_Batch_Details cb
	 on chn.I_Center_ID=cb.I_Centre_ID
inner join T_Student_Batch_Master sb
	 on sb.I_Batch_ID=cb.I_Batch_ID
inner join
(select I_Term_ID, COUNT(distinct I_Session_ID) AS "classes taken",I_Batch_ID 
from T_Student_Attendance_Details 
where I_Batch_ID=@batchID
and ISNULL(Dt_Attendance_Date,Dt_Schedule_Date)<@dt_to_date
 group by I_Term_ID,I_Batch_ID) A
on sb.I_Batch_ID=A.I_Batch_ID
left outer join
(select I_Term_ID,COUNT(distinct(I_Session_ID)) AS "classes attended"
from T_Student_Attendance_Details 
where I_Batch_ID=@batchID  
and I_Student_Detail_ID=@studentID
and ISNULL(Dt_Attendance_Date,Dt_Schedule_Date)<@dt_to_date 
group by I_Term_ID)B
on A.I_Term_ID=B.I_Term_ID
inner join dbo.T_Term_Master tm
on A.I_Term_ID=tm.I_Term_ID
end
