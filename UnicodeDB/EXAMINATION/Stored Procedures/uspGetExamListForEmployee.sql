CREATE PROCEDURE [EXAMINATION].[uspGetExamListForEmployee]
(    
	@iUserID INT = NULL    
)    
AS  
  
BEGIN     
	SET NOCOUNT ON;  
	  
	CREATE TABLE #tblExams    
	(    
		I_Exam_Component_ID INT,    
		S_Component_Name VARCHAR(200),    
		S_Component_Type VARCHAR(10),    
		I_No_Of_Attempts_Allowed INT,    
		I_No_Of_Attempts INT,    
		I_Status INT    
	)    
	    
	DECLARE @iEmployeeID INT, @iSkillLength INT, @iEmployeeStatus INT, @iExamStage INT , @iCenterID INT, @sRoleIDs VARCHAR(1000),    
	@sSkillIDs VARCHAR(1000), @sExamIDs VARCHAR(1000), @iBrandID INT    
	    
	SET @sRoleIDs = ''    
	SET @sSkillIDs = ''    
	SET @sExamIDs = ''    
	    
	SELECT @iEmployeeID = I_Reference_ID FROM dbo.T_User_Master WHERE I_User_ID = @iUserID    
	SELECT @iCenterID = I_Centre_ID, @iEmployeeStatus = I_Status FROM dbo.T_Employee_Dtls WHERE I_Employee_ID = @iEmployeeID    
	SELECT @iBrandID = I_Brand_ID FROM dbo.T_Brand_Center_Details WHERE I_Centre_Id = @iCenterID    
	SELECT @sSkillIDs = @sSkillIDs + ',' + CONVERT(VARCHAR(10),I_Skill_ID) FROM EOS.T_Employee_Skill_Map WHERE I_Employee_ID = @iEmployeeID AND I_Status = 2
	SELECT @iSkillLength = LEN(@sSkillIDs)    
	SELECT @sRoleIDs = @sRoleIDs + ',' + CONVERT(VARCHAR(10),I_Role_ID) FROM EOS.T_Employee_Role_Map WHERE I_Employee_ID = @iEmployeeID    
	
	print @iEmployeeID
	print @sSkillIDs  
	print @iSkillLength  
	print @sRoleIDs  
	  
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
					SET @iExamStage = 1    
				END    
			ELSE IF (@iEmployeeStatus > 1)    
				BEGIN    
					SET @iExamStage = 2    
				END    
			ELSE    
				BEGIN    
					SET @iExamStage = 0    
				END    

			IF (@iEmployeeStatus = 1)	--Condition Added by Partha as on 06-Aug-2008
			BEGIN
				INSERT INTO #tblExams    
				(I_Exam_Component_ID,S_Component_Name,S_Component_Type,I_No_Of_Attempts_Allowed,I_No_Of_Attempts,I_Status)    
				SELECT DISTINCT TSEM.I_Exam_Component_ID, TECM.S_Component_Name, TECM.S_Component_Type, TSEM.I_Number_Of_Resits, NULL,TECM.I_Status    
				FROM EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)    
				INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
				ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
				WHERE I_Skill_ID in (SELECT * FROM dbo.fnString2Rows(@sSkillIDs,',')) AND TSEM.I_Centre_ID = @iCenterID AND TSEM.I_Exam_Stage = @iExamStage 
				    
				IF((SELECT COUNT(I_Exam_Component_ID) FROM #tblExams) = 0)    
				BEGIN    
					INSERT INTO #tblExams    
					(I_Exam_Component_ID,S_Component_Name,S_Component_Type,I_No_Of_Attempts_Allowed,I_No_Of_Attempts,I_Status)    
					SELECT DISTINCT TSEM.I_Exam_Component_ID, TECM.S_Component_Name, TECM.S_Component_Type, TSEM.I_Number_Of_Resits, NULL,TECM.I_Status    
					FROM EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)    
					INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
					ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
					WHERE I_Skill_ID in (SELECT * FROM dbo.fnString2Rows(@sSkillIDs,',')) AND I_Centre_ID IS NULL AND I_Exam_Stage = @iExamStage
				END 
			END

			IF (@iEmployeeStatus >1)	--Condition Added by Partha as on 06-Aug-2008
			BEGIN			    
				INSERT INTO #tblExams    
				(I_Exam_Component_ID,S_Component_Name,S_Component_Type,I_No_Of_Attempts_Allowed,I_No_Of_Attempts,I_Status)    
				SELECT DISTINCT TSEM.I_Exam_Component_ID, TECM.S_Component_Name, TECM.S_Component_Type, TSEM.I_Number_Of_Resits, NULL,TECM.I_Status    
				FROM EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)    
				INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
				ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
				WHERE I_Skill_ID in (SELECT * FROM dbo.fnString2Rows(@sSkillIDs,',')) AND TSEM.I_Centre_ID = @iCenterID 
				    
				IF((SELECT COUNT(I_Exam_Component_ID) FROM #tblExams) = 0)    
				BEGIN    
					INSERT INTO #tblExams    
					(I_Exam_Component_ID,S_Component_Name,S_Component_Type,I_No_Of_Attempts_Allowed,I_No_Of_Attempts,I_Status)    
					SELECT DISTINCT TSEM.I_Exam_Component_ID, TECM.S_Component_Name, TECM.S_Component_Type, TSEM.I_Number_Of_Resits, NULL,TECM.I_Status    
					FROM EOS.T_Skill_Exam_Map TSEM WITH(NOLOCK)    
					INNER JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
					ON TSEM.I_Exam_Component_ID = TECM.I_Exam_Component_ID    
					WHERE I_Skill_ID in (SELECT * FROM dbo.fnString2Rows(@sSkillIDs,',')) AND I_Centre_ID IS NULL 
				END 
			END
		END    
	END    
	    
	DELETE FROM #tblExams    
	WHERE I_Exam_Component_ID IN (SELECT I_Exam_Component_ID FROM EOS.T_Employee_Exam_Result    
	WHERE I_Employee_ID = @iEmployeeID AND B_Passed = 1)    
	    
	UPDATE #tblExams    
	SET I_No_Of_Attempts = (SELECT COUNT(TEER.I_No_Of_Attempts)    
	FROM EOS.T_Employee_Exam_Result TEER    
	WHERE #tblExams.I_Exam_Component_ID = TEER.I_Exam_Component_ID    
	AND TEER.I_Employee_ID = @iEmployeeID)    
	    
	DELETE FROM #tblExams    
	WHERE I_No_Of_Attempts_Allowed <= I_No_Of_Attempts    
	    
	SELECT I_Exam_Component_ID,S_Component_Name,S_Component_Type,I_No_Of_Attempts_Allowed,I_No_Of_Attempts,I_Status FROM #tblExams    

END
