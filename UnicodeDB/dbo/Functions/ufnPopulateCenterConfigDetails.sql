CREATE FUNCTION [dbo].[ufnPopulateCenterConfigDetails]
(
	@iCenterID int,
	@dtDateTimeNow datetime	
)
RETURNS @tempTable TABLE
(
	ID_Identity INT IDENTITY(1,1),
	I_Config_ID INT,
	S_Config_Code VARCHAR(50),
	S_Config_Value VARCHAR(50)
)
AS
BEGIN
	
	DECLARE @iBrandID INT

	SELECT @iBrandID=I_BRAND_ID FROM DBO.T_BRAND_CENTER_DETAILS  WITH (NOLOCK) WHERE I_CENTRE_ID=@iCenterID

--	CREATE TABLE @tempTable1
--	(
--		ID_Identity INT IDENTITY(1,1),
--		I_Config_ID INT,
--		S_Config_Code VARCHAR(50),
--		S_Config_Value VARCHAR(50)
--	)

	--Populating Global Configuration
	INSERT INTO @tempTable (S_Config_Code,S_Config_Value,I_Config_ID)
	
	SELECT DISTINCT S_CONFIG_CODE,S_CONFIG_VALUE,I_CONFIG_ID
	FROM 
	DBO.T_CENTER_CONFIGURATION WITH (NOLOCK)
	WHERE 
	I_CENTER_ID IS NULL AND 
	I_STATUS = 1 AND 
	I_BRAND_ID IS NULL

	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @sConfigCode VARCHAR(50)
	
	SELECT @iRowCount = count(ID_Identity) FROM @tempTable
	
	--Overwrite Brand Configuration
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @sConfigCode = S_Config_Code FROM @tempTable 
		WHERE ID_Identity = @iCount
		
		IF EXISTS (SELECT * FROM dbo.T_Center_Configuration WITH (NOLOCK)
				WHERE I_Center_Id IS NULL
				AND S_Config_Code = @sConfigCode
				AND I_BRAND_ID =@iBrandID
				AND I_Status = 1
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
				AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			UPDATE @tempTable
			SET S_Config_Value = 
				(SELECT S_Config_Value FROM dbo.T_Center_Configuration WITH (NOLOCK)
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
		SELECT @sConfigCode = S_Config_Code FROM @tempTable 
		WHERE ID_Identity = @iCount
		
		IF EXISTS (SELECT * FROM dbo.T_Center_Configuration WITH (NOLOCK)
				WHERE I_Center_Id =@iCenterID
				AND S_Config_Code = @sConfigCode
				--AND I_BRAND_ID =@iBrandID
				AND I_BRAND_ID IS NULL
				AND I_Status = 1
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
				AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			UPDATE @tempTable
			SET S_Config_Value = 
				(SELECT S_Config_Value FROM dbo.T_Center_Configuration WITH (NOLOCK)
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
	

	RETURN;
END