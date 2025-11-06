CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentAttendance]     
(    
 @iStudentDetailID int,    
 @iCourseID int,    
 @iTermID int,    
 @iModuleID int    
)    
    
AS    
BEGIN    
    
 SET NOCOUNT ON    
    
 SELECT DISTINCT SMM.I_Session_ID,    
      SM.S_Session_Code,     
      SM.S_Session_Name,     
      SAD.Dt_Attendance_Date    
   FROM  dbo.T_Session_Module_Map SMM     
   LEFT OUTER JOIN dbo.T_Student_Attendance_Details SAD    
   ON SMM.I_Session_ID = SAD.I_Session_ID    
   AND SAD.I_Course_ID = @iCourseID    
   AND SAD.I_Term_ID = @iTermID    
   AND SAD.I_Student_Detail_ID = @iStudentDetailID    
   INNER JOIN  dbo.T_Session_Master SM    
   ON SMM.I_Session_ID = SM.I_Session_ID    
   WHERE SMM.I_Module_ID = @iModuleID    
   ORDER BY SAD.Dt_Attendance_Date,SMM.I_Session_ID
     
END
