CREATE PROCEDURE [dbo].[uspPopulateCenterConfigDetailsApplication]
(
	@iCenterID int,
	@dtDateTimeNow datetime	
)
AS
BEGIN
	
	DECLARE @iBrandID INT

	SELECT @iBrandID=I_BRAND_ID FROM DBO.T_BRAND_CENTER_DETAILS WHERE I_CENTRE_ID=@iCenterID

	CREATE TABLE #tempTable
	(
		ID_Identity INT IDENTITY(1,1),
		I_Config_ID INT,
		S_Config_Code VARCHAR(50),
		S_Config_Value VARCHAR(50)
	)

	INSERT INTO #tempTable (S_Config_Code,S_Config_Value,I_Config_ID)
	
	SELECT DISTINCT S_CONFIG_CODE,S_CONFIG_VALUE,I_CONFIG_ID
	FROM 
	DBO.T_CENTER_CONFIGURATION
	WHERE 
	I_CENTER_ID =@iCenterID AND
	I_STATUS = 1 AND 
	I_BRAND_ID IS NULL
	AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
	AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow)
	
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
