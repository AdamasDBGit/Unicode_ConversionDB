CREATE PROCEDURE [ACADEMICS].[uspGetStudentAttendanceList]    
(    
@iTimeTableID int
)    
AS    
    
BEGIN    
     
SELECT I_Student_Detail_ID FROM dbo.T_Student_Attendance_Details
WHERE I_TimeTable_ID = @iTimeTableID
     
END
