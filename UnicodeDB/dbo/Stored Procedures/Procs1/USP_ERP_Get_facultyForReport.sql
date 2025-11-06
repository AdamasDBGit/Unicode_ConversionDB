CREATE Proc [dbo].[USP_ERP_Get_facultyForReport]
(@brandID int
)
As 
Begin
--Declare @brandID int=
Select I_Faculty_Master_ID FacultyID,S_Faculty_Name FacultyName 
from T_Faculty_Master
where I_Brand_ID=@brandID 
and I_Status=1
End 