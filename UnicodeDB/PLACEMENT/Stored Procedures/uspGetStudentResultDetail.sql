/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description: Selelect interview detail result of a student
-- Parameter : @iShortlistedStudentID 
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspGetStudentResultDetail]
(

@iShortlistedStudentID INT
)
AS

BEGIN
	SELECT ISNULL(A.S_Student_ID,' ') AS S_Student_ID   ,
           ISNULL(A.S_First_Name,' ') AS S_First_Name   ,
           ISNULL(A.S_Middle_Name,' ') AS S_Middle_Name ,
           ISNULL(A.S_Last_Name,' ') AS S_Last_Name     ,
           ISNULL(B.S_Center_Name,' ') AS S_Center_Name ,
	   ISNULL(E.C_Interview_Status,' ') AS C_Interview_Status,
	   ISNULL(E.I_Shortlisted_Student_ID,0) AS I_Shortlisted_Student_ID,
	   ISNULL(E.S_Placement_Executive,'') AS S_Placement_Executive,
	   ISNULL(E.C_Interview_Status, ' ') AS C_Interview_Status,
	   ISNULL(E.N_Annual_Salary, ' ') AS N_Annual_Salary,
	   ISNULL(E.Dt_Placement , ' ') AS Dt_Placement,
	   ISNULL(E.S_Failure_Reason,' ') AS S_Failure_Reason,
	   ISNULL(E.I_Student_Detail_ID, 0) AS I_Student_Detail_ID,
	   ISNULL(E.I_Shortlisted_Student_ID,0) AS I_Shortlisted_Student_ID
        
          FROM [dbo].T_Student_Detail                  A,
	       [dbo].T_Centre_Master                       B,
               [PLACEMENT].T_Placement_Registration    C,
               [dbo].T_Student_Center_Detail           D,
	       [PLACEMENT].T_Shortlisted_Student       E
	    WHERE 
               A.I_Student_Detail_ID = C.I_Student_Detail_ID
              AND C.I_Student_Detail_ID = E.I_Student_Detail_ID
              AND D.I_Student_Detail_ID = A.I_Student_Detail_ID
              AND E.I_Shortlisted_Student_ID = @iShortlistedStudentID
              AND A.I_Status = 1 
              AND B.I_Status = 1 
              AND C.I_Status = 1 
              AND D.I_Status = 1 
              AND E.I_Status = 1 
	      

END
