/*
-- ======================================================================================================================
-- Author:Partha Paul
-- Create date:27/05/2007 
-- Description:Select combined List Skill set for Vacancy,QUALIFICATION SET FOR VACANCY
-- ======================================================================================================================
*/

CREATE PROCEDURE [PLACEMENT].[uspGetVacancyListDetail]
(
	@iVacancyID		INT
	
)
AS
BEGIN
             

-- Skill set for Vacancy

SELECT     ISNULL(I_Vacancy_ID,0) AS I_Vacancy_ID, 
ISNULL(A.I_Skills_ID ,0) AS I_Skills_ID, 
ISNULL(A.B_Soft_Skill,0) AS B_Soft_Skill, 
ISNULL(A.B_Mandatory,0) AS  B_Mandatory,
ISNULL(A.B_Technical_Skill,0) AS B_Technical_Skill,
ISNULL(B.S_Skill_Desc,'') AS S_Skill_Desc,
ISNULL(B.S_Skill_No,'') AS S_Skill_No
FROM  PLACEMENT.T_Vacancy_Skills  A, T_EOS_Skill_Master B
WHERE I_Vacancy_ID =@iVacancyID	 AND  A.I_Skills_ID = B.I_Skill_ID
AND A.I_Status = 1 
AND B.I_Status = 1



END
