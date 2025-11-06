CREATE PROCEDURE [REPORT].[uspGetFirst20Students_temp] -- exec [REPORT].[uspGetLast20Students] '2013-05-10',372,1
(
@examdate date,
@i_term_id int,
@iBrandId INT,    
@sHierarchyList VARCHAR(MAX),
@iRank INT,
@sResultType VARCHAR(MAX)=NULL
--@iexamcomp int
)

as 
begin


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
InstanceChain varchar(MAX),
Biology FLOAT, --Akash --
Chemistry FLOAT, 
 CA FLOAT,
 Economics FLOAT,
 English FLOAT, 
 GI FLOAT,
 GK FLOAT,
 Geo FLOAT,
 History FLOAT,
 Math FLOAT ,
 Physics FLOAT, 
 Politicalscience FLOAT     
--ExamComponentID int,
--ExamComponentName varchar(50)
--S_ExamComp varchar(MAX)
)



IF(@sResultType='Batchwise')
BEGIN

insert into #getlast20students
(
I_Student_Detail_Id,I_Term_Id,F_Total_marks,I_Rank,I_Batch_Id,I_Center_Id,InstanceChain
)
select sm.I_Student_Detail_ID,bm.I_Term_ID,SUM(sm.I_Exam_Total) as Total_Marks_Obtained,
DENSE_RANK() over (partition by bm.I_Batch_ID order by SUM(sm.I_Exam_Total) desc ) as Overall_Rank,
bm.I_Batch_ID,sm.I_Center_ID,FN2.InstanceChain
from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON sm.I_Center_Id=FN1.CenterID
INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
--inner join T_Exam_Component_Master ecm on bm.I_Exam_Component_ID=ecm.I_Exam_Component_ID
where DATEDIFF(dd,sm.Dt_Exam_Date,@examdate)=0
  and bm.I_Term_ID= @i_term_id
  --and ecm.I_Exam_Component_ID=@iexamcomp
--and bm.I_Batch_ID=@i_batch_id
--and sm.I_Center_ID IN(SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
group by bm.I_Term_ID,bm.I_Batch_ID,sm.I_Student_Detail_ID,sm.I_Center_ID,InstanceChain
order by bm.I_Term_ID,bm.I_Batch_ID;

END

ELSE IF (@sResultType='Termwise')

BEGIN

insert into #getlast20students
(
I_Student_Detail_Id,I_Term_Id,F_Total_marks,I_Rank,I_Batch_Id,I_Center_Id,InstanceChain
)
	
	select sm.I_Student_Detail_ID,bm.I_Term_ID,SUM(sm.I_Exam_Total) as Total_Marks_Obtained,
DENSE_RANK() over (partition by bm.I_Term_ID order by SUM(sm.I_Exam_Total) desc ) as Overall_Rank,
bm.I_Batch_ID,sm.I_Center_ID,FN2.InstanceChain
from EXAMINATION.T_Student_Marks sm inner join EXAMINATION.T_Batch_Exam_Map bm
on bm.I_Batch_Exam_ID=sm.I_Batch_Exam_ID
INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
ON sm.I_Center_Id=FN1.CenterID
INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
--inner join T_Exam_Component_Master ecm on bm.I_Exam_Component_ID=ecm.I_Exam_Component_ID
where DATEDIFF(dd,sm.Dt_Exam_Date,@examdate)=0
  and bm.I_Term_ID= @i_term_id
  --and ecm.I_Exam_Component_ID=@iexamcomp
--and bm.I_Batch_ID=@i_batch_id
--and sm.I_Center_ID IN(SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList) 
group by bm.I_Term_ID,bm.I_Batch_ID,sm.I_Student_Detail_ID,sm.I_Center_ID,InstanceChain
order by bm.I_Term_ID,bm.I_Batch_ID;
	
END

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

--Akash--
update #getlast20students set Biology=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=27
and
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)
--Akash--
--Amrita--
update #getlast20students set Chemistry=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=29
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)

update #getlast20students set CA=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=49
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)

update #getlast20students set Economics=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=32
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)

update #getlast20students set English=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=33
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)

update #getlast20students set GI=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=47
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)

update #getlast20students set GK=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=48
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
)

update #getlast20students set Geo=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=36
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
) 

update #getlast20students set History=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=37
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
) 

update #getlast20students set Math=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=40
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
) 

update #getlast20students set Physics=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=41
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
) 

update #getlast20students set Politicalscience=
(select TOP 1 A.I_Exam_Total from EXAMINATION.T_Student_Marks A
inner join EXAMINATION.T_Batch_Exam_Map B on A.I_Batch_Exam_ID=B.I_Batch_Exam_ID
inner join T_Exam_Component_Master C on B.I_Exam_Component_ID=C.I_Exam_Component_ID
where
C.I_Exam_Component_ID=42
and 
A.Dt_Exam_Date=@examdate
and
A.I_Student_Detail_ID=#getlast20students.I_Student_Detail_Id
) 
--delete #getlast20students where I_Center_Id!=@@sHierarchyList

select * from #getlast20students where I_Rank<=@iRank AND #getlast20students.F_Total_marks IS NOT NULL ORDER BY I_Rank ASC ;

end
