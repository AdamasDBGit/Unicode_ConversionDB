/*****************************************************************************************************************
Created by: Soumya Sikder
Date: 13/06/2007
Description:Gets the list of Employee who have skill sets belonging to the Module
Parameters: ModuleID
******************************************************************************************************************/
CREATE PROCEDURE [ACADEMICS].[uspGetEligibleEmployeeListForAttendance]
(
	@iModuleID int
)
AS

BEGIN
	SELECT I_Employee_ID
	FROM EOS.T_Employee_Skill_Map ESM 
	INNER JOIN dbo.T_Module_Master MM WITH(NOLOCK)
	ON ESM.I_Skill_ID = MM.I_Skill_ID
	WHERE MM.I_Module_ID = @iModuleID
	AND MM.I_Status = 1
	AND ESM.I_Status = 1
	
	
END
