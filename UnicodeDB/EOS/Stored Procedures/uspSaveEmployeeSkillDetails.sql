/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP save all the Skill Details corresponding to an Employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveEmployeeSkillDetails]
(
	@iEmployeeID INT,
	@sSkillIDs VARCHAR(1000),
	@iStatus INT=0
)

AS 
BEGIN TRY
	DECLARE @TempSkill TABLE
	(
		EmpID INT,
		SkillID INT,
		Status INT
	)
	
	INSERT INTO @TempSkill (SkillID)
	SELECT * FROM  dbo.fnString2Rows(@sSkillIDs,',')
	
	UPDATE @TempSkill
	SET EmpID=@iEmployeeID,Status=2
	
	INSERT INTO EOS.T_Employee_Skill_Map
	(
		I_Skill_ID,
		I_Employee_ID,
		I_Status,
		Dt_Crtd_On
	)
	SELECT SkillID,EmpID,Status,GETDATE()
	FROM @TempSkill
	WHERE SkillID NOT IN 
	(SELECT I_Skill_ID FROM EOS.T_Employee_Skill_Map 
		WHERE I_Employee_ID = @iEmployeeID)
	
END TRY

BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
