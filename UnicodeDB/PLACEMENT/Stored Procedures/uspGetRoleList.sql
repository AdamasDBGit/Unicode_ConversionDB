/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/07/2007
-- Description:Get Role name from T_Vacancy_Detail table
-- Returns : Dataset
-- ================================================================= 	   
*/

CREATE PROCEDURE [PLACEMENT].[uspGetRoleList]
AS
BEGIN 

	SELECT DISTINCT TVD.[I_Employer_ID],
					TVD.S_Role_Designation AS S_Role_Designation
	FROM PLACEMENT.T_Vacancy_Detail TVD
END
