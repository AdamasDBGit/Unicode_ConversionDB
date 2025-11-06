/*
-- ======================================================================================================================
-- Author:Ujjwal Sinha
-- Create date:22/05/2007 
-- Description:Select combined List from T_Shortlisted_Student,T_Vacanct_Detail,T_Business_Master,T_Employer_detail table 
-- ======================================================================================================================
*/

CREATE PROCEDURE [PLACEMENT].[uspGetVacancyData]
(
	@iVacancyID		INT,
	@DtDateofInterview	DATETIME = null
	
)
AS
BEGIN
	SELECT ISNULL(Q.S_Qualification_Name,' ') AS S_Qualification_Name ,
           ISNULL(S.S_Skill_Desc,' ') AS S_Skill_Desc ,
           ISNULL(V.I_Qualification_Name_ID,0) AS I_Qualification_Name_ID ,
           ISNULL(K.I_Skills_ID,0) AS I_Skills_ID
          FROM [dbo].T_Qualification_Name_Master Q,
	       [dbo].T_EOS_Skill_Master S,
	       [PLACEMENT].T_Vacancy_Qualifications V,
	       [PLACEMENT].T_Vacancy_Detail D,
               [PLACEMENT].T_Vacancy_Skills K
	    WHERE V.I_Vacancy_ID = D.I_Vacancy_ID
              AND Q.I_Qualification_Name_ID = V.I_Qualification_Name_ID
              AND K.I_Vacancy_ID = D.I_Vacancy_ID
              AND S.I_Skill_ID = K.I_Skills_ID
              AND D.I_Vacancy_ID = COALESCE(@iVacancyID ,D.I_Vacancy_ID)
              AND D.Dt_Date_Of_Interview = COALESCE(@DtDateofInterview,D.Dt_Date_Of_Interview)
              AND D.I_Status = 1 
              AND Q.I_Status = 1 
              AND S.I_Status = 1 
              AND V.I_Status = 1 
              AND K.I_Status = 1   	
END
