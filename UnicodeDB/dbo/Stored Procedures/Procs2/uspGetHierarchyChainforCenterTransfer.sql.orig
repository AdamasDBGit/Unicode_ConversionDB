CREATE PROCEDURE [dbo].[uspGetHierarchyChainforCenterTransfer] 

(
	@sSalesOrgChain varchar(500),
	@sHierarchyChain varchar(500)
)

AS
BEGIN
	DECLARE
		@iCtryLevelId int,
		@iHierarchyDetailID varchar(10),
		@iPos int,
		@iIDPos int
		
	DECLARE @tblTemp TABLE
	(	
		[ID] int identity(1,1),
		iHDid int,
		iHLid int
	)
	
	--SET @iCtryLevelId=( SELECT top 1 I_Hierarchy_Level_Id FROM dbo.T_Hierarchy_Level_Master WHERE S_Hierarchy_Level_Code='CO' AND I_Status<>0)
	--set @iCtryLevelId = (select I_Hierarchy_Level_Id from dbo.T_Hierarchy_Level_Master where I_Hierarchy_Master_ID = @iHierarchyMasterID and S_Hierarchy_Level_Code='CO')

	SET @iCtryLevelId = (SELECT TOP 1 * FROM  dbo.fnString2Rows(@sSalesOrgChain,','))
	
	SET @sHierarchyChain = LTRIM(RTRIM(@sHierarchyChain))+ ','
	SET @iPos = CHARINDEX(',', @sHierarchyChain, 1)
	
	--Parsing the hierarchy Chain

	IF REPLACE(@sHierarchyChain, ',', '') <> ''
	BEGIN
		WHILE @iPos > 0
		BEGIN
			SET @iHierarchyDetailID = LTRIM(RTRIM(LEFT(@sHierarchyChain, @iPos - 1)))
			IF @iHierarchyDetailID <> ''
			BEGIN
				INSERT INTO @tblTemp (iHDid) VALUES (CAST(@iHierarchyDetailID AS int)) --Use Appropriate conversion
			END
			SET @sHierarchyChain = RIGHT(@sHierarchyChain, LEN(@sHierarchyChain) - @iPos)
			SET @iPos = CHARINDEX(',', @sHierarchyChain, 1)

		END
	END

	UPDATE TT
	SET iHLid=
	(SELECT HD.I_Hierarchy_Level_Id FROM T_Hierarchy_Details HD WHERE TT.iHDid=HD.I_Hierarchy_Detail_ID AND HD.I_Status<>0)
	FROM @tblTemp TT
	

	
		--Find the hierarchy detail Id corresponding to country level id
		SET @iIDPos=(SELECT TT.[ID] FROM @tblTemp TT,dbo.T_Hierarchy_Details HD WHERE TT.iHDid=HD.I_Hierarchy_Detail_ID
		AND HD.I_Hierarchy_Level_Id=@iCtryLevelId AND HD.I_Status<>0)

		
		
		--Select truncated hierarchy chain
		
		SELECT iHDid AS HierarchyDetailID FROM @tblTemp WHERE [ID] BETWEEN 1 AND @iIDPos
		SET @iIDPos=@iIDPos+1  
		SELECT iHLid AS ChildLevelID FROM @tblTemp WHERE [ID]=@iIDPos  
	
END
