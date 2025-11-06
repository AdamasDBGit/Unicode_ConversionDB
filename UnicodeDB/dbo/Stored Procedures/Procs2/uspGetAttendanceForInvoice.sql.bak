CREATE PROCEDURE [dbo].[uspGetAttendanceForInvoice] 
(  
 @iInvoiceID int  
) 
 
AS  
BEGIN  

 DECLARE @tblTerms TABLE  
      (  
            Sequence int,  
            TermID int,    
            TermName varchar(100)  
      )  

      INSERT INTO @tblTerms  

      SELECT TCM.I_Sequence,TM.I_Term_ID, TM.S_Term_Name   
      FROM dbo.T_Term_Course_Map TCM  
      INNER JOIN dbo.T_Term_Master TM ON TM.I_Term_ID = TCM.I_Term_ID  
      WHERE I_Course_ID IN 
	  (
		SELECT I_Course_ID FROM dbo.T_Invoice_Child_Header WHERE I_Invoice_Header_ID = @iInvoiceID
	  )
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
            WHERE I_Student_Detail_ID IN (SELECT I_Student_Detail_ID FROM dbo.T_Invoice_Parent IP WHERE I_Invoice_Header_ID = @iInvoiceID)   
                    AND I_Course_ID IN (SELECT I_Course_ID FROM dbo.T_Invoice_Child_Header  
 WHERE I_Invoice_Header_ID = @iInvoiceID)    
                    AND I_Term_ID = TermID  
            GROUP BY I_Term_ID)  
  
      UPDATE @tblTermAttendance   
      SET TotalSessions =  
      (SELECT COUNT(SMM.I_Session_ID)   
            FROM dbo.T_Session_Module_Map SMM  
            INNER JOIN dbo.T_Module_Term_Map MTM  
            ON MTM.I_Module_ID = SMM.I_Module_ID  
                  WHERE MTM.I_Term_ID IN (SELECT TermID FROM @tblTermAttendance)  
                  AND MTM.I_Term_ID = TermID  
            GROUP BY MTM.I_Term_ID)  
  
      UPDATE @tblTermAttendance   
      SET PercentageAttended = (CAST(TotalSessionsAttended AS NUMERIC(18,2)) /   
                                                CAST(TotalSessions AS NUMERIC(18,2)) * 100)  
  
      SELECT SUM(ISNULL(TotalSessionsAttended,0)) FROM @tblTermAttendance  
  
END
