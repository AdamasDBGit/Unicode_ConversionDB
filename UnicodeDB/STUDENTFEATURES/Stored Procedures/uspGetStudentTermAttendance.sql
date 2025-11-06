CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentTermAttendance]
(    
      @iStudentDetailID int,    
      @iCourseID int    
)    
    
AS    
BEGIN    
    
SET NOCOUNT ON    
    
      DECLARE @tblTerms TABLE    
      (    
            Sequence int,    
            TermID int,    
   -- TermName size changed from 50 chars to    
   --100 chars for resolving student term display issue    
     
            TermName varchar(100)    
      )    
      INSERT INTO @tblTerms    
      SELECT TCM.I_Sequence,TM.I_Term_ID, TM.S_Term_Name     
            FROM dbo.T_Term_Course_Map TCM    
      INNER JOIN dbo.T_Term_Master TM    
      ON TM.I_Term_ID = TCM.I_Term_ID    
            WHERE I_Course_ID = @iCourseID   
            AND TCM.I_Status=1   
      ORDER BY TCM.I_Sequence    
    
      DECLARE @tblTermAttendance TABLE    
      (    
            Sequence int,    
            TermID int,    
            TermName varchar(100),    
            TotalSessions int,    
            TotalSessionsAttended int,    
            PercentageAttended numeric(18,2)    
      )    
    
      INSERT INTO @tblTermAttendance(Sequence, TermID, TermName)    
      (SELECT Sequence, TermID, TermName FROM @tblTerms)    
    
      UPDATE @tblTermAttendance     
      SET TotalSessionsAttended =     
      (SELECT COUNT(I_Session_ID)    
            FROM dbo.T_Student_Attendance_Details    
            WHERE I_Student_Detail_ID = @iStudentDetailID     
                    AND I_Course_ID = @iCourseID     
                    AND I_Term_ID = TermID    
            GROUP BY I_Term_ID) 
            
            --select * from @tblTermAttendance        
    
      UPDATE @tblTermAttendance     
      SET TotalSessions =    
      (
      
			select sum(I_No_Of_Session)
			from T_Module_Term_Map MTM 
			INNER JOIN T_Module_Master MM ON MTM.I_Module_Id = MM.I_Module_Id
			where MTM.I_Status = 1 and MM.I_Status = 1
			and I_Term_ID = TermID

            
            
      )    
    
      UPDATE @tblTermAttendance     
      SET PercentageAttended = (CAST(TotalSessionsAttended AS NUMERIC(18,2)) /     
                                                CAST(TotalSessions AS NUMERIC(18,2)) * 100)    
    
      SELECT * FROM @tblTermAttendance    
    
END
