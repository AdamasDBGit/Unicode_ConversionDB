CREATE PROCEDURE [dbo].[uspGetCenterForFundTransfer]
	(
		@iSelectedHierarchyId int,
		@iSelectedBrandId int,
		@dtDateTo datetime,
		@dtDateFrom datetime
	)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @sSearchCriteria varchar(max)
	
	CREATE TABLE #TempCenter 
	( 
		I_Center_ID int
	)

	SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId  
	
	IF @iSelectedBrandId =0 
		BEGIN
			INSERT INTO #TempCenter 
			SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
			TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE I_Status = 1
			AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
			AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') 
		END
	ELSE
		BEGIN
			INSERT INTO #TempCenter 
			SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WHERE
			TCHD.I_Hierarchy_Detail_ID IN 
		   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE I_Status = 1
			AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
			AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
			AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
			TBCD.I_Brand_ID=@iSelectedBrandId AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id 			 
		END


	CREATE TABLE #TempTable
	( 
		ID INT IDENTITY(1,1),
		Amount Numeric(18,2),
		TaxAmount Numeric(18,2),
		Receipt INT,
		S_Center_Code varchar(20),
		S_Center_Name varchar(50),
		I_Centre_Id int,
		S_Brand_Name varchar(50),
		I_Currency_ID int
	)

	INSERT INTO #TempTable
	SELECT SUM(RH.N_Receipt_Amount) AS Amount,SUM(RH.N_Tax_Amount) AS TaxAmount,COUNT(*) AS Receipt,
	CM.S_Center_Code,CM.S_Center_Name,CM.I_Centre_Id,BM.S_Brand_Name,
	COU.I_Currency_ID
	FROM dbo.T_Receipt_Header RH
	INNER JOIN dbo.T_Centre_Master CM		
	ON RH.I_Centre_Id = CM.I_Centre_Id
	LEFT OUTER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = CM.I_Centre_Id
	INNER JOIN dbo.T_Brand_Master BM
	ON BM.I_Brand_ID = BCD.I_Brand_ID
	INNER JOIN dbo.T_Country_Master COU
	ON CM.I_Country_ID = COU.I_Country_ID
	WHERE RH.I_Centre_Id in (SELECT I_Center_ID FROM #TempCenter) 
	AND RH.Dt_Receipt_Date < ISNULL(@dtDateTo, RH.Dt_Receipt_Date)	--as 1 day is added from front end
	AND RH.Dt_Receipt_Date >= ISNULL(@dtDateFrom, RH.Dt_Receipt_Date)
	AND RH.S_Fund_Transfer_Status = 'N'
	AND CM.I_Status = 1
	AND BM.I_Status = 1
	AND BCD.I_Status = 1
	AND RH.I_Status <> 0
	GROUP BY CM.S_Center_Code,CM.S_Center_Name,CM.I_Centre_Id,BM.S_Brand_Name,
	COU.I_Currency_ID

	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @iCenterID INT
	DECLARE @Amount numeric(18,2)
	DECLARE @TAmount numeric(18,2)
	DECLARE @rCount int
	SELECT @iRowCount = count(ID) FROM #TempTable
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @iCenterID = I_Centre_Id FROM #TempTable 
		WHERE ID = @iCount
		
		SELECT @Amount = SUM(RH.N_Receipt_Amount),@TAmount = SUM(RH.N_Tax_Amount),@rCount = COUNT(*)	
		FROM dbo.T_Receipt_Header RH		 		
		WHERE RH.S_Fund_Transfer_Status = 'Y'		
		AND RH.I_Status = 0
		AND RH.I_Centre_Id = @iCenterID
		--AND (ISNULL((select I_status from t_invoice_parent where i_invoice_header_id = RH.I_Invoice_Header_ID),1)<>0)

		UPDATE #TempTable	
		SET Amount = Amount - ISNULL(@Amount,0),
			TaxAmount = TaxAmount - ISNULL(@TAmount,0),
		    Receipt = Receipt + ISNULL(@rCount,0)
		WHERE ID = @iCount
		
		SET @iCount = @iCount + 1
	END
	
	SELECT * FROM #TempTable
	DROP TABLE #TempTable

END
