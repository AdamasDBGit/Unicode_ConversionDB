CREATE PROCEDURE [REPORT].[uspGetTop20StudentsBatchwise] -- exec [REPORT].[uspGetLast20Students] '2013-05-10',372,1
(
@examdate date,
@i_term_id int,
@i_batch_id int,
@i_rank int,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX)
)

as 
begin
IF ( UPPER(@i_batch_id) = '--SELECT--'
             OR UPPER(@i_batch_id) = 'ALL'
           ) 
            BEGIN
                SET @i_batch_id = NULL
            END

create table #getlast20students
(
I_Center_Id int,
S_Center_Name varchar(50),
I_Student_Detail_Id int,
S_Student_Id varchar(50),
S_Student_Name varchar(80),
S_Mob_No varchar(50),
I_Term_Id int,
S_Term_Name varchar(50),
F_Total_marks float,
I_Rank int,
I_Batch_Id int,
S_Batch_name varchar(50),
S_Course_Name varchar(50),
InstanceChain varchar(MAX)
)
insert into #getlast20students
(
I_Student_Detail_Id,I_Term_Id,F_Total_marks,I_Rank,I_Batch_Id,I_Center_Id,InstanceChain
)
select sm.I_Student_Detail_ID,bm.I_Term_ID, SUM(sm.I_Exam_Total) as Total_Marks_Obtained,
DENSE_RANK() over (partition by bm.I_Batch_ID order by SUM(sm.I_Exam_Total) desc ) as Overall_Rank,
bm.I_Batch_ID,sm.I_Center_ID,FN2.InstanceChain
from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID 
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON sm.I_Center_Id=FN1.CenterID
INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
where DATEDIFF(dd,sm.Dt_Exam_Date,@examdate)=0
and bm.I_Term_ID= @i_term_id
and bm.I_Batch_ID=ISNULL(@i_batch_id,bm.I_Batch_ID)
--and bm.I_Batch_ID=@i_batch_id
--and sm.I_Center_ID IN(SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
group by bm.I_Term_ID,bm.I_Batch_ID,sm.I_Student_Detail_ID,sm.I_Center_ID,InstanceChain
order by bm.I_Term_ID,bm.I_Batch_ID;

update #getlast20students
set S_Student_Id=
(select sd.S_Student_ID from T_Student_Detail sd
where sd.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id);

update #getlast20students
set S_Student_Name=
(select sd.S_First_Name +' '+  isnull(sd.S_Middle_Name,'')+' '+sd.S_Last_Name from T_Student_Detail sd
where sd.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id);


update #getlast20students
set S_Mob_No=
(select sd.S_Mobile_No from T_Student_Detail sd
where sd.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id);



update #getlast20students
set S_Batch_name=
(select sbm.S_Batch_Name from T_Student_Batch_Master sbm
where sbm.I_Batch_ID=#getlast20students.I_Batch_Id);

update #getlast20students
set S_Center_Name=
(select cm.S_Center_Name from T_Centre_Master cm
where cm.I_Centre_Id=#getlast20students.I_Center_Id);

update #getlast20students
set S_Term_Name=
(
select tm.S_Term_Name from T_Term_Master tm 
where tm.I_Term_ID=#getlast20students.I_Term_Id
);

update #getlast20students
set S_Course_Name=
(select cm.S_Course_Name from T_Student_Batch_Master sbm 
inner join T_Course_Master cm
on cm.I_Course_ID=sbm.I_Course_ID
where #getlast20students.I_Batch_Id=sbm.I_Batch_ID);



--delete #getlast20students where I_Center_Id!=@@sHierarchyList

select * from #getlast20students where I_Rank<=@i_rank AND #getlast20students.F_Total_marks IS NOT NULL ;

end
