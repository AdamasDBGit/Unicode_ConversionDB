CREATE PROCEDURE [dbo].[uspGetCenterDiscountSchemes]
	(
		@iHierarchyDetailID int,
		@iBrandID int = null
	)

AS
BEGIN TRY
	SET NOCOUNT ON
	
	DECLARE @sSearchCriteria varchar(max)
	DECLARE @iMax int
	DECLARE @iCount int
	
	SELECT @sSearchCriteria= S_Hierarchy_Chain 
	FROM T_Hierarchy_Mapping_Details 
	WHERE I_Hierarchy_detail_id = @iHierarchyDetailID  
		
	CREATE TABLE #tempCenter
	(
		seq int identity(1,1),
		centerID int,
		centerCode varchar(20),
		centerName varchar(100)
	)

	CREATE TABLE #tempDiscountScheme
	(
		centerDiscountSchemeID int,
		centerID int,
		discountSchemeName varchar(250)
	)	
	
	SET @iMax = 0
	SET @iCount = 1
	
	IF @iBrandID = 0 
		BEGIN
			INSERT INTO #tempCenter(centerID, centerCode, centerName)
			SELECT TCHD.I_Center_Id, CM.S_Center_Code, CM.S_Center_Name
			FROM T_CENTER_HIERARCHY_DETAILS TCHD WITH(NOLOCK)
			INNER JOIN dbo.T_Centre_Master CM
			ON CM.I_Centre_Id = TCHD.I_Center_Id
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
			(	SELECT I_HIERARCHY_DETAIL_ID 
				FROM T_Hierarchy_Mapping_Details 
				WHERE S_Hierarchy_Chain LIKE @sSearchCriteria + '%'
				AND I_Status = 1
				AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
				AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
			)
			AND TCHD.I_Status = 1
			AND CM.I_Status = 1
			AND GETDATE() >= ISNULL(TCHD.Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(TCHD.Dt_Valid_To, GETDATE())
		END
	ELSE
		BEGIN
			INSERT INTO #tempCenter(centerID, centerCode, centerName)
			SELECT TCHD.I_Center_Id, CM.S_Center_Code, CM.S_Center_Name
			FROM T_CENTER_HIERARCHY_DETAILS TCHD WITH(NOLOCK)
			INNER JOIN T_BRAND_CENTER_DETAILS TBCD
			ON TBCD.I_Centre_Id = TCHD.I_Center_Id
			INNER JOIN dbo.T_Centre_Master CM
			ON CM.I_Centre_Id = TCHD.I_Center_Id  
			WHERE TCHD.I_Hierarchy_Detail_ID IN 
		    (	SELECT I_HIERARCHY_DETAIL_ID 
				FROM T_Hierarchy_Mapping_Details 
				WHERE S_Hierarchy_Chain 
				LIKE @sSearchCriteria + '%'
				AND I_Status = 1
				AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
				AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())
			) 
			AND TBCD.I_Status = 1 
			AND TCHD.I_Status = 1
			AND CM.I_Status = 1
			AND TBCD.I_Brand_ID = @iBrandID
			AND GETDATE() >= ISNULL(TCHD.Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(TCHD.Dt_Valid_To, GETDATE())
			AND GETDATE() >= ISNULL(TBCD.Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(TBCD.Dt_Valid_To, GETDATE())
		END
			
	SELECT @iMax = MAX(seq) FROM #tempCenter

	SELECT centerID, centerCode, centerName FROM #tempCenter
		
	WHILE ( @iCount <= @iMax )
	BEGIN
		INSERT INTO #tempDiscountScheme
		SELECT DISTINCT	DCD.I_Discount_Center_Detail_ID,
				DCD.I_Centre_ID,
				DSM.S_Discount_Scheme_Name
		FROM dbo.T_Discount_Center_Detail DCD WITH(NOLOCK)
		INNER JOIN dbo.T_Discount_Scheme_Master	DSM
		ON DCD.I_Discount_Scheme_ID = DSM.I_Discount_Scheme_ID
		INNER JOIN #tempCenter TEMP1
		ON DCD.I_Centre_ID = TEMP1.centerID
		INNER JOIN dbo.T_Discount_Details TDD
		ON DSM.I_Discount_Scheme_ID = TDD.I_Discount_Scheme_ID
		INNER JOIN dbo.T_CourseList_Master TCM
		ON TDD.I_CourseList_ID = TCM.I_CourseList_ID
		WHERE DCD.I_Status = 1
		AND DSM.I_Status = 1
		AND TCM.I_Brand_ID = @iBrandID
		AND GETDATE() >= ISNULL(DSM.Dt_Valid_From, GETDATE())
		AND GETDATE() <= ISNULL(DSM.Dt_Valid_To, GETDATE())
		AND TEMP1.seq = @iCount

		SET @iCount = @iCount + 1
	END

	SELECT centerDiscountSchemeID,
		centerID,
		discountSchemeName 
	FROM #tempDiscountScheme

	DROP TABLE #tempCenter
	DROP TABLE #tempDiscountScheme

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
