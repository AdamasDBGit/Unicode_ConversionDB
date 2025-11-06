/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007
-- Description:Get vacancy record From T_Vacancy_Detail table
-- Parameter : 	 
-- ================================================================= 	   
*/

CREATE PROCEDURE [PLACEMENT].[uspGetVacancyListbyScheduleDate]
(
	@iEmployerID     INT ,
        @DtofInterview   datetime
)
AS
BEGIN 

	SELECT ISNULL(I_Employer_ID,0) AS I_Employer_ID ,
		ISNULL(I_Vacancy_ID,0) AS I_Vacancy_ID ,
	        ISNULL(S_Min_Height,' ') AS S_Min_Height ,
        	ISNULL(S_Max_Height,' ') AS S_Max_Height ,
	        ISNULL(S_Min_Weight,' ') AS S_Min_Weight ,
	        ISNULL(S_Height_UOM,' ') AS S_Height_UOM , 
		ISNULL(S_Max_Weight,' ') AS  S_Max_Weight ,
	        ISNULL(C_Gender,' ') AS  C_Gender ,
        	ISNULL(I_No_Of_Openings,0) AS I_No_Of_Openings ,
	        ISNULL(S_Weight_UOM,' ') AS S_Weight_UOM ,
        	ISNULL(S_Job_Type,' ') AS  S_Job_Type , 
	        ISNULL(S_Pay_Scale,' ') AS S_Pay_Scale ,
	        ISNULL(S_Vacancy_Description,' ') AS S_Vacancy_Description ,
	        ISNULL(S_Remarks,' ') AS  S_Remarks ,
                B_Transport ,
        	ISNULL(S_Role_Designation,' ') AS S_Role_Designation , 
	       	ISNULL(Dt_Date_Of_Interview,' ') AS Dt_Date_Of_Interview ,
           	ISNULL(I_Nature_Of_Business,0) AS I_Nature_Of_Business ,
                B_Fresher_Allowed ,
	        ISNULL(S_Work_Experience,' ') AS S_Work_Experience ,
        	B_Shift
	FROM  [PLACEMENT].T_Vacancy_Detail
	WHERE I_Employer_ID = @iEmployerID
          AND Dt_Date_Of_Interview = @DtofInterview 
	  and I_Status=1		
			
END
