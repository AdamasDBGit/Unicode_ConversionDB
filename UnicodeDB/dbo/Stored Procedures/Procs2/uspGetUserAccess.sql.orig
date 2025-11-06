
CREATE PROCEDURE [dbo].[uspGetUserAccess]
(
	@vLoginID varchar(200)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @iUserID int
	DECLARE @vUserType varchar(20)
	DECLARE @iTotalRowCount int
	DECLARE @iRow int

	--Fetching the UserID from the T_User_Master table
	SELECT @iUserID = I_USER_ID, @vUserType = S_User_Type
	FROM dbo.T_User_Master
	WHERE S_Login_ID = @vLoginID
	
	--Table[0]
	--Fetching basic informations
	SELECT	I_User_ID as UserID, 
			S_Title as Title, 
			S_First_Name as FirstName, 
			S_Middle_Name as MiddleName, 
			S_Last_Name as LastName,
			S_User_Type as UserType, 
			I_Reference_ID as ReferenceID,
			S_Email_ID as EmailID, 
			S_Forget_Pwd_Qtn as ForgetPwdQs, 
			S_Forget_Pwd_Answer as ForgetPwdAns,
			S_Password as [Password]
		FROM dbo.T_User_Master   		
		WHERE I_USER_ID = @iUserID

	--Table[1]
	--Fetching the list of Transaction ID applicable for all the Roles for the User
	SELECT DISTINCT A.I_Transaction_ID TransactionID, C.S_Transaction_Code TransactionCode
	FROM dbo.T_Role_Transaction A 
	INNER JOIN dbo.T_User_Role_Details B
	ON A.I_Role_ID = B.I_Role_ID
	INNER JOIN dbo.T_Transaction_Master C
	ON A.I_Transaction_ID = C.I_Transaction_ID    
	WHERE B.I_User_ID = @iUserID
	AND B.I_Status = 1
	AND A.I_Status = 1

	--Fetching the Hierarchy details for the user

	--Creating a Temporary Table for User Hierarchy Details
	CREATE TABLE #tempUserHierarchy
	(
		seq int identity(1,1),
		HierarchyDetailsID int not null,
		HierarchyName varchar(MAX),
		SalesOrgID int not null,
		SalesOrgCode varchar(20),
		SalesOrgName varchar(200),
		SalesOrgType varchar(20),
		HierarchyChain varchar(100),
		SalesOrgChain varchar(100),
		ChildLevelID int,
		LevelSequence int,
		LastLevelID int
	)

	INSERT INTO #tempUserHierarchy
	(	HierarchyDetailsID,
		HierarchyName, 
		SalesOrgID, 
		SalesOrgCode, 
		SalesOrgName, 
		SalesOrgType,
		LevelSequence	) 
	SELECT	C.I_Hierarchy_Detail_ID,
			A.S_Hierarchy_Name, 
			C.I_Hierarchy_Master_ID, 
			B.S_Hierarchy_Code, 
			B.S_Hierarchy_Desc, 
			B.S_Hierarchy_Type,
			D.I_Sequence
	FROM dbo.T_Hierarchy_Details A, 
	dbo.T_Hierarchy_Master B, 
	dbo.T_User_Hierarchy_Details C,
	dbo.T_Hierarchy_Level_Master D
	WHERE C.I_User_ID = @iUserID
	AND C.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
	AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
	AND A.I_Hierarchy_Level_ID = D.I_Hierarchy_Level_ID
	AND GETDATE() >= ISNULL(GETDATE(), C.Dt_Valid_From)
	AND GETDATE() <= ISNULL(GETDATE(), C.Dt_Valid_To) 
	AND C.I_Status = 1
	AND A.I_Status = 1
	AND B.I_Status = 1
	
	SET @iTotalRowCount = (SELECT MAX(seq) FROM #tempUserHierarchy)
	SET @iRow = 1
	
	--Creating a temp Table
	CREATE TABLE #tempTable
	(
		seq1 int identity(1,1),
		lenwithseparator int,
		lenwithoutseparator int,
		noofseparator int,
		hierarchychain varchar(100)
	)
		
	WHILE(@iRow <= @iTotalRowCount)
	BEGIN
		--Fetching the Sales Organization Chain Value
		
		--Deleting the  a temp Table
		TRUNCATE TABLE #tempTable
		
		--Adding the Hierarchy Chain
		UPDATE #tempUserHierarchy
		SET HierarchyChain = ( 
		SELECT TOP 1 A.S_Hierarchy_Chain
		FROM dbo.T_Hierarchy_Mapping_Details A, #tempUserHierarchy B
		WHERE A.I_Hierarchy_Detail_ID = B.HierarchyDetailsID
		AND B.seq = @iRow
		AND A.I_Status = 1
		AND GETDATE() >= ISNULL(GETDATE(),A.Dt_Valid_From)
		AND GETDATE() <= ISNULL(GETDATE(),A.Dt_Valid_To) 
		)
		WHERE seq = @iRow
		

		INSERT INTO #tempTable
		(	lenwithseparator, 
			lenwithoutseparator, 
			noofseparator, 
			hierarchychain	)
		SELECT	LEN(B.S_Hierarchy_Level_Chain), 
				LEN(REPLACE(B.S_Hierarchy_Level_Chain,',','')), 
				LEN(B.S_Hierarchy_Level_Chain) - LEN(REPLACE(B.S_Hierarchy_Level_Chain,',','')), 
				B.S_Hierarchy_Level_Chain
		FROM #tempUserHierarchy A, 
		dbo.T_Hierarchy_Mapping_Details B
		WHERE A.seq = @iRow
		AND B.I_Status = 1
		AND B.I_Hierarchy_Detail_ID IN 
		(	SELECT C.I_Hierarchy_Detail_ID
			FROM dbo.T_Hierarchy_Details C, #tempUserHierarchy D
			WHERE C.I_Hierarchy_Master_ID = D.SalesOrgID
			AND D.seq = @iRow	)	

		--Setting the Sales Organization Level Chain
		UPDATE #tempUserHierarchy
		SET SalesOrgChain = ( SELECT TOP 1 hierarchychain
		FROM #tempTable
		WHERE noofseparator = ( SELECT MAX(noofseparator) 
		FROM #tempTable) )
		WHERE seq = @iRow
		
		--Setting the Child Level ID
		UPDATE #tempUserHierarchy
		SET ChildLevelID = ( SELECT TOP 1 C.I_Hierarchy_Level_ID
		FROM dbo.T_Hierarchy_Mapping_Details A, #tempUserHierarchy B, dbo.T_Hierarchy_Details C
		WHERE A.I_Parent_ID = B.HierarchyDetailsID
		AND A.I_Hierarchy_Detail_ID=C.I_Hierarchy_Detail_ID
		AND A.I_Status = 1
		AND B.seq = @iRow )
		WHERE seq = @iRow
		
		--Setting the Last Level ID
		UPDATE #tempUserHierarchy
		SET LastLevelID = (	SELECT I_Hierarchy_Level_Id
		FROM dbo.T_Hierarchy_Level_Master A, #tempUserHierarchy B
		WHERE A.I_Hierarchy_Master_ID = B.SalesOrgID
		AND A.I_Is_Last_Node = 1
		AND A.I_Status = 1
		AND B.seq = @iRow )
		WHERE seq = @iRow
		 
		SET @iRow = @iRow + 1
	END
	
	--Drop temp Table
	DROP TABLE #tempTable
	
	--Table[2]
	--Selecting the user Hierarchy information
	SELECT HierarchyDetailsID,
		HierarchyName,
		SalesOrgID,
		SalesOrgCode,
		SalesOrgName,
		SalesOrgType,
		HierarchyChain,
		SalesOrgChain,
		ChildLevelID,
		LevelSequence,
		LastLevelID
		FROM #tempUserHierarchy
		order by SalesOrgID

	--Droping the Dummy Table
	DROP TABLE #tempUserHierarchy

	--Table[3]
	--Selecting the user Role Hierarchy 
	SELECT	A.I_Hierarchy_Detail_ID as TrustDomainID, 
			C.S_Hierarchy_Name as TrustDomainName
	FROM dbo.T_User_Hierarchy_Details A, 
	dbo.T_Hierarchy_Master B, 
	dbo.T_Hierarchy_Details C
	WHERE A.I_User_ID = @iUserID
	AND A.I_Hierarchy_Master_ID = B.I_Hierarchy_Master_ID
	AND B.S_Hierarchy_Type = 'RH'
	AND A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND C.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	
	
	--Table[4]
	--Selecting the user roles and Role Hierarchy
	SELECT * from dbo.T_Role_Master trm,
				  dbo.T_User_Role_Details urd
	WHERE trm.I_Role_ID = urd.I_Role_ID
	AND urd.I_User_ID = @iUserID
	AND trm.I_Status = 1
	AND urd.I_Status = 1
END
