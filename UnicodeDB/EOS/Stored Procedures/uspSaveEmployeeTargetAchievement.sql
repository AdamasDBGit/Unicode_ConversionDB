/**************************************************************************************************************
Created by  : Swagata De
Date		: 22.06.2007
Description : This SP will save the employee target achievement details
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspSaveEmployeeTargetAchievement]
(	
 @iEmployeeID INT,
 @sEvaluations XML,
 @sCreatedBy VARCHAR(20),
 @sUpdatedBy VARCHAR(20),
 @dtCreatedOn DATETIME,
 @dtUpdatedOn DATETIME ,
 @iYear INT,
 @iMonth INT
)
	
AS
BEGIN TRY
	--	Create Temporary Table to store KRA details
	CREATE TABLE #tempTable
	( 
		ID INT IDENTITY(1,1),
		I_Employee_ID int, 
		I_Month int,
		I_Year int,          
		I_KRA_ID int,
		I_SubKRA_Id int,
		N_Target_Achieved numeric(18,2),
		N_Target_Set numeric(18,2),
		N_Weightage numeric(8,2),
		S_Performance_Evaluation VARCHAR(500)	
	)

--	Insert Values into Temporary Table
	INSERT INTO #tempTable(I_KRA_ID,I_SubKRA_Id,N_Target_Set,N_Target_Achieved,N_Weightage,S_Performance_Evaluation)
	SELECT T.c.value('@KRAID','int'),
		   T.c.value('@SubKRAID','int')	,
		   T.c.value('@Target','numeric(18,2)'),
		   T.c.value('@Achievement','numeric(18,2)'),
		   T.c.value('@Weightage','numeric(18,2)'),
		   NULL
	FROM   @sEvaluations.nodes('/KRAEvalList/KRAEvalElement') T(c)
	
	UPDATE  #tempTable
	SET  I_Employee_ID=@iEmployeeID,
	I_Month=@iMonth,I_Year=@iYear
	
	--Set subKRA IDs as 0 if they are null
	UPDATE #tempTable
	SET I_SubKRA_Id = NULL
	WHERE I_SubKRA_Id=0

	--Assign Weightages to KRA
    --Delete the existing employee KRA Mapping	
	DELETE FROM EOS.T_Employee_KRA_Map WHERE I_Employee_ID=@iEmployeeID
	
	--Insert the new Employee KRA info into the table
	
	INSERT INTO EOS.T_Employee_KRA_Map
	(
		I_KRA_ID,
		I_Employee_ID,
		N_Weightage,
		I_SubKRA_Id,
		I_Status
	)	
	SELECT I_KRA_ID,I_Employee_ID,N_Weightage,I_SubKRA_Id,1
	FROM #tempTable
	
	UPDATE EOS.T_Employee_KRA_Map
	SET S_Crtd_By = @sCreatedBy,Dt_Crtd_On = @dtCreatedOn
	WHERE I_Employee_ID = @iEmployeeID

	--Save target achievements
	DECLARE @iTotalRowCount INT, @iRowCount INT, @iKRAID INT, @iSubKRAID INT
	DECLARE	@nTarget NUMERIC(18,2), @nAchievement NUMERIC(18,2), @nWeightage NUMERIC(18,2), @nPE NUMERIC(18,2)
	
	SELECT @iTotalRowCount = COUNT(I_Employee_ID) FROM #tempTable
	SET @iRowCount = 1
	
	WHILE (@iRowCount <= @iTotalRowCount)
	BEGIN
		SELECT	@iKRAID = I_KRA_ID,
				@iSubKRAID = ISNULL(I_SubKRA_Id,0),
				@nTarget = N_Target_Set,
				@nAchievement = N_Target_Achieved
		FROM #tempTable
		WHERE ID = @iRowCount
		
		IF (@iSubKRAID = 0)
		BEGIN
			SELECT @nWeightage = N_Weightage
			FROM EOS.T_Employee_KRA_Map
			WHERE I_Employee_ID = @iEmployeeID
			AND	I_KRA_ID = @iKRAID
			AND I_SubKRA_Id IS NULL
		END
		ELSE
		BEGIN
			SELECT @nWeightage = N_Weightage
			FROM EOS.T_Employee_KRA_Map
			WHERE I_Employee_ID = @iEmployeeID
			AND	I_KRA_ID = @iKRAID
			AND I_SubKRA_Id = @iSubKRAID
		END
		
		IF (@nAchievement > @nTarget)
		BEGIN
			SET @nPE = @nWeightage
		END
		ELSE IF (@nTarget <> 0)
		BEGIN
			SET @nPE = (@nWeightage * @nAchievement)/@nTarget
		END
		
		UPDATE #tempTable
		SET N_Weightage = @nWeightage,
			S_Performance_Evaluation = CONVERT(VARCHAR(500), @nPE)
		WHERE ID = @iRowCount
		
		SET @iRowCount = @iRowCount + 1
	END
	
	--Delete the existing employee KRA Mapping	
	IF EXISTS(SELECT 1 FROM EOS.T_Employee_KRA_Details WHERE I_Employee_ID = @iEmployeeID
					AND I_Target_Year = @iYear AND I_Target_Month = @iMonth)
	BEGIN
		DELETE FROM EOS.T_Employee_KRA_Details WHERE I_Employee_ID = @iEmployeeID
					AND I_Target_Year = @iYear AND I_Target_Month = @iMonth
	END
	
	--Insert the new Employee KRA info into the table	
	INSERT INTO EOS.T_Employee_KRA_Details
	(
		I_Employee_ID,
		I_KRA_ID,
		I_SubKRA_ID,
		I_Target_Month,
		I_Target_Year,
		N_Target_Achieved,
		N_Target_Set,
		S_Performance_Evaluation
	)		
	SELECT 	
		I_Employee_ID,
		I_KRA_ID ,
		I_SubKRA_Id ,
		I_Month ,
		I_Year,
		N_Target_Achieved,
		N_Target_Set,
		S_Performance_Evaluation
	FROM #tempTable	
	
	UPDATE EOS.T_Employee_KRA_Details
	SET S_Crtd_By = @sCreatedBy, Dt_Crtd_On = @dtCreatedOn, S_Upd_By = @sCreatedBy, Dt_Upd_On = @dtCreatedOn
	WHERE I_Employee_ID = @iEmployeeID AND I_Target_Year = @iYear AND I_Target_Month = @iMonth
	
END TRY
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
