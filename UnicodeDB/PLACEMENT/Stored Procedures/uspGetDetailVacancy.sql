/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007
-- Description:Get vacancy record From T_Vacancy_Detail table
-- Parameter :
 	   @iVacancyID
-- ================================================================= 	   
*/

CREATE PROCEDURE [PLACEMENT].[uspGetDetailVacancy]
-- Input parameter
(
	   @iVacancyID INT
)
AS
BEGIN 

	SELECT 
			I_Employer_ID, 
			ISNULL(S_Min_Height,' ') AS S_Min_Height, 
			ISNULL(S_Max_Height,' ') AS S_Max_Height,
			ISNULL(S_Min_Weight,' ') AS S_Min_Weight,
			ISNULL(S_Height_UOM,' ') AS S_Height_UOM,
			ISNULL(S_Max_Weight,' ') AS S_Max_Weight,
			ISNULL(C_Gender,' ') AS C_Gender, 
			ISNULL(I_No_Of_Openings,0) AS I_No_Of_Openings,
			ISNULL(S_Weight_UOM,' ') AS S_Weight_UOM,
			ISNULL(S_Job_Type, ' ') AS S_Job_Type,
			ISNULL(S_Pay_Scale,' ') AS S_Pay_Scale, 
			ISNULL(S_Vacancy_Description,' ') AS S_Vacancy_Description, 
			ISNULL(S_Remarks,' ') AS S_Remarks,
			B_Transport, 
			ISNULL(S_Role_Designation,' ') AS S_Role_Designation,
			ISNULL(Dt_Date_Of_Interview,' ') AS Dt_Date_Of_Interview,
			ISNULL(I_Nature_Of_Business,' ') AS I_Nature_Of_Business,
			B_Fresher_Allowed,
			ISNULL(S_Work_Experience,' ') AS S_Work_Experience,
			B_Shift
	FROM  [PLACEMENT].T_Vacancy_Detail
	WHERE
			I_Vacancy_ID = @iVacancyID
	AND
			I_Status=1
			
-- Selecting qualification for vacancy
	SELECT 
			I_Qualification_NAME_ID
    FROM    [PLACEMENT].T_Vacancy_Qualifications
    
    WHERE
			I_Vacancy_ID = @iVacancyID
	AND
			I_Status=1
	
-- Selecting Skill for vacancy 

   SELECT 
   			I_Skills_ID, 
			B_Soft_Skill, 
			B_Mandatory, 
			B_Technical_Skill  
   FROM  [PLACEMENT].T_Vacancy_Skills
   WHERE
			I_Vacancy_ID = @iVacancyID
	AND
			I_Status=1
			
END
