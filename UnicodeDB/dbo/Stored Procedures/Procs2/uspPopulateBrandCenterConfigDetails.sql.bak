CREATE PROCEDURE [dbo].[uspPopulateBrandCenterConfigDetails]
(
	@iBrandID int,
	@dtDateTimeNow datetime	
)
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #tempTable
	(
		ID_Identity INT IDENTITY(1,1),
		I_Config_ID INT,
		S_Config_Code VARCHAR(50),
		S_Config_Value VARCHAR(50)
	)

	INSERT INTO #tempTable (S_Config_Code,S_Config_Value,I_Config_ID)

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
	I_BRAND_ID =@iBrandID
	AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow)
	AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow)

	SELECT S_Config_Code,S_Config_Value,I_Config_ID
		FROM #tempTable	

	Declare	@I_Center_Id Int
	Declare @I_Hierarchy_Level_Id Int
	Declare @I_Hierarchy_Detail_ID Int
	Declare @S_Hierarchy_Name Varchar(100)
	Declare @N_Discount_Percentage Numeric(8,2)
	Declare @I_Discount_Amount Int
	Declare @I_Center_Discount_Id Int
	Declare @I_Brand_Id_Cursor Int

	Create Table #Discount
	(
		I_Center_Id Int,
		I_Hierarchy_Level_Id Int,
		I_Hierarchy_Detail_ID Int,
		S_Hierarchy_Name Varchar(100),
		N_Discount_Percentage Numeric(8,2),          
		I_Discount_Amount Int,
		I_Center_Discount_Id Int,
		I_Brand_Id Int
	)
	
	Insert Into #Discount
	SELECT DISTINCT CD.I_Center_Id,
		CD.I_Hierarchy_Level_Id,
		CD.I_Hierarchy_Detail_ID,
		HD.S_Hierarchy_Name,
		CD.N_Discount_Percentage,
		--CD.I_Discount_Amount,
		CD.I_Center_Discount_Id,
		@iBrandID As I_Brand_Id
	FROM dbo.T_Center_Discount_Details CD
		LEFT OUTER JOIN dbo.T_Hierarchy_Details HD
		ON CD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
		WHERE ISNULL(CD.I_Status,1) = 1
		AND CD.I_Center_Id IS NULL
		AND CD.I_BRAND_ID =@iBrandID
		AND ISNULL(HD.I_Status,1) = 1

	Select * from #Discount Where I_Brand_ID=@iBrandID

	SELECT 0 AS I_Center_Id

	Drop Table #Discount
	DROP TABLE #tempTable

END
