-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPGetCenterHierarchyNameData_INT]
(
	@UpdateON			Varchar(20) =NULL,
	@MaxID				INT			=NULL
)
AS
BEGIN
	DECLARE @VarDate	DATE;

	IF @UpdateON='' OR @UpdateON IS NULL
	BEGIN
		SET @VarDate=NULL
	END
	ELSE
	BEGIN
		SET @VarDate=CAST(@UpdateON AS DATE)
	END	

	IF @MaxID<>0  
	BEGIN
		SELECT
		[I_Center_ID]					AS [Id]			,
		[S_Center_Name]					AS [CenterName]	,
		[I_Brand_ID]					AS [BrandId]		,
		[S_Brand_Name]					AS [BrandName]		,
		[I_Region_ID]					AS [RegionId]		,
		[S_Region_Name]					AS [RegionName]	,
		[I_Territory_ID]				AS [TerritoryId]	,
		[S_Territiry_Name]				AS [TerritiryName]	,
		[I_City_ID]						AS [CityId]		,
		[S_City_Name]					AS [CityName],
		0								AS [IsForUpdate]		
		FROM 
		[dbo].[T_Center_Hierarchy_Name_Details]	
		WHERE [I_Center_ID]>@MaxID
	END
	ELSE IF @MaxID=0 
	BEGIN
		SELECT
		[I_Center_ID]					AS [Id]			,
		[S_Center_Name]					AS [CenterName]	,
		[I_Brand_ID]					AS [BrandId]		,
		[S_Brand_Name]					AS [BrandName]		,
		[I_Region_ID]					AS [RegionId]		,
		[S_Region_Name]					AS [RegionName]	,
		[I_Territory_ID]				AS [TerritoryId]	,
		[S_Territiry_Name]				AS [TerritiryName]	,
		[I_City_ID]						AS [CityId]		,
		[S_City_Name]					AS [CityName],
		0								AS [IsForUpdate]		
		FROM 
		[dbo].[T_Center_Hierarchy_Name_Details]	
	END

		
		
	
END
