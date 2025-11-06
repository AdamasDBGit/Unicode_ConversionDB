CREATE PROCEDURE [dbo].[uspUpdateCenterHierarchyNameDetails]
AS
BEGIN
	DECLARE @index INT, @rowCount INT, @iTempCenterID INT
	DECLARE @tblCenter TABLE(ID INT IDENTITY(1,1), CenterId INT)
	DECLARE @tblTempHierarchy TABLE (ID INT)
	DECLARE @iHierarchDetailID INT, @sHierarchyChain VARCHAR(100)
	DECLARE @CenterName VARCHAR(100), @BrandID INT, @BrandName VARCHAR(100), @RegionID INT, @RegionName VARCHAR(100)
	DECLARE @TerritoryID INT, @TerritoryName VARCHAR(100), @CityID INT, @CityName VARCHAR(100)
	
	
	INSERT INTO @tblCenter
	SELECT [TCM].[I_Centre_Id] FROM [dbo].[T_Centre_Master] AS TCM WHERE [TCM].[I_Status] = 1
	
	SELECT @index = 1, @rowCount = COUNT([ID]) FROM @tblCenter AS TC
	
	WHILE (@index <= @rowCount)
	BEGIN
		SELECT @iTempCenterID = CenterID FROM @tblCenter AS TC WHERE [TC].[ID] = @index
		
		SELECT	@iHierarchDetailID = [tchd].[I_Hierarchy_Detail_ID],
			@sHierarchyChain = [thmd].[S_Hierarchy_Chain]
		FROM [dbo].[T_Center_Hierarchy_Details] AS TCHD
		INNER JOIN [dbo].[T_Hierarchy_Mapping_Details] AS THMD
		ON TCHD.[I_Hierarchy_Detail_ID] = [THMD].[I_Hierarchy_Detail_ID]
		WHERE [TCHD].[I_Center_Id] = @iTempCenterID
		
		INSERT INTO @tblTempHierarchy( [ID] )
		SELECT CAST(Val AS INT) FROM [dbo].[fnString2Rows](@sHierarchyChain, ',') AS FSR
		
		SELECT @CenterName = [TCM].[S_Center_Name], @BrandID = [tbm].[I_Brand_ID], @BrandName = [TBM].[S_Brand_Name] 
		FROM [dbo].[T_Centre_Master] AS TCM	
		INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD
		ON [TCM].[I_Centre_Id] = [TBCD].[I_Centre_Id]
		INNER JOIN [dbo].[T_Brand_Master] AS TBM
		ON [TBCD].[I_Brand_ID] = [TBM].[I_Brand_ID]
		WHERE [TBCD].[I_Centre_Id] = @iTempCenterID
		
		SELECT @RegionID = [THD].[I_Hierarchy_Detail_ID], @RegionName = [THD].[S_Hierarchy_Name]
		FROM @tblTempHierarchy AS TTH
		INNER JOIN [dbo].[T_Hierarchy_Details] AS THD
		ON [THD].[I_Hierarchy_Detail_ID] = [TTH].[ID]
		INNER JOIN [dbo].[T_Hierarchy_Mapping_Details] AS THMD
		ON [THMD].[I_Hierarchy_Detail_ID] = [THD].[I_Hierarchy_Detail_ID]
		INNER JOIN [dbo].[T_Hierarchy_Level_Master] AS THLM
		ON [THLM].[I_Hierarchy_Level_Id] = [THD].[I_Hierarchy_Level_Id]
		WHERE [THLM].[I_Sequence] = 2
		
		SELECT @TerritoryID = [THD].[I_Hierarchy_Detail_ID], @TerritoryName = [THD].[S_Hierarchy_Name]
		FROM @tblTempHierarchy AS TTH
		INNER JOIN [dbo].[T_Hierarchy_Details] AS THD
		ON [THD].[I_Hierarchy_Detail_ID] = [TTH].[ID]
		INNER JOIN [dbo].[T_Hierarchy_Mapping_Details] AS THMD
		ON [THMD].[I_Hierarchy_Detail_ID] = [THD].[I_Hierarchy_Detail_ID]
		INNER JOIN [dbo].[T_Hierarchy_Level_Master] AS THLM
		ON [THLM].[I_Hierarchy_Level_Id] = [THD].[I_Hierarchy_Level_Id]
		WHERE [THLM].[I_Sequence] = 3
		
		SELECT @CityID = [THD].[I_Hierarchy_Detail_ID], @CityName = [THD].[S_Hierarchy_Name]
		FROM @tblTempHierarchy AS TTH
		INNER JOIN [dbo].[T_Hierarchy_Details] AS THD
		ON [THD].[I_Hierarchy_Detail_ID] = [TTH].[ID]
		INNER JOIN [dbo].[T_Hierarchy_Mapping_Details] AS THMD
		ON [THMD].[I_Hierarchy_Detail_ID] = [THD].[I_Hierarchy_Detail_ID]
		INNER JOIN [dbo].[T_Hierarchy_Level_Master] AS THLM
		ON [THLM].[I_Hierarchy_Level_Id] = [THD].[I_Hierarchy_Level_Id]
		WHERE [THLM].[I_Sequence] = 4
		
		IF EXISTS (SELECT [TCHND].[I_Center_ID] FROM [dbo].[T_Center_Hierarchy_Name_Details] AS TCHND 
				WHERE [TCHND].[I_Center_ID] = @iTempCenterID)
		BEGIN
			UPDATE [dbo].[T_Center_Hierarchy_Name_Details]
			SET	[S_Center_Name] = @CenterName,
				[I_Brand_ID] = @BrandID,
				[S_Brand_Name] = @BrandName,
				[I_Region_ID] = @RegionID,
				[S_Region_Name] = @RegionName,
				[I_Territory_ID] = @TerritoryID,
				[S_Territiry_Name] = @TerritoryName,
				[I_City_ID] = @CityID,
				[S_City_Name] = @CityName,
				[I_Hierarchy_Detail_ID] = @iHierarchDetailID
			WHERE [I_Center_ID] = @iTempCenterID
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[T_Center_Hierarchy_Name_Details]
	        ( [I_Center_ID] ,
	          [S_Center_Name] ,
	          [I_Brand_ID] ,
	          [S_Brand_Name] ,
	          [I_Region_ID] ,
	          [S_Region_Name] ,
	          [I_Territory_ID] ,
	          [S_Territiry_Name] ,
	          [I_City_ID] ,
	          [S_City_Name],
	          [I_Hierarchy_Detail_ID]
	        )		      	        
		VALUES  
			( @iTempCenterID,
			  @CenterName,
			  @BrandID,
			  @BrandName,
			  @RegionID,
			  @RegionName,
			  @TerritoryID,
			  @TerritoryName,
			  @CityID,
			  @CityName,
			  @iHierarchDetailID
	        )
		END
		
		DELETE FROM @tblTempHierarchy
		
		SET @index = @index + 1
	END
	
	
END
