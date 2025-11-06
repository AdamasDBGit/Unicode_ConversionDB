
CREATE PROCEDURE [REPORT].[uspGetStudentHomeWorkPrecnt]

(
@studentID  int,
@batchID  int,
@strtDt  datetime = NULL ,
@endDt  datetime = NULL
)

as begin

SELECT a.Assigned,b.Submitted FROM


(select A.I_Batch_ID b1, COUNT(A.I_Homework_ID)AS "Assigned",I_Batch_ID 
from EXAMINATION.T_Homework_Master A  
where A.I_Batch_ID=@batchID 

AND DATEDIFF(dd,A.Dt_Crtd_On,ISNULL(@strtDt,A.Dt_Crtd_On)) <= 0
AND DATEDIFF(dd,A.Dt_Crtd_On,ISNULL(@endDt,A.Dt_Crtd_On)) >= 0

-- A.Dt_Crtd_On between coalesce( @strtDt, s and @endDt
group by A.I_Batch_ID)a

inner join

(select hs.I_Student_Detail_ID, hm.I_Batch_ID b2,COUNT(hs.I_Homework_ID) AS "Submitted" 
from  EXAMINATION.T_Homework_Submission hs 
inner join EXAMINATION.T_Homework_Master hm
on hm.I_Homework_ID=hs.I_Homework_ID 
where hm.I_Batch_ID=@batchID 
AND DATEDIFF(dd,hm.Dt_Crtd_On,ISNULL(@strtDt,hm.Dt_Crtd_On)) <= 0
AND DATEDIFF(dd,hm.Dt_Crtd_On,ISNULL(@endDt,hm.Dt_Crtd_On)) >= 0

group by hm.I_Batch_ID,hs.I_Student_Detail_ID)b

on a.b1=b.b2

where b.I_Student_Detail_ID=@studentID
end
