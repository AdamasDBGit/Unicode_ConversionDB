/*  
-- ======================================================================================================================  
-- Author:Ujjwal Sinha  
-- Create date:22/05/2007   
-- Description:Select combined List from T_Shortlisted_Student,T_Vacanct_Detail,T_Business_Master,T_Employer_detail table   
-- Parameters: @iEmployerID , @dtDateofInterview  
-- ======================================================================================================================  
*/  
  
CREATE PROCEDURE [PLACEMENT].[uspGetEligibleStudentList]  
(  
 @iEmployerID  INT = null,  
 @dtDateofInterview DATETIME =null,  
 @iVacancyID INT = NULL  
)  
AS  
BEGIN  
 SELECT ISNULL(A.S_Student_ID,' ') AS S_Student_ID   ,  
           ISNULL(A.S_First_Name,' ') AS S_First_Name   ,  
           ISNULL(A.S_Middle_Name,' ') AS S_Middle_Name ,  
           ISNULL(A.S_Last_Name,' ') AS S_Last_Name     ,  
           ISNULL(B.S_Center_Code,' ') AS S_Center_Code ,  
     ISNULL(B.S_Center_Name,' ') AS S_Center_Name ,   
     ISNULL(J.C_Interview_Status,' ') AS C_Interview_Status,  
     ISNULL(J.I_Shortlisted_Student_ID,0) AS I_Shortlisted_Student_ID,  
     ISNULL(J.I_Student_Detail_ID,0) AS I_Student_Detail_ID  
          FROM [dbo].T_Student_Detail                  A,  
        [dbo].T_Centre_Master                       B,  
               [PLACEMENT].T_Vacancy_Detail            C,  
               [dbo].T_Student_Center_Detail           I,  
      [PLACEMENT].T_Shortlisted_Students       J  
     WHERE I.I_Student_Detail_ID = A.I_Student_Detail_ID  
     AND I.I_Student_Detail_ID = J.I_Student_Detail_ID  
     AND J.C_Student_Acknowledgement='A'  
     AND ISNULL(J.C_Interview_Status, 'O') = 'O'
              AND I.I_Centre_Id = B.I_Centre_Id  
     AND C.I_Vacancy_ID = J.I_Vacancy_ID  
     AND J.I_Student_Detail_ID = A.I_Student_Detail_ID  
              AND C.I_Employer_ID = @iEmployerID  
              AND C.Dt_Date_Of_Interview = COALESCE(@DtDateofInterview,C.Dt_Date_Of_Interview)  
     AND C.I_Vacancy_ID = COALESCE(@iVacancyID,C.I_Vacancy_ID)  
           AND A.I_Status = 1   
              AND B.I_Status = 1   
              AND C.I_Status = 1   
              AND I.I_Status = 1   
     AND J.I_Status = 1  
  
 SELECT * FROM  
  (SELECT ISNULL(F.I_Skills_ID,0) AS I_Skills_ID,  
           ISNULL(I.S_Skill_Desc,' ') AS S_Skill_Desc,  
           ISNULL(F.S_Skill_Proficiency,' ') AS S_Skill_Proficiency,  
                  F.B_Soft_Skill,  
                  F.B_Technical_Skill,  
           ISNULL(F.I_Student_Detail_ID,0) AS I_Student_Detail_ID   
          FROM   
               [PLACEMENT].T_Vacancy_Detail    E,  
               [PLACEMENT].T_Placement_Skills          F,   
               [PLACEMENT].T_Placement_Registration    H,  
               [dbo].T_EOS_Skill_Master                I,   
               [PLACEMENT].T_Shortlisted_Students    J  
     WHERE   
              E.I_EMPLOYER_ID=@iEmployerID  
              AND E.I_Vacancy_ID = J.I_Vacancy_ID  
              AND J.I_Student_Detail_ID = H.I_Student_Detail_ID  
              AND F.I_Student_Detail_ID = H.I_Student_Detail_ID  
              AND I.I_Skill_ID = F.I_Skills_ID  
              AND F.I_Status = 1   
              AND H.I_Status = 1   
              AND I.I_Status = 1   
     AND E.I_Status = 1   
     AND E.I_Vacancy_ID = COALESCE(@iVacancyID,E.I_Vacancy_ID)  
              AND E.Dt_Date_Of_Interview = COALESCE(@DtDateofInterview,E.Dt_Date_Of_Interview)  
              ) A LEFT OUTER JOIN  
   [PLACEMENT].T_Educational_Qualification G  
   ON G.I_Student_Detail_ID = A.I_Student_Detail_ID AND G.I_Status = 1   
   
  
 SELECT ISNULL(G.I_Qualification_Name_ID,0) AS I_Qualification_Name_ID,  
           ISNULL(G.I_Student_Detail_ID,0) AS I_Student_Detail_ID,  
           ISNULL(G.I_Year_Of_Passing,0) AS I_Year_Of_Passing,  
           ISNULL(G.S_Percentage_Of_Marks,' ') AS S_Percentage_Of_Marks,  
           ISNULL(I.S_Qualification_Name,0) AS S_Qualification_Name  
          FROM [PLACEMENT].T_Vacancy_Detail    E,  
               [PLACEMENT].T_Placement_Registration    H,  
               [PLACEMENT].T_Educational_Qualification G,   
               [dbo].T_Qualification_Name_Master       I ,  
               [PLACEMENT].T_Shortlisted_Students    J  
     WHERE   
             E.I_EMPLOYER_ID=@iEmployerID  
    AND E.Dt_Date_Of_Interview = COALESCE(@DtDateofInterview,E.Dt_Date_Of_Interview)  
     AND E.I_Vacancy_ID = J.I_Vacancy_ID  
              AND E.I_Vacancy_ID = COALESCE(@iVacancyID,E.I_Vacancy_ID)  
     AND J.I_Student_Detail_ID = H.I_Student_Detail_ID  
              AND G.I_Student_Detail_ID = H.I_Student_Detail_ID  
              AND G.I_Qualification_Name_ID = I.I_Qualification_Name_ID  
              AND H.I_Status = 1   
              AND I.I_Status = 1   
     AND E.I_Status = 1   
              AND G.I_Status = 1   
     AND J.I_Status = 1  
  
  
 SELECT ISNULL(I.S_Certificate_Name,' ') AS S_Certificate_Name,  
           ISNULL(I.S_Certificate_Vender_Name, ' ') AS S_Certificate_Vender_Name,   
           ISNULL(G.I_Student_Detail_ID,0) AS I_Student_Detail_ID,  
     I.I_International_Certificate_ID  
          FROM [PLACEMENT].T_Vacancy_Detail     E,  
               [PLACEMENT].T_Placement_Registration   H,  
               [PLACEMENT].T_International_Certificate  G,   
               [PLACEMENT].T_Intnal_Certificate_Master      I,  
               [PLACEMENT].T_Shortlisted_Students   J  
     WHERE   
             E.I_EMPLOYER_ID=@iEmployerID  
    AND E.Dt_Date_Of_Interview = COALESCE(@DtDateofInterview,E.Dt_Date_Of_Interview)  
              AND E.I_Vacancy_ID = J.I_Vacancy_ID  
     AND E.I_Vacancy_ID = COALESCE(@iVacancyID,E.I_Vacancy_ID)  
              AND J.I_Student_Detail_ID = H.I_Student_Detail_ID  
              AND G.I_Student_Detail_ID = H.I_Student_Detail_ID  
              AND G.I_International_Certificate_ID = I.I_International_Certificate_ID  
              AND H.I_Status = 1   
              AND I.I_Status = 1   
     AND E.I_Status = 1   
              AND G.I_Status = 1   
     AND J.I_Status = 1  
  
   
  
END
