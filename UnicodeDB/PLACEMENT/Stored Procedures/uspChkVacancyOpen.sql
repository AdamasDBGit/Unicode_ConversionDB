/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Insert Check business rule for student placement registration for 
-- VacancyOpen  and Vacancy Fill
-- =================================================================
*/
CREATE PROCEDURE [PLACEMENT].[uspChkVacancyOpen]
(
@iVacancyID  INT
)
AS
BEGIN

DECLARE @RtValid VARCHAR (1)


IF EXISTS(SELECT I_No_Of_Openings from PLACEMENT.T_Vacancy_Detail
WHERE I_Vacancy_ID =@iVacancyID
AND I_No_Of_Openings >=(SELECT COUNT(*) FROM PLACEMENT.T_Shortlisted_Students
WHERE I_Vacancy_ID =@iVacancyID AND C_Interview_Status ='S'))
BEGIN
	SET @RtValid ='T'
END
ELSE
 BEGIN
	SET @RtValid = 'F'
  END
SELECT @RtValid

END
