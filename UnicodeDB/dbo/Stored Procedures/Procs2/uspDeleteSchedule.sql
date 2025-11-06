

CREATE PROCEDURE [dbo].[uspDeleteSchedule]  
(@ITimeTableId int)  
as  
   
begin  
  
  
if @ITimeTableId not in (select I_TimeTable_ID from T_Student_Attendance_Details)  
begin  
delete from T_TimeTable_Faculty_Map where I_TimeTable_ID=@ITimeTableId  
  
delete from T_TimeTable_Master where I_TimeTable_ID=@ITimeTableId   
end  
  else   
 delete from T_TimeTable_Master where I_TimeTable_ID=@ITimeTableId   
end  
  
