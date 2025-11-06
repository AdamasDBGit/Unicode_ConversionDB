/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Modified By : Pushkar Thakar
-- Create date:21/05/2007 
-- Description:Select List Placement record in T_Placement_Registration table 
-- =================================================================
*/

CREATE PROCEDURE [PLACEMENT].[uspGetPlacementRegistrationList]
AS
BEGIN

   SELECT 
		ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID ,
        ISNULL(A.I_Job_Type_ID,0) AS  I_Job_Type_ID ,
        ISNULL(B.S_Description_Business,' ') AS  S_Job_Type_Desc ,
        ISNULL(A.I_Country_ID,0) AS I_Country_ID  ,
        ISNULL(A.I_Centre_ID,0) AS I_Centre_ID  ,
        ISNULL(A.I_Brand_ID,0) AS I_Brand_ID ,
        ISNULL(A.I_Enroll_No,0) AS I_Enroll_No ,
        ISNULL(A.S_Preferred_Location,' ') AS S_Preferred_Location ,
        ISNULL(A.S_Job_Preference,' ') AS S_Job_Preference ,
        ISNULL(A.Dt_Actual_Course_Comp_Date,' ') AS Dt_Actual_Course_Comp_Date ,
        ISNULL(A.S_Height,' ') AS S_Height ,
        ISNULL(A.I_Document_ID,0) AS I_Document_ID,
        ISNULL(A.S_Weight,' ') AS S_Weight ,
        ISNULL(A.S_Age,' ') AS S_Age ,
        ISNULL(A.I_Acknowledgement_Count,0) AS I_Acknowledgement_Count  ,
        ISNULL(A.Dt_Expec_Course_Comp_Date,' ') AS Dt_Expec_Course_Comp_Date ,
        ISNULL(A.S_Cell_No,' ') AS S_Cell_No ,
        ISNULL(A.S_Current_Organization,' ') AS S_Current_Organization,
        ISNULL(A.S_Designation,' ') AS S_Designation,
		ISNULL(A.I_Status,0) AS I_Status   
     FROM [PLACEMENT].T_Placement_Registration a,
       [PLACEMENT].T_Business_Master B
       WHERE 
          A.I_Job_Type_ID=B.I_Nature_of_Business
         AND A.I_Status = 1 
         AND B.I_Status = 1
           
END
