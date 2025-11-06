
CREATE  PROCEDURE [EXAMINATION].[uspInsertIntoRank]
AS
BEGIN

INSERT INTO EXAMINATION.T_Student_Rank(I_Student_Detail_ID,I_Batch_ID,I_Term_ID,I_Course_ID,I_Module_ID,I_Session_ID,I_Rank) 
SELECT t2.I_Student_Detail_ID,
t3.I_Batch_ID,
t10.I_Term_ID,
t9.I_Course_ID,
t5.I_Module_ID,
t7.I_Rank_Session_ID,
CAST(t1.Student_Rank AS int) as Student_Rank
from EXAMINATION.Temp_Student_Rank as t1
inner join dbo.T_Student_Detail as t2 
on t1.Student_ID = t2.S_Student_ID
inner join dbo.T_Student_Batch_Master as t3 
on t3.S_Batch_Code = t1.S_Batch_Code
inner join dbo.T_Term_Master as t4 
on t4.S_Term_Name = t1.Term_Name
inner join dbo.T_Module_Master t5
on t5.S_Module_Name = t1.Module_Name
inner join dbo.T_Term_Master as t6
on t6.S_Term_Name = t1.Term_Name
inner join EXAMINATION.T_Rank_Session as t7
on t7.S_Rank_Session_Name = t1.Session_Name
inner join dbo.T_Course_Master as t9
on t9.S_Course_Name = t1.Course_Name
inner join dbo.T_Term_Course_Map as t10
on t10.I_Course_ID = t9.I_Course_ID
and t10.I_Term_ID = t6.I_Term_ID
inner join dbo.T_Module_Term_Map as t11
on t11.I_Module_ID = t5.I_Module_ID
and t11.I_Term_ID = t10.I_Term_ID
left join EXAMINATION.T_Student_Rank as t8
on t8.I_Student_Detail_ID = t2.I_Student_Detail_ID
and t8.I_Session_ID = t7.I_Rank_Session_ID
and t8.I_Batch_ID = t3.I_Batch_ID
and t8.I_Course_ID = t3.I_Batch_ID
where t8.I_Student_Detail_ID is null
group by
t2.I_Student_Detail_ID,
t3.I_Batch_ID,
t10.I_Term_ID,
t9.I_Course_ID,
t5.I_Module_ID,
t7.I_Rank_Session_ID,
t1.Student_Rank

 delete from EXAMINATION.Temp_Student_Rank

END
