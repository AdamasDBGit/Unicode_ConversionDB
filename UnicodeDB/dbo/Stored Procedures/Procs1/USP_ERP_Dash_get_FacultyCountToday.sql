CREATE Proc [dbo].[USP_ERP_Dash_get_FacultyCountToday]
(
@BrandID int
)
as begin
--Declare @BrandID int=107
Declare @TotalfacultyCount int,@FacultyPresent_Today int
Select @TotalfacultyCount= COUNT(I_Faculty_Master_ID) 
from T_Faculty_Master where I_Brand_ID=@BrandID
and I_Status=1
--Select @TotalfacultyCount

select @FacultyPresent_Today= COUNT(Distinct a.I_Faculty_Master_ID) 
from T_ERP_Attendance_Entry_Header a
Inner Join T_Faculty_Master f On a.I_Faculty_Master_ID=f.I_Faculty_Master_ID
where CONVERT(date,dt_date)=Convert(date,GETDATE())
and f.I_Brand_ID=@BrandID

Select @TotalfacultyCount as Total_Faculty,@FacultyPresent_Today as Today_Present_faculty
End