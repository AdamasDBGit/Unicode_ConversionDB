--exec [dbo].[uspGetStudentResult] '17-0009',null
CREATE PROCEDURE [dbo].[usp_ERP_InsertUpdate_Attendance]
(
 @UTAttendance [UT_Attendance] readonly,
 @ClassRoutineID int,
 @FacultyMasterID int,
 @Date datetime ,
 @iCreatedBy int
)
AS
BEGIN
DECLARE @attendanceHeaderID int
IF NOT EXISTS(select * from T_ERP_Attendance_Entry_Header where I_Student_Class_Routine_ID = @ClassRoutineID and I_Faculty_Master_ID=@FacultyMasterID and CAST(Dt_Date AS DATE) = CAST(@Date AS DATE) )
BEGIN
INSERT INTO T_ERP_Attendance_Entry_Header
(
I_Student_Class_Routine_ID,
I_Faculty_Master_ID,
Dt_Date,
I_CreatedBy,
Dt_CreatedAt
)
VALUES
(
@ClassRoutineID,
@FacultyMasterID,
@Date,
@iCreatedBy,
GETDATE()
)
set @attendanceHeaderID = SCOPE_IDENTITY()
INSERT INTO T_ERP_Attendance_Entry_Detail 
(
I_Attendance_Entry_Header_ID,
I_Student_Detail_ID,
I_IsPresent,
I_CreatedBy,
Dt_CreatedAt
)
select @attendanceHeaderID,StudentDetailID,IsPresent,@iCreatedBy,GETDATE() from @UTAttendance
select 1 StatusFlag,'Attendance saved succesfully' Message
END
ELSE
BEGIN
set @attendanceHeaderID = (select I_Attendance_Entry_Header_ID from  T_ERP_Attendance_Entry_Header where I_Student_Class_Routine_ID = @ClassRoutineID and I_Faculty_Master_ID = @FacultyMasterID and CAST(Dt_Date AS DATE) = CAST(@Date AS DATE))
update T_ERP_Attendance_Entry_Detail set I_IsPresent = UT.IsPresent from @UTAttendance UT 
where I_Attendance_Entry_Header_ID = @attendanceHeaderID and I_Student_Detail_ID = UT.StudentDetailID 
select 1 StatusFlag,'Attendance updated succesfully' Message
END


END
