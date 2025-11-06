CREATE FUNCTION [EOS].[fnCheckEmployeeExamStatus]
(
	@iEmployeeID INT,
	@iRoleID INT = NULL,
	@iCenterID INT = NULL,
	@iFacultyRoleID INT
)
RETURNS BIT

AS
BEGIN
	DECLARE @Skills VARCHAR(1000), @ExamsToAppear VARCHAR(1000), @SkillsType VARCHAR(1000), @iBrandID INT,
			@ExamsToPass VARCHAR(1000), @ExamAppeared VARCHAR(1000), @ExamPassed VARCHAR(1000), @bReturn BIT

	SET @bReturn = 0	
	SET @Skills = ''
	SET @SkillsType = ''
	SET @ExamsToAppear = ''
	SET @ExamsToPass = ''
	SET @ExamAppeared =''
	SET @ExamPassed =''

	SELECT @iBrandID = I_Brand_ID FROM dbo.T_Brand_Center_Details WHERE I_Centre_Id = @iCenterID
	
	IF(@iRoleID IS NOT NULL)
	BEGIN		
		IF (@iRoleID = @iFacultyRoleID)
		BEGIN
			SELECT @Skills = @Skills + ',' + CONVERT(VARCHAR(10),I_Skill_ID) FROM EOS.T_Employee_Skill_Map WHERE I_Employee_ID = @iEmployeeID
		END

		SELECT @Skills = @Skills + ',' + CONVERT(VARCHAR,I_SKILL_ID) FROM EOS.T_ROLE_SKILL_MAP 
				WHERE I_Role_ID = @iRoleID AND I_Centre_ID = @iCenterID AND I_Brand_ID = @iBrandID AND I_Status <> 0
		
		IF (LEN(@Skills) = 0)
		BEGIN
			SELECT @Skills = @Skills + ',' + CONVERT(VARCHAR,I_SKILL_ID) FROM EOS.T_ROLE_SKILL_MAP 
				WHERE I_Role_ID = @iRoleID AND I_Centre_ID IS NULL AND I_Brand_ID = @iBrandID AND I_Status <> 0
		END
		
		IF (LEN(@Skills) > 0)
		BEGIN
			SET @Skills = @Skills + ','
			
			SELECT @ExamsToAppear = @ExamsToAppear + ',' + CONVERT(VARCHAR,I_EXAM_COMPONENT_ID) FROM EOS.T_SKILL_EXAM_MAP 
					WHERE CHARINDEX( ','  + CONVERT(VARCHAR,I_SKILL_ID) + ',' , @Skills )> 0 
					AND I_Centre_ID = @iCenterID AND I_Status <> 0
					ORDER BY I_EXAM_COMPONENT_ID
						
			SELECT @ExamsToPass = @ExamsToPass + ',' + CONVERT(VARCHAR,I_EXAM_COMPONENT_ID) FROM EOS.T_SKILL_EXAM_MAP 
					WHERE CHARINDEX( ','  + CONVERT(VARCHAR,I_SKILL_ID) + ',' , @Skills )> 0 
					AND I_Centre_ID = @iCenterID AND I_Status <> 0
					AND Is_Pass_Mandatory = 1 ORDER BY I_EXAM_COMPONENT_ID
						
			IF (LEN(@ExamsToAppear) = 0)
			BEGIN
				SELECT @ExamsToAppear = @ExamsToAppear + ',' + CONVERT(VARCHAR,I_EXAM_COMPONENT_ID) FROM EOS.T_SKILL_EXAM_MAP 
					WHERE CHARINDEX( ','  + CONVERT(VARCHAR,I_SKILL_ID) + ',' , @Skills )> 0 
					AND I_Centre_ID IS NULL AND I_Status <> 0
					ORDER BY I_EXAM_COMPONENT_ID
						
				SELECT @ExamsToPass = @ExamsToPass + ',' + CONVERT(VARCHAR,I_EXAM_COMPONENT_ID) FROM EOS.T_SKILL_EXAM_MAP 
					WHERE CHARINDEX( ','  + CONVERT(VARCHAR,I_SKILL_ID) + ',' , @Skills )> 0
						AND I_Centre_ID IS NULL  AND I_Status <> 0
						AND Is_Pass_Mandatory = 1 ORDER BY I_EXAM_COMPONENT_ID
			END
		END
	END
	
	DECLARE @tbl TABLE(I_EXAM_COMPONENT_ID INT)
	
	INSERT INTO @tbl
	SELECT DISTINCT I_EXAM_COMPONENT_ID FROM EOS.T_Employee_Exam_Result
	WHERE I_Employee_ID = @iEmployeeID
	ORDER BY I_EXAM_COMPONENT_ID

	SELECT @ExamAppeared = @ExamAppeared + ',' + CONVERT(VARCHAR,I_EXAM_COMPONENT_ID) FROM @tbl 					
						ORDER BY I_EXAM_COMPONENT_ID

	DELETE FROM @tbl
	
	INSERT INTO @tbl
	SELECT DISTINCT I_EXAM_COMPONENT_ID FROM EOS.T_Employee_Exam_Result
	WHERE I_Employee_ID = @iEmployeeID
	AND B_Passed = 1
	ORDER BY I_EXAM_COMPONENT_ID
	
	SELECT @ExamPassed = @ExamPassed + ',' + CONVERT(VARCHAR,I_EXAM_COMPONENT_ID) FROM @tbl 					
						ORDER BY I_EXAM_COMPONENT_ID
							
	SET @ExamAppeared = @ExamAppeared + ','
	SET @ExamsToAppear = @ExamsToAppear + ','
	SET @ExamPassed = @ExamPassed + ','
	SET @ExamsToPass = @ExamsToPass + ','

	IF ((@ExamAppeared LIKE '%' + @ExamsToAppear + '%'  OR LEN(@ExamAppeared) > LEN(@ExamsToAppear))
		AND (@ExamPassed LIKE '%' + @ExamsToPass + '%' OR LEN(@ExamPassed) > LEN(@ExamsToPass)))
	BEGIN
		SET @bReturn = 1
	END
	ELSE IF (@iRoleID = @iFacultyRoleID AND @ExamPassed <> ',') -- For Role Faculty
	BEGIN

		---------------Check for HR Skill------------------------
		DECLARE @SKILL VARCHAR(30)
		SET @SKILL=''
		SELECT @SKILL=@SKILL+','+T.VAL FROM
		(
			SELECT VAL FROM DBO.FNSTRING2ROWS(@EXAMSTOPASS,',')
			EXCEPT
			SELECT VAL FROM DBO.FNSTRING2ROWS(@EXAMPASSED,',')
		) T

		SELECT @SKILLSTYPE = @SKILLSTYPE + ',' + UPPER(ESM.S_SKILL_TYPE) FROM EOS.T_SKILL_EXAM_MAP SEM
			INNER JOIN DBO.T_EOS_SKILL_MASTER ESM
			ON ESM.I_SKILL_ID = SEM.I_SKILL_ID
			WHERE SEM.I_EXAM_COMPONENT_ID IN (SELECT * FROM DBO.FNSTRING2ROWS(@SKILL,','))

		IF (SUBSTRING(@SKILLSTYPE,2,LEN(@SKILLSTYPE)) LIKE '%' + 'HR' + '%')
		BEGIN
			SET @BRETURN = 0
			RETURN @BRETURN
			--RETURN
		END
		--------------------------
		SET @SkillsType=''
		SELECT @SkillsType = @SkillsType + ',' + UPPER(ESM.S_Skill_Type) FROM EOS.T_Skill_Exam_Map SEM
			INNER JOIN dbo.T_EOS_Skill_Master ESM
			ON ESM.I_Skill_ID = SEM.I_Skill_ID
			WHERE SEM.I_Exam_Component_ID IN (SELECT * FROM dbo.fnString2Rows(@ExamPassed,','))

		IF (SUBSTRING(@SkillsType,2,LEN(@SkillsType)) LIKE '%' + 'FACULTY' + '%')
		BEGIN
			SET @bReturn = 1
		END
	END
	ELSE
	BEGIN
		SET @bReturn = 0
	END

	RETURN @bReturn
END