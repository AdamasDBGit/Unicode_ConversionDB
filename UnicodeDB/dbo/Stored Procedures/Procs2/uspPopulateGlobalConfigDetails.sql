CREATE PROCEDURE [dbo].[uspPopulateGlobalConfigDetails]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtDateTimeNow DATETIME
	SET @dtDateTimeNow=GETDATE()
	
	CREATE TABLE #TEMPTABLE
	(
		ID_IDENTITY INT IDENTITY(1,1),
		I_CONFIG_ID INT,
		S_CONFIG_CODE VARCHAR(50),
		S_CONFIG_VALUE VARCHAR(50)
	)

	INSERT INTO #TEMPTABLE 
	(
		S_CONFIG_CODE,
		S_CONFIG_VALUE,
		I_CONFIG_ID
	)
	
	SELECT 
	DISTINCT 
	S_CONFIG_CODE,
	S_CONFIG_VALUE,
	I_CONFIG_ID
	FROM 
	DBO.T_CENTER_CONFIGURATION
	WHERE 
	I_CENTER_ID IS NULL AND 
	I_STATUS = 1 AND 
	I_BRAND_ID IS NULL 	
	AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
	AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow)
	
	SELECT 
	S_CONFIG_CODE,
	S_CONFIG_VALUE,
	I_CONFIG_ID
	FROM 
	#TEMPTABLE

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
		AND CD.I_Center_Id IS NULL
		AND CD.I_BRAND_ID IS NULL
		AND ISNULL(HD.I_Status,1) = 1
		
	SELECT 0 AS I_Center_Id

END
