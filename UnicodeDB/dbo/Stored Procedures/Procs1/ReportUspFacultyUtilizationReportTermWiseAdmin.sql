CREATE PROCEDURE [dbo].[ReportUspFacultyUtilizationReportTermWiseAdmin](
@CourseName NVARCHAR(max)
,@VTerm NVARCHAR(max)
,@sTeacher NVARCHAR(max)=null
,@sSubject NVARCHAR(max)=null
)
	
AS
BEGIN

create table #Result

(I_Student_detail_ID nvarchar(max),Term_Name nvarchar(max),
Module_Name nvarchar(max), Subjec_Name nvarchar(max),Batch_Name nvarchar(max),
Marks NVARCHAR(max), Teacher nvarchar(max));

----------Inserting Result Table------

insert into #Result(I_Student_detail_ID,Term_Name,Module_Name,Subjec_Name,Batch_Name,Marks,Teacher)


select 
ETSM.I_Student_Detail_ID,
TTM.S_Term_Name,
TMM.S_Module_Name ,
TECM.S_Component_Name,
TSBM.S_Batch_Name, 
ISNULL (FORMAT (((ETSM.I_Exam_Total/TMES.I_TotMarks)*TMES.N_Weightage),'N2'),'0')as Marks_Obtain,
(TED.S_First_Name +' '+isnull(TED.S_Middle_Name,'')+' '+ TED.S_Last_Name) AS FacultyName

from EXAMINATION.T_Student_Marks ETSM
LEFT join EXAMINATION.T_Batch_Exam_Map ETBEM on ETSM.I_Batch_Exam_ID=ETBEM.I_Batch_Exam_ID
LEFT join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=ETBEM.I_Batch_ID 
LEFT join T_Centre_Master TCM on TCM.I_Centre_Id=ETSM.I_Center_ID
left join T_Term_Master TTM on TTM.I_Term_ID=ETBEM.I_Term_ID
left join T_Module_Master TMM on TMM.I_Module_ID=ETBEM.I_Module_ID
left join T_Exam_Component_Master TECM on TECM.I_Exam_Component_ID=ETBEM.I_Exam_Component_ID
left Join T_Module_Eval_Strategy TMES on TMES.I_Exam_Component_ID=TECM.I_Exam_Component_ID and
TMES.I_Exam_Component_ID=ETBEM.I_Exam_Component_ID and TMES.I_Module_ID=TMM.I_Module_ID and TMES.I_Term_ID=
TTM.I_Term_ID
left Join T_Course_Master TCCM on TCCM.I_Course_ID=TMES.I_Course_ID
INNER JOIN EXAMINATION.T_Batch_Exam_Faculty_Map AS TBEFM ON TBEFM.I_Batch_Exam_ID = ETBEM.I_Batch_Exam_ID
INNER JOIN dbo.T_Employee_Dtls AS TED ON TED.I_Employee_ID = TBEFM.I_Employee_ID
and TED.I_Status=3


where 

TTM.I_Brand_ID=107 
and TCCM.S_Course_Name=@CourseName
and TMES.I_Status=1
and TMM.I_Status=1

group by 

TMM.I_Module_ID, 
TMM.S_Module_Name,
TECM.S_Component_Name,
TSBM.S_Batch_Name,
ETSM.I_Student_Detail_ID,
TMES.I_TotMarks ,
TMES.N_Weightage ,
ETSM.I_Exam_Total,
(TED.S_First_Name +' '+isnull(TED.S_Middle_Name,'')+' '+ TED.S_Last_Name),
TTM.S_Term_Name

order by 

ETSM.I_Student_Detail_ID, 
TMM.S_Module_Name

;

---- CREATING UTILITY TABLE TO SUM ALL THE MARKS FOR UNIQUE STUDENT TERM WISE---

create table #Utility(
I_Student_Detail_ID nvarchar(max), Term_Name nvarchar(max),Subject_Name nvarchar(max),
Batch_Name nvarchar(max), Total_Marks NVARCHAR(max), Teacher nvarchar(max));


---- INSERTING UTILITY TABLE TO SUM ALL THE MARKS FOR UNIQUE STUDENT TERM WISE---

insert into #Utility(I_Student_Detail_ID,Term_Name,Subject_Name,Batch_Name,Total_Marks,Teacher)


select 
I_Student_detail_ID,
Term_Name,
Subjec_Name,
Batch_Name,
Sum(cast (Marks as decimal))AS Term_I_Total_Marks, 
Teacher

from #Result 

where Term_Name=@VTerm 

group by 

I_Student_detail_ID,
Term_Name,
Subjec_Name,
Batch_Name,
Teacher
;


select 

A.Batch_Name,
A.Teacher,
A.Subject_Name, 
isnull(A.Student,'0') AS R_0_To_40 ,
isnull(B.Student,'0') as R_41_To_60,
isnull(C.Student,'0') as R_61_To_80,
isnull(D.Student,'0') as R_81_To_100

from (
select Batch_Name,Teacher,Subject_Name, count (I_Student_Detail_ID) as Student, 
concat(Batch_Name,Teacher,Subject_Name) as ID
from #Utility 
where Total_Marks between 0 and 40 and Teacher = ISNULL(@sTeacher,Teacher) and Subject_Name=ISNULL(@sSubject,Subject_Name)
GROUP BY Batch_Name, Teacher,Subject_Name
)
A left join 
(
select Batch_Name,Teacher,Subject_Name, count (I_Student_Detail_ID) as Student 
,concat(Batch_Name,Teacher,Subject_Name) as ID
from #Utility 
where Total_Marks between 41 and 60
GROUP BY Batch_Name, Teacher,Subject_Name

)B on B.ID=A.ID


left join 

(

select Batch_Name,Teacher,Subject_Name, count (I_Student_Detail_ID) as Student 
,concat(Batch_Name,Teacher,Subject_Name) as ID
from #Utility 
where Total_Marks between 61 and 80
GROUP BY Batch_Name, Teacher,Subject_Name

)C on C.ID=A.ID


left join (
select Batch_Name,Teacher,Subject_Name, count (I_Student_Detail_ID) as Student 
,concat(Batch_Name,Teacher,Subject_Name) as ID
from #Utility 
where Total_Marks between 81 and 100
GROUP BY Batch_Name, Teacher,Subject_Name

)D on D.ID=A.ID

ORDER BY A.Teacher,B.Teacher, C.Teacher, D.Teacher


END


