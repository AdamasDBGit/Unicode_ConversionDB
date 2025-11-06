-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:15/05/2007 
-- Description:Select list of short listed student records from T_Shortlisted_Students table
-- Serching cryteria Vacancy ID
-- =================================================================

CREATE PROCEDURE [PLACEMENT].[uspGetShortlistedStudentList]
(
	@iVacancyID INT
)
AS
BEGIN

   SELECT 
        ISNULL(I_Student_Detail_ID,0) AS I_Student_Detail_ID ,
        ISNULL(Dt_Scheduled_Interview,' ') AS Dt_Scheduled_Interview , 
        ISNULL(C_Company_Invitation,' ') AS C_Company_Invitation , 
        ISNULL(C_Student_Acknowledgement,' ') AS C_Student_Acknowledgement ,
        ISNULL(C_Interview_Status,' ') AS C_Interview_Status , 
        ISNULL(Dt_Actual_Interview,' ') AS Dt_Actual_Interview  , 
        ISNULL(Dt_Placement,' ') AS Dt_Placement , 
        ISNULL(S_Placement_Executive,' ') AS S_Placement_Executive ,
        ISNULL(S_Failure_Reason,' ') AS S_Failure_Reason , 
        ISNULL(S_Designation,' ') AS S_Designation , 
        ISNULL(N_Annual_Salary,0) AS N_Annual_Salary , 
        ISNULL(S_Upd_By,' ') AS S_Upd_By ,
        ISNULL(Dt_Upd_On,' ') AS  Dt_Upd_On       
     FROM [PLACEMENT].T_Shortlisted_Students
       WHERE I_Vacancy_ID = @iVacancyID
	   AND
			 I_Status = 1
	
END
