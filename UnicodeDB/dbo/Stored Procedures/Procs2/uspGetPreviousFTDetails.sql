/**************************************************************************************************************
Created by  : Swagata De
Date		: 09.04.2007
Description : This SP will retrieve details of previous FTs based on serach criteria provided
Parameters  : CenterId
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetPreviousFTDetails]
	(
		@dtFromDate DATETIME,
		@dtToDate DATETIME,
		@dtCurrentDate DATETIME,
		@iHierarchyDetailID INT,
		@iBrandID INT,
		@nLessThanCollnAmt numeric(18,2),
		@nGreaterThanCollnAmt numeric(18,2) 
		
	)

AS

BEGIN 
	
	SET NOCOUNT ON;
	DECLARE @sSearchCriteria varchar(max)
	
	CREATE TABLE #TempCenter 
	( 
		I_Center_ID int
	)
	
	CREATE TABLE #TempFundTransfer 
	( 
		I_FundTransfer_ID int
	)
	

	SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iHierarchyDetailID  
	
	IF @iBrandID =0 
		BEGIN 
			INSERT INTO #TempCenter 
			SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE 
			TCHD.I_Hierarchy_Detail_ID IN 
			(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE I_Status = 1
			AND @dtCurrentDate >= ISNULL(Dt_Valid_From,@dtCurrentDate)
			AND @dtCurrentDate <= ISNULL(Dt_Valid_To,@dtCurrentDate)
			AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') 
		END
  ELSE
		BEGIN
			INSERT INTO #TempCenter 
			SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WHERE
			TCHD.I_Hierarchy_Detail_ID IN 
		   (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details 
			WHERE I_Status = 1
			AND @dtCurrentDate >= ISNULL(Dt_Valid_From,@dtCurrentDate)
			AND @dtCurrentDate <= ISNULL(Dt_Valid_To,@dtCurrentDate)
			AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND
			TBCD.I_Brand_ID=@iBrandID AND
			TBCD.I_Centre_Id = TCHD.I_Center_Id 			 
		END
		
		INSERT INTO #TempFundTransfer
		SELECT TFTH.I_Fund_Transfer_Header_ID FROM dbo.T_Fund_Transfer_Header TFTH
		WHERE  TFTH.I_Centre_Id IN (SELECT I_Center_ID FROM #TempCenter)
		AND DATEDIFF(dd, @dtFromDate,TFTH.Dt_Fund_Transfer_Date) >= 0 AND DATEDIFF(dd, @dtToDate,TFTH.Dt_Fund_Transfer_Date ) <= 0
		--AND TFTH.Dt_Fund_Transfer_Date BETWEEN  @dtFromDate AND @dtToDate 
		AND TFTH.N_Total_Receivable BETWEEN ISNULL(@nLessThanCollnAmt,0.00) AND ISNULL(@nGreaterThanCollnAmt,10000000000000.00)
		
		--Fund transfer details
		SELECT TFTH.I_Fund_Transfer_Header_ID,TFTH.I_Centre_Id,TFTH.Dt_Fund_Transfer_Date,TFTH.N_CourseFees,
		TFTH.N_Other_Collections,TFTH.N_Total_Collection,TFTH.N_RFF_Company,TFTH.N_Total_Receivable,TFTH.N_Total_Share_Center,
		TCM.S_Center_Code,TCM.S_Center_Name,COU.I_Currency_ID
		FROM dbo.T_Fund_Transfer_Header TFTH 
		INNER JOIN dbo.T_Centre_Master TCM
		ON TFTH.I_Centre_Id=TCM.I_Centre_Id
		INNER JOIN dbo.T_Country_Master COU
		ON TCM.I_Country_ID = COU.I_Country_ID
		WHERE  TFTH.I_Fund_Transfer_Header_ID IN (SELECT I_FundTransfer_ID FROM #TempFundTransfer)
		--Fee Component related details
		
		SELECT I_Fund_Transfer_Header_ID, I_Fee_Component_ID,N_Total_Amount
		FROM dbo.T_FT_Fee_Component_Details
		WHERE I_Fund_Transfer_Header_ID IN (SELECT I_FundTransfer_ID FROM #TempFundTransfer)
		AND N_CompanyShare=100.0000
		--Tax related details
		
		SELECT I_Fund_Transfer_Header_ID,I_Tax_ID,N_Tax_Amount_Company,N_Tax_Amount_BP
		FROM dbo.T_FT_Tax_Detail
		WHERE I_Fund_Transfer_Header_ID IN (SELECT I_FundTransfer_ID FROM #TempFundTransfer)
		
		DROP TABLE #TempCenter
		DROP TABLE #TempFundTransfer

		
END
