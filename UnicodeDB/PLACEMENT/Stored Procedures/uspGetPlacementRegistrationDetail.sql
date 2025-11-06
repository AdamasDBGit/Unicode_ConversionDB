/*  
-- =================================================================  
-- Author:Ujjwal Sinha  
-- Create date:21/05/2007   
-- Description:Select Details Placement record in T_Placement_Registration table   
-- Parameters  :@iStudentDetailID  
-- =================================================================  
*/  
  
CREATE PROCEDURE [PLACEMENT].[uspGetPlacementRegistrationDetail]  
(  
 @iStudentDetailID     INT  
)  
AS  
BEGIN  
  
   SELECT   
        I_Student_Detail_ID,  
        ISNULL(PR.I_Job_Type_ID,0) AS  I_Job_Type_ID ,  
        ISNULL(PR.I_Country_ID,0) AS I_Country_ID  ,  
        ISNULL(PR.I_Centre_ID,0) AS I_Centre_ID ,  
        ISNULL(PR.I_Brand_ID,0) AS I_Brand_ID ,  
        ISNULL(PR.I_Enroll_No,0) AS I_Enroll_No ,  
        ISNULL(PR.S_Preferred_Location,' ') AS S_Preferred_Location ,  
        ISNULL(PR.S_Job_Preference,' ') AS S_Job_Preference,  
        ISNULL(PR.Dt_Actual_Course_Comp_Date,' ') AS Dt_Actual_Course_Comp_Date ,  
        ISNULL(PR.S_Height,' ') AS S_Height ,  
        ISNULL(PR.I_Document_ID,0) AS I_Document_ID,  
        ISNULL(PR.S_Weight,' ') AS S_Weight ,  
        ISNULL(PR.S_Age,' ') AS S_Age ,  
        ISNULL(PR.I_Acknowledgement_Count,0) AS  I_Acknowledgement_Count ,  
        ISNULL(PR.Dt_Expec_Course_Comp_Date,' ') AS Dt_Expec_Course_Comp_Date ,  
        ISNULL(PR.S_Cell_No,' ') AS S_Cell_No ,  
        ISNULL(PR.S_Current_Organization,' ') AS S_Current_Organization ,  
        ISNULL(PR.S_Designation,' ') AS  S_Designation,  
        ISNULL(UD.S_Document_Name , ' ') AS S_Document_Name,  
  ISNULL(UD.S_Document_Type,'') AS S_Document_Type,  
  ISNULL(UD.S_Document_Path ,'') AS S_Document_Path,  
  ISNULL(UD.S_Document_URL , '') AS S_Document_URL,  
  ISNULL(PR.B_Profile_Viewed, 0) AS B_Profile_Viewed,  
  ISNULL(PR.B_Placement_Asistance, 0) AS B_Placement_Asistance  
     FROM [PLACEMENT].T_Placement_Registration PR  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON PR.I_Document_ID = UD.I_Document_ID  
       WHERE PR.I_Student_Detail_ID  = @iStudentDetailID  
         AND PR.I_Status = 1  
  -- AND UD.I_Status = 1  
  
   SELECT   
       I_Skills_ID,  
       B_Soft_Skill,  
    S_Skill_Proficiency,  
       B_Technical_Skill  
   FROM [PLACEMENT].T_Placement_Skills  
      WHERE I_Student_Detail_ID  = @iStudentDetailID  
  AND I_Status = 1  
  
  
   SELECT   
        I_Qualification_Name_ID,  
        I_Year_Of_Passing,  
        S_Percentage_Of_Marks  
    FROM [PLACEMENT].T_Educational_Qualification  
      WHERE I_Student_Detail_ID  = @iStudentDetailID  
  AND I_Status = 1  
  
   SELECT   
        I_International_Certificate_ID  
    FROM [PLACEMENT].T_International_Certificate  
      WHERE I_Student_Detail_ID  = @iStudentDetailID  
  AND I_Status = 1  
  
  
	SELECT
			I_Location_ID,  
			S_Location_Type,  
			I_Student_Detail_ID
	FROM	[PLACEMENT].T_Pref_Location
	WHERE	I_Student_Detail_ID  = @iStudentDetailID  
			AND I_Status = 1  
  
  
END
