CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentModuleAttendance]  -- 4,11,23    
(      
 @iStudentDetailID int,      
 @iCourseID int,      
 @iTermID int      
)      
      
AS      
BEGIN      
      
SET NOCOUNT ON      
      
 DECLARE @tblModules TABLE      
 (      
  Sequence int,      
  ModuleID int,      
  ModuleName varchar(max)      
 )      
 INSERT INTO @tblModules      
 SELECT MTM.I_Sequence,MM.I_Module_ID, MM.S_Module_Name       
  FROM dbo.T_Module_Term_Map MTM      
 INNER JOIN dbo.T_Module_Master MM      
 ON MM.I_Module_ID = MTM.I_Module_ID     
  WHERE MTM.I_Term_ID = @iTermID    
  AND MTM.I_Status=1      
 ORDER BY MTM.I_Sequence      
      
 DECLARE @tblModuleAttendance TABLE      
 (      
  Sequence int,      
  ModuleID int,      
  ModuleName varchar(max),      
  TotalSessions int,      
  TotalSessionsAttended int,      
  PercentageAttended numeric(18,2),      
  TotalHours numeric(18,2)      
 )      
      
 INSERT INTO @tblModuleAttendance(Sequence, ModuleID, ModuleName)      
 (SELECT Sequence, ModuleID, ModuleName FROM @tblModules)      
      
 UPDATE @tblModuleAttendance       
 SET TotalSessionsAttended =       
 (SELECT COUNT(I_Session_ID)      
  FROM dbo.T_Student_Attendance_Details      
  WHERE I_Student_Detail_ID = @iStudentDetailID       
     AND I_Course_ID = @iCourseID       
     AND I_Term_ID = @iTermID      
     AND I_Module_ID = ModuleID      
  GROUP BY I_Module_ID)      
      
 UPDATE @tblModuleAttendance       
 SET TotalSessions =      
 (SELECT COUNT(SMM.I_Session_ID)      
  FROM dbo.T_Session_Module_Map SMM      
   WHERE SMM.I_Module_ID IN (SELECT ModuleID FROM @tblModuleAttendance)      
   AND SMM.I_Module_ID = ModuleID AND SMM.I_Status = 1  
  GROUP BY SMM.I_Module_ID)      
      
 UPDATE @tblModuleAttendance       
 SET PercentageAttended = (CAST(TotalSessionsAttended AS NUMERIC(18,2)) /       
        CAST(TotalSessions AS NUMERIC(18,2)) * 100)      
      
 UPDATE @tblModuleAttendance       
 SET TotalHours =      
 (SELECT SUM(N_Session_Duration)/60.00       
  FROM dbo.T_Session_Master SM      
  INNER JOIN dbo.T_Session_Module_Map SMM      
  ON SMM.I_Session_ID = SM.I_Session_ID AND SMM.I_Status = 1     
  WHERE SMM.I_Module_ID IN (SELECT ModuleID FROM @tblModuleAttendance)      
   AND SMM.I_Module_ID = ModuleID      
  GROUP BY SMM.I_Module_ID)      
      
 SELECT * FROM @tblModuleAttendance      
      
END
