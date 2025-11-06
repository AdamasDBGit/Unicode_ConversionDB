/********************* Finish Indexing ********************/  
  
CREATE FUNCTION [dbo].[ufnGetStudentStatusAttendance](@CenterID INT, @StudentID INT, @CourseID INT, @TermID INT = null,@ModuleID INT = null,@MinReqAttendance INT, @TotalSession INT)  
RETURNS  VARCHAR(50)  
AS   
BEGIN  
 DECLARE @retStudentStatus VARCHAR(50)  
 DECLARE @AttendedSessions int  
 DECLARE @AttendedPercent float   
 DECLARE @IsStudent int  
  
 SET @retStudentStatus = 0   
  
 SELECT @AttendedSessions = COUNT(I_Attendance_Detail_ID)  
 FROM dbo.T_Student_Attendance_Details  
 WHERE I_Student_Detail_ID = @StudentID  
 AND I_Centre_Id = @CenterID  
 AND I_Has_Attended = 1  
 AND I_Course_ID = @CourseID  
 AND I_Term_ID = ISNULL(@TermID,I_Term_ID)  
 AND ISNULL([I_Module_ID],0) = ISNULL(ISNULL(@ModuleID,I_Module_ID),0)  
         
   
 SET @AttendedPercent = @AttendedSessions * 100.00 / @TotalSession  
   
 IF @AttendedPercent > @MinReqAttendance  
 BEGIN   
  SET @retStudentStatus = 'Cleared'  
 END  
 ELSE  
 BEGIN  
  SET @retStudentStatus = 'Not Cleared'  
 END  
  
 IF @MinReqAttendance = 0  
 BEGIN  
  SET @retStudentStatus = 'Cleared'  
 END  
   
    RETURN @retStudentStatus  
END