-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: '06/06/2007'
-- Description:	This Function return a table 
-- consisting of hierarchy instance chain, hierarchy detail ID
-- Return: Table
-- =============================================
CREATE FUNCTION [dbo].[fnGetInstanceNameChainForReports]
(
	@sHierarchyChain VARCHAR(max),
	@iBrandID INT
)
RETURNS  @rtnTable TABLE
(
	hierarchyDetailID INT,
	instanceChain VARCHAR(5000)
)

AS 
-- Returns the Table containing the center details.
BEGIN

	DECLARE @iHierarchyDetailID INT
	DECLARE @iGetIndexHierarchy INT
	DECLARE @sHierarchyDetailID VARCHAR(20)
	DECLARE @iLengthHierarchy INT
	DECLARE @sTempHierarchyChain VARCHAR(100)
	DECLARE @sTempInstanceNameChain VARCHAR(5000)

	-- Append a comma after the Hierarchy Chain
	SET @sHierarchyChain = @sHierarchyChain + ','

	-- Get the start index for Hierarchy
	SET @iGetIndexHierarchy = CHARINDEX(',',LTRIM(RTRIM(@sHierarchyChain)),1)

	-- If start index for Hierarchy is greater than 1
	IF @iGetIndexHierarchy > 1
	BEGIN
		WHILE LEN(@sHierarchyChain) > 0
		BEGIN
			SET @iGetIndexHierarchy = CHARINDEX(',',@sHierarchyChain,1)
			SET @iLengthHierarchy = LEN(@sHierarchyChain)
			SET @iHierarchyDetailID = CAST(LTRIM(RTRIM(LEFT(@sHierarchyChain,@iGetIndexHierarchy-1))) AS int)

			-- Get the hierarchy chain for the above Hierarchy Detail ID
			SELECT @sTempHierarchyChain = S_Hierarchy_Chain	
			FROM dbo.T_Hierarchy_Mapping_Details
			WHERE I_Hierarchy_Detail_ID = @iHierarchyDetailID
			AND I_Status = 1
			AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())

			-- Set the default value as empty string
			SET @sTempInstanceNameChain = ''

			-- Get the Brand code in insatnce name chain
			SELECT @sTempInstanceNameChain = 'Brand-' + BM.S_Brand_Code + ';  '
			FROM dbo.T_Brand_Master BM
			WHERE BM.I_Brand_ID = @iBrandID

			-- Get the instance name chain
			SELECT @sTempInstanceNameChain = @sTempInstanceNameChain + B.S_Hierarchy_Level_Name + '-' + A.S_Hierarchy_Name + ';  '
			FROM dbo.T_Hierarchy_Details A
			INNER JOIN dbo.T_Hierarchy_Level_Master B
			ON A.I_Hierarchy_Level_Id = B.I_Hierarchy_Level_Id	
			WHERE A.I_Hierarchy_Detail_ID IN (SELECT * FROM dbo.fnString2Rows(@sTempHierarchyChain,','))
						
			-- Truncate the last comma from the Instance Name chain
			SET @sTempInstanceNameChain = SUBSTRING(@sTempInstanceNameChain, 0, LEN(@sTempInstanceNameChain))

			-- Insert the center wchich falls under the selected Hierarchy and Brand
			INSERT INTO @rtnTable
			SELECT	@iHierarchyDetailID,
					@sTempInstanceNameChain

			SELECT @sHierarchyChain = SUBSTRING(@sHierarchyChain,@iGetIndexHierarchy + 1, @iLengthHierarchy - @iGetIndexHierarchy)
			SELECT @sHierarchyChain = LTRIM(RTRIM(@sHierarchyChain))
		END
	END
	
	RETURN;

END