/*
-- ======================================================================================================================
-- Author:Ujjwal Sinha
-- Create date:21/05/2007 
-- Description:Select combined List from T_Shortlisted_Student,T_Vacanct_Detail,T_Business_Master,T_Employer_detail table 
-- ======================================================================================================================
*/

CREATE PROCEDURE [PLACEMENT].[uspGetPlacementInvitationList]
(
	@iStudentDetailID   INT
	
)
AS
BEGIN

   SELECT 
	    ISNULL(S.I_Student_Detail_ID,0) AS I_Student_Detail_ID ,
        ISNULL(S.I_Vacancy_ID,0) AS  I_Vacancy_ID ,
        ISNULL(V.Dt_Date_Of_Interview,' ') AS Dt_Scheduled_Interview,
        ISNULL(S.C_Company_Invitation,' ') AS C_Company_Invitation ,
        ISNULL(S.C_Student_Acknowledgement,' ') AS C_Student_Acknowledgement,
        ISNULL(S.C_Interview_Status,' ') AS C_Interview_Status  ,
        ISNULL(S.Dt_Actual_Interview,' ') AS Dt_Actual_Interview ,
        ISNULL(S.Dt_Placement,' ') AS  Dt_Placement ,
        ISNULL(S.S_Placement_Executive,' ') AS  S_Placement_Executive ,
        ISNULL(S.S_Failure_Reason,' ') AS S_Failure_Reason ,
        ISNULL(S.S_Designation,' ') AS S_Designation  ,
        ISNULL(S.N_Annual_Salary,0) AS  N_Annual_Salary   ,
        ISNULL(V.I_No_Of_Openings,0) AS I_No_Of_Openings ,
        ISNULL(V.S_Job_Type,' ') AS S_Job_Type ,
        ISNULL(V.S_Pay_Scale,' ') AS  S_Pay_Scale  ,
        ISNULL(V.S_Vacancy_Description,' ') AS S_Vacancy_Description ,
        ISNULL(V.S_Role_Designation,' ') AS S_Role_Designation  ,
        ISNULL(B.S_Description_Business,' ') AS S_Description_Business ,
        ISNULL(E.S_Company_Code,' ') AS S_Company_Code  ,
        ISNULL(E.S_Company_Name,' ') AS S_Company_Name,
		ISNULL (S.I_Shortlisted_Student_ID, 0) AS I_Shortlisted_Student_ID
     FROM [PLACEMENT].T_Shortlisted_Students S,
          [PLACEMENT].T_Vacancy_Detail V,
          [PLACEMENT].T_Business_Master B,
          [PLACEMENT].T_Employer_detail E
       WHERE S.I_Vacancy_ID         = V.I_Vacancy_ID
         AND V.I_Employer_ID        = E.I_Employer_ID
         AND V.I_Nature_Of_Business = B.I_Nature_Of_Business  
         AND S.I_Student_Detail_ID  = @iStudentDetailID
		 AND S.C_Student_Acknowledgement is null
         AND S.I_Status             = 1
         AND V.I_Status             = 1
         AND B.I_Status             = 1
         AND E.I_Status             = 1
END
