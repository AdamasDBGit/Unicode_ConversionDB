-- exec [ERP_Usp_get_Previous_StudAttendance] '2024-04-05',435
CREATE Proc [dbo].[ERP_Usp_get_Previous_StudAttendance](@Cur_Date date,@Student_Class_Routine_ID int)
As BEGIN
--Declare @Cur_Date date 
Declare 
--@Student_Class_Routine_ID int,
@Attendance_Entry_Header_ID int
--SET @Cur_Date='2024-03-07'
IF EXISTS (
select 1 from T_ERP_Attendance_Entry_Header where Dt_Date =@Cur_Date
)
Begin
SET @Attendance_Entry_Header_ID=(select Max(I_Attendance_Entry_Header_ID) 
from T_ERP_Attendance_Entry_Header where Dt_Date =@Cur_Date
)
SET @Student_Class_Routine_ID=(select Top 1 I_Student_Class_Routine_ID 
from T_ERP_Attendance_Entry_Header where I_Attendance_Entry_Header_ID =@Attendance_Entry_Header_ID
)
End 
select I_Attendance_Entry_Detail_ID,I_Attendance_Entry_Header_ID,
I_Student_Detail_ID,
I_IsPresent
from T_ERP_Attendance_Entry_Detail 
where I_Attendance_Entry_Header_ID = @Attendance_Entry_Header_ID
--Select @Student_Class_Routine_ID AS RoutineID
End
