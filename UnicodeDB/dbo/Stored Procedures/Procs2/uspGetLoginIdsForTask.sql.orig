CREATE PROCEDURE [dbo].[uspGetLoginIdsForTask] 
(
	@sLoginID varchar(200),
	@iHierarchyMasterID int,	
	@sHierarchyInstanceName varchar(100)
	
)

AS
SET NOCOUNT OFF
BEGIN 
	DECLARE
	
	@iUserID int,
	@iHDId int,
	@iHierarchydetailId int,
	@iHierarchyLevelID int,
	@sHierarchyChain varchar(500),
	@iRowCount int,
	@iRow int,
	@iPos int,
	@iVal int
	
	DECLARE @tblTemp TABLE
	(	
		[ID] int identity(1,1),
		iHDid int,
		iHLid int,
		iUserid int,
		sEmailid varchar(20)
   ) 
   
	SELECT @iUserID = I_User_ID 
	FROM dbo.T_User_Master 
	WHERE S_Login_ID = @sLoginID

	--SELECT @iUserID

	SELECT @iHDId = I_Hierarchy_Detail_ID
	FROM dbo.T_Hierarchy_Details
	WHERE S_Hierarchy_Name = @sHierarchyInstanceName
	AND I_Hierarchy_Master_ID = @iHierarchyMasterID
	AND I_Status <> 0

	--SELECT @iHierarchyLevelID
   
	SELECT @iHierarchydetailId = I_Hierarchy_Detail_ID 
	FROM dbo.T_User_Hierarchy_Details 
	WHERE I_User_ID = @iUserID
	AND I_Hierarchy_Master_ID = @iHierarchyMasterID
	AND I_Status <> 0
	AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
	
	--SELECT @iHierarchydetailId	
   
   --get all hierarchy detail ids corresponding to the given level (say CH)
	SET  @iRowCount = (SELECT COUNT(I_User_Hierarchy_Detail_ID) FROM dbo.T_User_Hierarchy_Details
	WHERE I_Hierarchy_Detail_ID = @iHDId
	AND I_Hierarchy_Master_ID = @iHierarchyMasterID
	AND I_Status <> 0 
	AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE()))

	--SELECT @iRowCount

	IF(@iRowCount=0)
		RETURN 

	IF(@iRowCount = 1)
	BEGIN
		SELECT S_Email_ID as S_Email_ID 
		FROM dbo.T_User_Master UM
		INNER JOIN dbo.T_User_Hierarchy_Details UH
		ON UM.I_User_ID = UH.I_User_ID 
		WHERE UM.I_STATUS <> 0
		AND UH.I_STATUS <> 0 
		AND UH.I_Hierarchy_Detail_ID = @iHDId 
	
		RETURN 
	END 

	ELSE
	BEGIN
		
		SELECT @sHierarchyChain = A.S_Hierarchy_Chain
		FROM dbo.T_Hierarchy_Mapping_Details A 
		WHERE A.I_Status = 1 
		AND  GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE()) 
		AND A.I_Hierarchy_Detail_ID = @iHierarchydetailId

		--SELECT @sHierarchyChain AS HierarchyChain
		
		INSERT INTO @tblTemp(iHDid) VALUES (@iHierarchydetailId)
		
		INSERT INTO @tblTemp(iHDid)
		SELECT A.I_Hierarchy_Detail_ID
		FROM dbo.T_Hierarchy_Mapping_Details A 
		WHERE A.I_Status = 1 
		AND  GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
		AND A.S_Hierarchy_Chain LIKE @sHierarchyChain + ',%'
		
		WHILE(@sHierarchyChain <> '')
		BEGIN
			 SET @iPos=(SELECT charindex(',',@sHierarchyChain))
			 SET @sHierarchyChain = LTRIM(RTRIM(@sHierarchyChain))

			IF(@iPos<>0)-----Check to see if comma is present----
			BEGIN

					WHILE(@iPos>0)
					BEGIN
							SET @iVal=@iPos
							SET @iPos=(SELECT charindex(',',@sHierarchyChain,@iVal+1))
					END

					SET @sHierarchyChain = LTRIM(RTRIM(LEFT(@sHierarchyChain, @iVal - 1)))--get the new hierarchy chain
			END
			
			ELSE
					BREAK

			INSERT INTO @tblTemp(iHDid)
			SELECT A.I_Hierarchy_Detail_ID
			FROM dbo.T_Hierarchy_Mapping_Details A 
			WHERE A.I_Status=1 AND  GETDATE() >= ISNULL(GETDATE(),A.Dt_Valid_From)
			AND GETDATE() <= ISNULL(GETDATE(),A.Dt_Valid_To)
			AND A.S_Hierarchy_Chain LIKE @sHierarchyChain 
	 END

	 SET @iRowCount=(SELECT COUNT(*) FROM @tblTemp)
	 SET @iRow=1

	 WHILE(@iRow<=@iRowCount)
	 BEGIN
			DECLARE
			@HDetailid int

			SET @HDetailid=(SELECT iHDid FROM @tblTemp WHERE [ID]=@iRow)

		

			UPDATE @tblTemp
			SET iHLid= (SELECT A.I_Hierarchy_Level_ID FROM dbo.T_Hierarchy_Details A ,@tblTemp TT
			WHERE A.I_Hierarchy_Detail_ID=TT.iHDid AND TT.iHDid=@HDetailid)
			WHERE [ID]=@iRow

			UPDATE @tblTemp
			SET iUserid= (SELECT A.I_User_ID FROM dbo.T_User_Hierarchy_Details A ,@tblTemp TT
			WHERE A.I_Hierarchy_Detail_ID=TT.iHDid AND TT.iHDid=@HDetailid)
			WHERE [ID]=@iRow

			UPDATE @tblTemp
			SET sEmailid= (SELECT A.S_Email_ID FROM dbo.T_User_Master A ,@tblTemp TT
			WHERE A.I_User_ID=TT.iUserid AND TT.iHDid=@HDetailid)
			WHERE [ID]=@iRow

			SET @iRow=@iRow+1
	END

  --SELECT * FROM @tblTemp


	SET @iRowCount=(SELECT COUNT(sEmailid) FROM @tblTemp WHERE iHLid=@iHierarchyLevelID)
	--check condition---
	IF(@iRowCount=0)
	BEGIN
		SELECT C.S_Email_ID AS S_Email_ID FROM dbo.T_User_Hierarchy_Details A ,
		(SELECT I_Hierarchy_Detail_ID FROM dbo.T_Hierarchy_Details	WHERE I_Hierarchy_Level_ID=@iHierarchyLevelID AND I_Hierarchy_Master_ID=@iHierarchyMasterID AND I_Status<>0) B,
		dbo.T_User_Master C
		WHERE A.I_Hierarchy_Detail_ID=B.I_Hierarchy_Detail_ID AND A.I_User_ID=C.I_User_ID AND C.I_Status<>0
	END
	ELSE
	BEGIN
		SELECT sEmailid AS S_Email_ID FROM @tblTemp WHERE iHLid=@iHierarchyLevelID
	END
	

	END

END
