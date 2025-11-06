CREATE PROCEDURE [EOS].[uspGetEmployeeTrainingDetails]
(
	@iEmployeeID INT
)
AS
BEGIN	

	DECLARE @iCenterID INT, @iRowCount INT, @iBrandID INT
	SELECT @iCenterID = I_Centre_ID FROM dbo.T_Employee_Dtls WHERE I_Employee_ID = @iEmployeeID
	SELECT @iBrandID = I_Brand_ID FROM dbo.T_Brand_Center_Details WHERE I_Centre_Id = @iCenterID

	CREATE TABLE #tempSkill
	(
		I_Emp_ID INT,
		I_Skill_ID INT,
		S_Skill_No VARCHAR(20),
		S_Skill_Desc VARCHAR(100),
		S_Skill_Type VARCHAR(50),
		I_Status INT
	)

	INSERT INTO #tempSkill
	SELECT  @iEmployeeID,
			TESM.I_Skill_ID,						
			TSM.S_Skill_No,
			TSM.S_Skill_Desc,
			TSM.S_Skill_Type,
			TESM.I_Status
	FROM EOS.T_Employee_Skill_Map TESM WITH(NOLOCK)
	INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK)
	ON TESM.I_Skill_ID=TSM.I_Skill_ID
	WHERE	TESM.I_Status <> 0
		AND	TESM.I_Employee_ID = @iEmployeeID
	
	SELECT @iRowCount = COUNT(TRSM.I_Skill_ID) FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)
	INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)
	ON TERM.I_Role_ID = TRSM.I_Role_ID
	WHERE	TERM.I_Status_ID <> 0
		AND	TRSM.I_Status <> 0
		AND	TERM.I_Employee_ID = @iEmployeeID		
		AND TRSM.I_Centre_ID = @iCenterID
		AND TRSM.I_Brand_ID = @iBrandID
		
	IF (@iRowCount = 0)
	BEGIN		
		INSERT INTO #tempSkill
		SELECT  @iEmployeeID,
				TRSM.I_Skill_ID,
				TSM.S_Skill_No,
				TSM.S_Skill_Desc,
				TSM.S_Skill_Type,
				TRSM.I_Status
		FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)
		INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)
		ON TERM.I_Role_ID = TRSM.I_Role_ID
		INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK)
		ON TRSM.I_Skill_ID = TSM.I_Skill_ID
		WHERE	TERM.I_Status_ID <> 0
			AND	TRSM.I_Status <> 0
			AND	TERM.I_Employee_ID = @iEmployeeID			
			AND TRSM.I_Centre_ID IS NULL
			AND TRSM.I_Brand_ID = @iBrandID
	END
	ELSE
	BEGIN		
		INSERT INTO #tempSkill
		SELECT  @iEmployeeID,
				TRSM.I_Skill_ID,
				TSM.S_Skill_No,
				TSM.S_Skill_Desc,
				TSM.S_Skill_Type,
				TRSM.I_Status
		FROM EOS.T_Employee_Role_Map TERM WITH(NOLOCK)
		INNER JOIN EOS.T_Role_Skill_Map TRSM WITH(NOLOCK)
		ON TERM.I_Role_ID = TRSM.I_Role_ID
		INNER JOIN dbo.T_EOS_Skill_Master TSM WITH(NOLOCK)
		ON TRSM.I_Skill_ID = TSM.I_Skill_ID
		WHERE	TERM.I_Status_ID <> 0
			AND	TRSM.I_Status <> 0
			AND	TERM.I_Employee_ID = @iEmployeeID
			AND TRSM.I_Centre_ID = @iCenterID
			AND TRSM.I_Brand_ID = @iBrandID
	END
	
	CREATE TABLE #tempTraining
	(
		I_Emp_ID INT,
		I_Training_ID INT,
		S_Training_Desc VARCHAR(500),
		I_Training_Stage INT,
		I_Has_Attended INT
	)
	
	SELECT @iRowCount = COUNT(I_Training_ID) FROM EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)
	WHERE	I_Skill_ID IN (SELECT I_Skill_ID FROM #tempSkill)
		AND I_Status <> 0
		AND TSTM.I_Center_ID = @iCenterID
		
	IF (@iRowCount = 0)
	BEGIN			
		INSERT INTO #tempTraining
		-- Get the Skill Training Details
		SELECT  T.I_Emp_ID,				
				TSTM.I_Training_ID,
				TETM.S_Training_Desc,
				TSTM.I_Training_Stage,
				0				
		FROM #tempSkill T WITH(NOLOCK)
		INNER JOIN EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)
		ON T.I_Skill_ID = TSTM.I_Skill_ID
		INNER JOIN EOS.T_Employee_Training_Master TETM WITH(NOLOCK)
		ON TSTM.I_Training_ID = TETM.I_Training_ID
		WHERE	TSTM.I_Status <> 0
			AND	TSTM.I_Center_ID IS NULL
	END
	ELSE
	BEGIN
		INSERT INTO #tempTraining
		-- Get the Skill Training Details
		SELECT  T.I_Emp_ID,				
				TSTM.I_Training_ID,
				TETM.S_Training_Desc,
				TSTM.I_Training_Stage,
				0				
		FROM #tempSkill T WITH(NOLOCK)
		INNER JOIN EOS.T_Skill_Training_Mapping TSTM WITH(NOLOCK)
		ON T.I_Skill_ID = TSTM.I_Skill_ID
		INNER JOIN EOS.T_Employee_Training_Master TETM WITH(NOLOCK)
		ON TSTM.I_Training_ID = TETM.I_Training_ID
		WHERE	TSTM.I_Status <> 0
			AND	TSTM.I_Center_ID = @iCenterID
	END
	
	UPDATE #tempTraining
	SET I_Has_Attended = 1
	WHERE I_Training_ID IN (SELECT I_Training_ID FROM EOS.T_Employee_Training_Details WHERE I_Employee_ID = @iEmployeeID)
	
	SELECT DISTINCT * FROM #tempTraining
	
END
