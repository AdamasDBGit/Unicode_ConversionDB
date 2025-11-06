/*  
-- ======================================================================================================================  
-- Author:Ujjwal Sinha  
-- Create date:26/05/2007   
-- Description:Select combined List from T_Shortlisted_Student,T_Vacanct_Detail,T_Business_Master,T_Employer_detail table   
-- ======================================================================================================================  
*/  
  
CREATE PROCEDURE [PLACEMENT].[uspGetVacancyDetail]  
(  
 @iVacancyID  INT  
   
)  
AS  
BEGIN  
 SELECT ISNULL(I_Employer_ID,0) AS I_Employer_ID ,  
               ISNULL(S_Min_Height,' ') AS S_Min_Height ,  
               ISNULL(S_Max_Height,' ') AS S_Max_Height ,  
               ISNULL(S_Height_UOM,' ') AS S_Height_UOM ,  
               ISNULL(S_Min_Weight,' ') AS S_Min_Weight ,  
               ISNULL(S_Max_Weight,' ') AS S_Max_Weight ,  
               ISNULL(S_Weight_UOM,' ') AS S_Weight_UOM ,  
               ISNULL(C_Gender,' ') AS C_Gender ,  
               ISNULL(I_No_Of_Openings,0) AS I_No_Of_Openings ,  
               ISNULL(S_Job_Type,' ') AS S_Job_Type ,  
               ISNULL(S_Pay_Scale,' ') AS S_Pay_Scale ,  
               ISNULL(S_Vacancy_Description,' ') AS S_Vacancy_Description ,  
               ISNULL(S_Remarks,' ') AS S_Remarks ,  
               ISNULL(S_Role_Designation,' ') AS S_Role_Designation ,  
               ISNULL(Dt_Date_Of_Interview,' ') AS Dt_Date_Of_Interview ,  
               B_Fresher_allowed,  
               ISNULL(S_Work_Experience,' ') AS S_Work_Experience ,  
               B_Shift,  
               ISNULL(I_Nature_Of_Business,0) AS I_Nature_Of_Business ,  
               B_Transport                 
                
          FROM [PLACEMENT].T_Vacancy_Detail   
                 
     WHERE I_Vacancy_ID = COALESCE(@iVacancyID , I_Vacancy_ID)  
              AND I_Status = 1   
               
  
-- Skill set for Vacancy  
  
SELECT     ISNULL(I_Vacancy_ID,0) AS I_Vacancy_ID,   
ISNULL(I_Skills_ID ,0) AS I_Skills_ID,   
ISNULL(B_Soft_Skill,0) AS B_Soft_Skill,   
ISNULL(B_Mandatory,0) AS  B_Mandatory,  
ISNULL(B_Technical_Skill,0) AS B_Technical_Skill  
FROM  PLACEMENT.T_Vacancy_Skills  
WHERE I_Vacancy_ID =@iVacancyID   
AND I_Status = 1   
  
-- QUALIFICATION SET FOR VACANCY  
SELECT       
ISNULL(I_Qualification_Name_ID,0) AS  I_Qualification_Name_ID,  
ISNULL(I_Vacancy_ID,0) AS I_Vacancy_ID  
FROM   PLACEMENT.T_Vacancy_Qualifications  
WHERE I_Vacancy_ID =@iVacancyID   
AND I_Status = 1   
  
-- Location wise VACANCY  list
SELECT   
a.I_Vacancy_ID,  
a.I_CITY_ID, 
b.S_City_Name,  
a.I_VACANCY
FROM   [PLACEMENT].T_JOB_OPENING A inner join T_City_Master B
on a.I_CITY_ID = B.I_City_ID
WHERE a.I_Vacancy_ID =@iVacancyID   
  

END
