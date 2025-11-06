CREATE PROCEDURE [dbo].[uspPopulateCenterConfigDetails]
(
	@iCenterID int,
	@dtDateTimeNow datetime	
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @iBrandID INT

	SELECT @iBrandID=I_BRAND_ID FROM DBO.T_BRAND_CENTER_DETAILS WHERE I_CENTRE_ID=@iCenterID

	CREATE TABLE #tempTable
	(
		ID_Identity INT IDENTITY(1,1),
		I_Config_ID INT,
		S_Config_Code VARCHAR(50),
		S_Config_Value VARCHAR(50)
	)

	--Populating Global Configuration
	INSERT INTO #tempTable (S_Config_Code,S_Config_Value,I_Config_ID)
	
	SELECT DISTINCT S_CONFIG_CODE,S_CONFIG_VALUE,I_CONFIG_ID
	FROM 
	DBO.T_CENTER_CONFIGURATION
	WHERE 
	I_CENTER_ID IS NULL AND 
	I_STATUS = 1 AND 
	I_BRAND_ID IS NULL

	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @sConfigCode VARCHAR(50)
	
	SELECT @iRowCount = count(ID_Identity) FROM #tempTable
	
	--Overwrite Brand Configuration
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sConfigCode = S_Config_Code FROM #tempTable 
		WHERE ID_Identity = @iCount
		
		IF EXISTS (SELECT * FROM dbo.T_Center_Configuration 
				WHERE I_Center_Id IS NULL
				AND S_Config_Code = @sConfigCode
				AND I_BRAND_ID =@iBrandID
				AND I_Status = 1
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
				AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			UPDATE #tempTable
			SET S_Config_Value = 
				(SELECT S_Config_Value FROM dbo.T_Center_Configuration 
				WHERE I_Center_Id  IS NULL
				AND S_Config_Code = @sConfigCode
				AND I_BRAND_ID = @iBrandID
				AND I_Status = 1
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
				AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
			WHERE ID_Identity = @iCount 
		
		END
		
		SET @iCount = @iCount + 1
	END

	--Overwrite Center Configuration
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sConfigCode = S_Config_Code FROM #tempTable 
		WHERE ID_Identity = @iCount
		
		IF EXISTS (SELECT * FROM dbo.T_Center_Configuration 
				WHERE I_Center_Id =@iCenterID
				AND S_Config_Code = @sConfigCode
				--AND I_BRAND_ID =@iBrandID
				AND I_BRAND_ID IS NULL
				AND I_Status = 1
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
				AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			UPDATE #tempTable
			SET S_Config_Value = 
				(SELECT S_Config_Value FROM dbo.T_Center_Configuration 
				WHERE I_Center_Id  = @iCenterID
				AND S_Config_Code = @sConfigCode
				--AND I_BRAND_ID = @iBrandID
				AND I_BRAND_ID IS NULL
				AND I_Status = 1
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
				AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
			WHERE ID_Identity = @iCount 
		
		END
		
		SET @iCount = @iCount + 1
	END
		
	SELECT S_Config_Code,S_Config_Value,I_Config_ID FROM #tempTable
	
	SELECT CD.I_Center_Id,
		CD.I_Hierarchy_Level_Id,
		CD.I_Hierarchy_Detail_ID,
		HD.S_Hierarchy_Name,
		CD.N_Discount_Percentage,
		--CD.I_Discount_Amount,
		CD.I_Center_Discount_Id
	FROM dbo.T_Center_Discount_Details CD
		LEFT OUTER JOIN dbo.T_Hierarchy_Details HD
		ON CD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
		WHERE ISNULL(CD.I_Status,1) = 1
		AND CD.I_Center_Id = @iCenterID
		AND CD.I_Brand_Id IS NULL
		AND ISNULL(HD.I_Status,1) = 1

	SELECT @iCenterID AS I_Center_Id
	
END
