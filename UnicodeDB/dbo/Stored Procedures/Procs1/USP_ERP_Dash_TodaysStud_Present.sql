--EXEC USP_ERP_Dash_TodaysStud_Present 107
CREATE Proc [dbo].[USP_ERP_Dash_TodaysStud_Present] (@brandID int)  
As   
begin  
---Declare @brandID int =107  
Declare @TotalStudentCount int,@PresentStudent_Count int  
  
select @TotalStudentCount= COUNT(Distinct I_Student_Detail_ID)   
from T_Student_Class_Section where I_Status=1   
and I_Brand_ID=@brandID  
--Select @TotalStudentCount  
  
select @PresentStudent_Count= COUNT(a.I_Student_Detail_ID)  
from T_ERP_Attendance_Entry_Detail  a
Inner Join T_ERP_Attendance_Entry_Header Aeh 
on Aeh.I_Attendance_Entry_Header_ID=a.I_Attendance_Entry_Header_ID
Inner Join T_Student_Class_Section b on a.I_Student_Detail_ID=b.I_Student_Detail_ID
where convert(date,aeh.Dt_Date) =CONVERT(Date,getdate()) and a.I_IsPresent=1  
and b.I_Brand_ID=@brandID
Select @PresentStudent_Count as Today_Present,@TotalStudentCount as TotalStudentCount  
End

--select * from T_ERP_Attendance_Entry_Detail