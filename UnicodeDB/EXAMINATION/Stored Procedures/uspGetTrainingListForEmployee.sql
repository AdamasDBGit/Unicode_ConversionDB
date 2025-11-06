CREATE PROCEDURE [EXAMINATION].[uspGetTrainingListForEmployee]  
(  
	@iUserID INT = NULL  
)  
AS  
BEGIN  
	CREATE TABLE #tblTraining  
	(  
		I_Training_ID INT,  
		S_Training_Desc VARCHAR(500),  
		I_Training_Stage INT,  
		I_Has_Attended INT  
	)  
	  
	DECLARE @iEmployeeID INT, @iSkillLength INT, @iEmployeeStatus INT, @iTrainingStage INT , @iCenterID INT, @sRoleIDs VARCHAR(1000),  
	@sSkillIDs VARCHAR(1000), @sExamIDs VARCHAR(1000), @iBrandID INT  
	  
	SET @sRoleIDs = ''  
	SET @sSkillIDs = ''  
	SET @sExamIDs = ''  
	  
	SELECT @iEmployeeID = I_Reference_ID FROM dbo.T_User_Master WHERE I_User_ID = @iUserID  
	SELECT @iCenterID = I_Centre_ID, @iEmployeeStatus = I_Status FROM dbo.T_Employee_Dtls WHERE I_Employee_ID = @iEmployeeID  
	SELECT @iBrandID = I_Brand_ID FROM dbo.T_Brand_Center_Details WHERE I_Centre_Id = @iCenterID  
	  
	SELECT @sSkillIDs = @sSkillIDs + ',' + CONVERT(VARCHAR(10),I_Skill_ID) FROM EOS.T_Employee_Skill_Map WHERE I_Employee_ID = @iEmployeeID  
	SELECT @iSkillLength = LEN(@sSkillIDs)  
	SELECT @sRoleIDs = @sRoleIDs + ',' + CONVERT(VARCHAR(10),I_Role_ID) FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID  
	  
	IF (LEN(@sRoleIDs) > 0)  
	BEGIN  
		SET @sRoleIDs = @sRoleIDs + ','  

		SELECT @sSkillIDs = @sSkillIDs + ',' + CONVERT(VARCHAR(10),I_Skill_ID) FROM EOS.T_Role_Skill_Map  
		--WHERE CHARINDEX(CONVERT(VARCHAR(10),I_Role_ID), @sRoleIDs, 0)> 0  
		WHERE I_Role_ID IN (SELECT * FROM dbo.fnString2Rows(@sRoleIDs,','))  
		AND I_Centre_ID = @iCenterID  
		AND I_Brand_ID = @iBrandID  
		AND I_Status = 1  

		IF (LEN(@sSkillIDs) = @iSkillLength)  
		BEGIN  
			SELECT @sSkillIDs = @sSkillIDs + ',' + CONVERT(VARCHAR(10),I_Skill_ID) FROM EOS.T_Role_Skill_Map  
			--WHERE CHARINDEX(CONVERT(VARCHAR(10),I_Role_ID), @sRoleIDs, 0)> 0  
			WHERE I_Role_ID IN (SELECT * FROM dbo.fnString2Rows(@sRoleIDs,','))  
			AND I_Centre_ID IS NULL  
			AND I_Brand_ID = @iBrandID  
			AND I_Status = 1  
		END  
	  
		IF (LEN(@sSkillIDs) > 0)  
		BEGIN  
			SET @sSkillIDs = @sSkillIDs + ','  

			IF (@iEmployeeStatus = 1)  
				BEGIN  
					SET @iTrainingStage = 1  
				END  
			ELSE IF (@iEmployeeStatus > 1)  
				BEGIN  
					SET @iTrainingStage = 2  
				END  
			ELSE  
				BEGIN  
					SET @iTrainingStage = 0  
				END  
	  
			IF (@iEmployeeStatus = 1)	--Condition Added by Partha as on 06-Aug-2008
			BEGIN
				INSERT INTO #tblTraining  
				(I_Training_ID,S_Training_Desc,I_Training_Stage,I_Has_Attended)  
				SELECT DISTINCT TSTM.I_Training_ID, TETM.S_Training_Desc, TSTM.I_Training_Stage, NULL  
				FROM EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)  
				INNER JOIN EOS.T_Employee_Training_Master TETM WITH(NOLOCK)  
				ON TSTM.I_Training_ID = TETM.I_Training_ID  
				WHERE TETM.I_Status <> 0  
				AND TSTM.I_Status <> 0  
				AND CHARINDEX(',' + CONVERT(VARCHAR(10),I_Skill_ID) + ',', @sSkillIDs,0) > 0 AND TSTM.I_Center_ID = @iCenterID AND TSTM.I_Training_Stage = @iTrainingStage  
				  
				IF((SELECT COUNT(I_Training_ID) FROM #tblTraining) = 0)  
				BEGIN  
					INSERT INTO #tblTraining  
					(I_Training_ID,S_Training_Desc,I_Training_Stage,I_Has_Attended)  
					SELECT DISTINCT TSTM.I_Training_ID, TETM.S_Training_Desc, TSTM.I_Training_Stage, NULL  
					FROM EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)  
					INNER JOIN EOS.T_Employee_Training_Master TETM WITH(NOLOCK)  
					ON TSTM.I_Training_ID = TETM.I_Training_ID  
					WHERE TETM.I_Status <> 0  
					AND TSTM.I_Status <> 0  
					AND CHARINDEX(',' + CONVERT(VARCHAR(10),I_Skill_ID) + ',', @sSkillIDs,0) > 0 AND TSTM.I_Center_ID IS NULL AND TSTM.I_Training_Stage = @iTrainingStage  
				END  
			END

			IF (@iEmployeeStatus > 1)	--Condition Added by Partha as on 06-Aug-2008
			BEGIN
				INSERT INTO #tblTraining  
				(I_Training_ID,S_Training_Desc,I_Training_Stage,I_Has_Attended)  
				SELECT DISTINCT TSTM.I_Training_ID, TETM.S_Training_Desc, TSTM.I_Training_Stage, NULL  
				FROM EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)  
				INNER JOIN EOS.T_Employee_Training_Master TETM WITH(NOLOCK)  
				ON TSTM.I_Training_ID = TETM.I_Training_ID  
				WHERE TETM.I_Status <> 0  
				AND TSTM.I_Status <> 0  
				AND CHARINDEX(',' + CONVERT(VARCHAR(10),I_Skill_ID) + ',', @sSkillIDs,0) > 0 AND TSTM.I_Center_ID = @iCenterID --AND TSTM.I_Training_Stage = @iTrainingStage  
				  
				IF((SELECT COUNT(I_Training_ID) FROM #tblTraining) = 0)  
				BEGIN  
					INSERT INTO #tblTraining  
					(I_Training_ID,S_Training_Desc,I_Training_Stage,I_Has_Attended)  
					SELECT DISTINCT TSTM.I_Training_ID, TETM.S_Training_Desc, TSTM.I_Training_Stage, NULL  
					FROM EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)  
					INNER JOIN EOS.T_Employee_Training_Master TETM WITH(NOLOCK)  
					ON TSTM.I_Training_ID = TETM.I_Training_ID  
					WHERE TETM.I_Status <> 0  
					AND TSTM.I_Status <> 0  
					AND CHARINDEX(',' + CONVERT(VARCHAR(10),I_Skill_ID) + ',', @sSkillIDs,0) > 0 AND TSTM.I_Center_ID IS NULL --AND TSTM.I_Training_Stage = @iTrainingStage  
				END  
			END
		END  
	END  
	  
	DELETE FROM #tblTraining  
	WHERE I_Training_ID IN (SELECT I_Training_ID FROM EOS.T_Employee_Training_Details  
	WHERE I_Employee_ID = @iEmployeeID)  
	  
	SELECT I_Training_ID,S_Training_Desc,I_Training_Stage,I_Has_Attended FROM #tblTraining  
END
