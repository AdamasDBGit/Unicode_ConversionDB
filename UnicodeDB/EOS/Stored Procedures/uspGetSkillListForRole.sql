/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the Skill list for a particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetSkillListForRole]
(	
	@iRoleID INT = NULL,
	@iCenterID INT = NULL
)	
AS
BEGIN
	IF (@iCenterID IS NULL)
	BEGIN
		SELECT  TRSM.I_Role_ID,
				TRSM.I_Skill_ID,
				TESM.S_Skill_No,
				TESM.S_Skill_Desc,
				TRSM.I_Status
		FROM EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)
		INNER JOIN dbo.T_EOS_Skill_Master TESM WITH(NOLOCK)
			ON TRSM.I_Skill_ID = TESM.I_Skill_ID
		WHERE	TRSM.I_Role_ID = ISNULL(@iRoleID, TRSM.I_Role_ID)
			AND TRSM.I_Centre_ID IS NULL
	END
	ELSE
	BEGIN
		SELECT  TRSM.I_Role_ID,
				TRSM.I_Skill_ID,
				TESM.S_Skill_No,
				TESM.S_Skill_Desc,
				TRSM.I_Status
		FROM EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)
		INNER JOIN dbo.T_EOS_Skill_Master TESM WITH(NOLOCK)
			ON TRSM.I_Skill_ID = TESM.I_Skill_ID
		WHERE	TRSM.I_Role_ID = ISNULL(@iRoleID, TRSM.I_Role_ID)
			AND TRSM.I_Centre_ID = @iCenterID
	END
END
