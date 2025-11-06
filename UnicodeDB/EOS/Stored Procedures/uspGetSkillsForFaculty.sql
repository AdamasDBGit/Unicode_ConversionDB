CREATE PROCEDURE [EOS].[uspGetSkillsForFaculty] 
(  
 @iEmpID INT,  
 @iBrandId INT 
)
AS    
BEGIN
	SELECT SM.I_Skill_Id
			,SM.S_Skill_Desc
	FROM T_EOS_Skill_Master SM
	INNER JOIN EOS.T_Employee_Skill_Map ESM
	ON SM.I_Skill_Id = ESM.I_Skill_ID
	WHERE ESM.I_Employee_ID = @iEmpID
END
