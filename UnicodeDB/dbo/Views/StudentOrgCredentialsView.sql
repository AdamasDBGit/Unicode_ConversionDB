



CREATE VIEW [dbo].[StudentOrgCredentialsView]
as

select A.S_Student_ID,A.S_First_Name+' '+ISNULL(A.S_Middle_Name,'')+' '+A.S_Last_Name as StudentName,A.S_OrgEmailID,A.S_OrgEmailPassword,
F.S_Course_Name,
C.S_Batch_Code,C.S_Batch_Name,E.S_Center_Name,A.S_Mobile_No,A.S_Email_ID
from T_Student_Detail A
inner join T_Student_Batch_Details B on A.I_Student_Detail_ID=B.I_Student_ID
inner join T_Student_Batch_Master C on B.I_Batch_ID=C.I_Batch_ID
inner join T_Center_Batch_Details D on C.I_Batch_ID=D.I_Batch_ID
inner join T_Center_Hierarchy_Name_Details E on D.I_Centre_Id=E.I_Center_ID
inner join T_Course_Master F on C.I_Course_ID=F.I_Course_ID
where B.I_Status=1 and A.S_OrgEmailPassword is not null