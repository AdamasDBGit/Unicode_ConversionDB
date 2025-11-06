CREATE Proc [dbo].[Usp_ERP_get_ClassID_from_faculty]
(
@brandid int,@facultyID int
)
As Begin
Select Distinct  FS.I_Faculty_Master_ID,FS.I_Subject_ID,SM.I_Class_ID ClassID
,TC.S_Class_Name ClassName
from T_ERP_Faculty_Subject FS
Inner Join T_Subject_Master SM ON FS.I_Subject_ID=SM.I_Subject_ID
and SM.I_Brand_ID=@brandid
Inner Join T_Class TC ON TC.I_Class_ID=SM.I_Class_ID and TC.I_Brand_ID=@brandid
where FS.I_Faculty_Master_ID=@facultyID
End