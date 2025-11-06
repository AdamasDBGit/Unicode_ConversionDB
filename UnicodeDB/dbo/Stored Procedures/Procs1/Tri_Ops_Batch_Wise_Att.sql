CREATE Proc [dbo].[Tri_Ops_Batch_Wise_Att]
@StartDate Date,
@EndDate   Date

As 
Begin
select Distinct 

F.S_Center_Name,
E.S_Batch_Name,
C.Total_Student,
D.Total_Class, 
(C.Total_Student*D.Total_Class) AS Tentative_Attendance,
sum (B.Student_Present) AS Actual_Attendance

from 

(

Select * from 
T_TimeTable_Master TTTM 

where convert (date,TTTM.Dt_Schedule_Date)between @StartDate and @EndDate and TTTM.I_Status=1 
and I_Is_Complete=1


) A 
inner join
(
select I_Batch_ID,COUNT(I_Student_ID) AS Total_Student 
from T_Student_Batch_Details where I_Batch_ID in (



select  distinct I_Batch_ID

from T_TimeTable_Master TTTM 

where convert (date,TTTM.Dt_Schedule_Date)between @StartDate and @EndDate


) and I_Status=1 group by I_Batch_ID


)C on C.I_Batch_ID=A.I_Batch_ID

inner join (

select  I_Batch_ID, COUNT(I_Module_ID)As Total_Class  


from T_TimeTable_Master TTTM 

where convert (date, TTTM.Dt_Schedule_Date)between @StartDate and @EndDate 
group by TTTM.I_Batch_ID

)D on D.I_Batch_ID=A.I_Batch_ID and D.I_Batch_ID=C.I_Batch_ID
inner join

(select distinct I_TimeTable_ID, COUNT(I_Student_Detail_ID) AS Student_Present 
from T_Student_Attendance where CONVERT(date, Dt_Crtd_On)  between @StartDate and @EndDate
group by I_TimeTable_ID
) B on A.I_TimeTable_ID=B.I_TimeTable_ID
inner join 
(

Select TSBM.I_Batch_ID, TSBM.S_Batch_Name 
from T_Student_Batch_Master TSBM

)E on E.I_Batch_ID=A.I_Batch_ID and E.I_Batch_ID=C.I_Batch_ID and E.I_Batch_ID=D.I_Batch_ID

inner join  (

select TCM.I_Centre_Id,TCM.S_Center_Name from T_Centre_Master TCM 
)F on F.I_Centre_Id=A.I_Center_ID

group by F.S_Center_Name,E.S_Batch_Name,C.Total_Student,D.Total_Class
order by F.S_Center_Name  ;

End
