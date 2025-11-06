--EXEC [REPORT].[uspGetOutstandingStatementReport] '104',22,'29-Aug-2008'
CREATE PROCEDURE [REPORT].[uspGetOutstandingStatementSummaryForGraph]
(
	-- Add the parameters for the stored procedure here
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@sCenterIDs VARCHAR(MAX),
	@dtUptoDate datetime,
	@sStatus Varchar(100)
)
AS
BEGIN TRY

	SET NOCOUNT ON;

	Declare @StudentStatus Int

	If (@sStatus='ALL')
		Begin
			Set @StudentStatus=NULL
		End	
	Else If(@sStatus='Active')
		Begin
			Set @StudentStatus=1
		End
	Else If(@sStatus='Dropped Out')
		Begin
			Set @StudentStatus=0
		End
	
	DECLARE @index INT, @rowCount INT, @iTempCenterID INT
	DECLARE @tblCenter TABLE(ID INT IDENTITY(1,1), CenterId INT)

	DECLARE @iHierarchDetailID INT, @sHierarchyChain VARCHAR(100)
	DECLARE @CenterName VARCHAR(100), @BrandID INT, @BrandName VARCHAR(100), @RegionID INT, 
		@RegionName VARCHAR(100), @TerritoryID INT, @TerritoryName VARCHAR(100), @CityID INT, @CityName VARCHAR(100)
		
	DECLARE @tblTempHierarchy TABLE (ID INT)

	INSERT INTO @tblCenter
	SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCenterIDs, ',') AS FSR
	
	IF ((SELECT COUNT(ID) FROM @tblCenter) = 0)
	BEGIN
		INSERT INTO @tblCenter
		SELECT [I_Center_ID] FROM [dbo].[fnGetCenterIDFromHierarchy](@sHierarchyList, @iBrandID) AS FGCIFH
	END
	
	 SELECT IP.I_Invoice_Header_ID,
			IP.I_Centre_Id,
			IP.I_Student_Detail_ID,
			SD.S_Student_ID,
			SD.S_Title,
			SD.S_First_Name,
			SD.S_Middle_Name,
			SD.S_Last_Name,
			IP.S_Invoice_No AS Invoice_No,
			IP.Dt_Invoice_Date AS Invoice_Date,
			ISNULL(IP.N_Invoice_Amount,0.00) AS Invoice_Amount,
			ISNULL(IP.N_Tax_Amount,0.00) AS Tax_Amount,
			ISNULL(IP.N_Discount_Amount,0.00) AS N_Discount_Amount,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code,
			--SUM(ISNULL(RH.N_Receipt_Amount,0.00)) AS Receipt_Amount,
			(Select SUM(ISNULL(N_Receipt_Amount,0.00)) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=IP.I_Invoice_Header_ID AND I_Status <> 0)  AS Receipt_Amount,
			(ISNULL(IP.N_Invoice_Amount,0.00) 
			--- SUM(ISNULL(RH.N_Receipt_Amount,0.00))) AS Outstanding_Amt,
			-(Select ISNULL(SUM(ISNULL(N_Receipt_Amount,0.00)),0) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=IP.I_Invoice_Header_ID AND I_Status <> 0)) AS Outstanding_Amt,
			--MAX(RH.Dt_Receipt_Date) AS Last_Install_Date
			(Select MAX(Dt_Receipt_Date) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=IP.I_Invoice_Header_ID AND I_Status <> 0)  AS Last_Install_Date
	   INTO #TmpOutStandingRpt1
	   FROM dbo.T_Student_Detail SD WITH(NOLOCK)
			INNER JOIN dbo.T_Invoice_Parent IP WITH(NOLOCK)
		    ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
			ON IP.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
			ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
			LEFT OUTER JOIN dbo.T_Receipt_Header RH WITH(NOLOCK)
			ON IP.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
			INNER JOIN dbo.T_Centre_Master CEM WITH(NOLOCK)
			ON FN1.CenterID=CEM.I_Centre_Id
			INNER JOIN dbo.T_Country_Master COM WITH(NOLOCK)
			ON CEM.I_Country_ID=COM.I_Country_ID
			INNER JOIN dbo.T_Currency_Master CUM WITH(NOLOCK)
			ON COM.I_Currency_ID=CUM.I_Currency_ID
		WHERE CAST(SUBSTRING(CAST(IP.Dt_Invoice_Date AS VARCHAR),1,11) as datetime)<= @dtUptoDate
		AND (CAST(SUBSTRING(CAST(RH.Dt_Receipt_Date AS VARCHAR),1,11) as datetime) <= @dtUptoDate OR RH.Dt_Receipt_Date IS NULL)
		AND IP.I_STATUS <> 0
		AND SD.I_STATUS= ISNULL(@StudentStatus,SD.I_STATUS)
		AND [SD].[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM)
		--AND RH.I_Status <> 0
		GROUP BY IP.I_Invoice_Header_ID,
			IP.I_Centre_Id,
			IP.I_Student_Detail_ID,
			SD.S_Student_ID,
			SD.S_Title,
			SD.S_First_Name,
			SD.S_Middle_Name,
			SD.S_Last_Name,
			IP.S_Invoice_No,
			IP.Dt_Invoice_Date,
			IP.N_Invoice_Amount,
			IP.N_Tax_Amount,
			IP.N_Discount_Amount,
			FN1.CenterCode,
			FN1.CenterName,
			FN2.InstanceChain,
			CUM.S_Currency_Code
				
		 SELECT TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--ICH.I_Course_ID,
				ICH.I_Invoice_Child_Header_ID,
				--CM.S_Course_Code AS Course_Code,
				--CM.S_Course_Name AS Course_Name,
				--SUM(ISNULL(RH.N_Receipt_Amount,0.00)) AS Last_Install_Amount,
				(Select SUM(ISNULL(N_Receipt_Amount,0.00)) FROM dbo.T_Receipt_Header WHERE I_Invoice_Header_ID=TMP.I_Invoice_Header_ID AND I_Status <> 0 AND Dt_Receipt_Date=TMP.Last_Install_Date)  AS Last_Install_Amount,
				[REPORT].[fnGetStudentStatusForReports](TMP.I_Student_Detail_ID,TMP.I_Centre_Id,@dtUptoDate) AS Student_Status
		   INTO #TmpOutStandingRpt2
		   FROM #TmpOutStandingRpt1 TMP
				INNER JOIN dbo.T_Invoice_Child_Header ICH WITH(NOLOCK)
				ON TMP.I_Invoice_Header_ID=ICH.I_Invoice_Header_ID
				--INNER JOIN dbo.T_Course_Master CM WITH(NOLOCK)
				--ON ICH.I_Course_ID=CM.I_Course_ID		
				LEFT OUTER JOIN dbo.T_Receipt_Header RH WITH(NOLOCK)
				ON TMP.I_Invoice_Header_ID=RH.I_Invoice_Header_ID
				AND TMP.Last_Install_Date=RH.Dt_Receipt_Date 
		  --WHERE [REPORT].[fnGetStudentStatusForReports](TMP.I_Student_Detail_ID,TMP.I_Centre_Id,@dtUptoDate)='Active'
		  --AND TMP.Outstanding_Amt>10
			WHERE TMP.Outstanding_Amt > 10
			--AND RH.I_Status <> 0
			GROUP BY TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--ICH.I_Course_ID,
				ICH.I_Invoice_Child_Header_ID--,
				--CM.S_Course_Code,
				--CM.S_Course_Name

		--Finding Last Date of the Month
		DECLARE @vOutputDate DATETIME
		SET @vOutputDate = CAST(YEAR(@dtUptoDate) AS VARCHAR(4)) + '/' + CAST(MONTH(@dtUptoDate) AS VARCHAR(2)) + '/01'
		SET @vOutputDate = DATEADD(DD, -1, DATEADD(M, 1, @vOutputDate))

		SELECT TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status,
				SUM(ISNULL(ICD.N_Amount_Due,0.00)) AS Amount_Due_LM
		INTO #TmpOutStandingRpt3
		FROM #TmpOutStandingRpt2 TMP
				INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH(NOLOCK)
				ON TMP.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
				--AND DATEPART(month,ICD.Dt_Installment_Date) <= DATEPART(month, @dtUptoDate)
				--AND DATEPART(year,ICD.Dt_Installment_Date) <= DATEPART(year, @dtUptoDate)
				AND ICD.Dt_Installment_Date <=  @vOutputDate
		GROUP BY TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status

		--Finding Last Date of the Nes=xt Month
		SET @dtUptoDate=DATEADD(month,1,@dtUptoDate)
		DECLARE @vOutputDate1 DATETIME
		SET @vOutputDate1 = CAST(YEAR(@dtUptoDate) AS VARCHAR(4)) + '/' + CAST(MONTH(@dtUptoDate) AS VARCHAR(2)) + '/01'
		SET @vOutputDate1= DATEADD(DD, -1, DATEADD(M, 1, @vOutputDate1))

	SELECT TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status,
				SUM(ISNULL(ICD.N_Amount_Due,0.00)) AS Amount_Due_CM
		INTO #TmpOutStandingRpt4
		FROM #TmpOutStandingRpt2 TMP
				INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH(NOLOCK)
				ON TMP.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
				--AND DATEPART(month,ICD.Dt_Installment_Date) <= DATEPART(month, (DATEADD(month,1,@dtUptoDate)))
				--AND DATEPART(year,ICD.Dt_Installment_Date) <= DATEPART(year, @dtUptoDate)
				AND ICD.Dt_Installment_Date <= @vOutputDate1
		GROUP BY TMP.I_Invoice_Header_ID,
				TMP.I_Centre_Id,
				TMP.I_Student_Detail_ID,
				TMP.S_Student_ID,
				TMP.S_Title,
				TMP.S_First_Name,
				TMP.S_Middle_Name,
				TMP.S_Last_Name,
				TMP.Invoice_No,
				TMP.Invoice_Date,
				TMP.Invoice_Amount,
				TMP.Tax_Amount,
				TMP.N_Discount_Amount,
				TMP.CenterCode,
				TMP.CenterName,
				TMP.InstanceChain,
				TMP.S_Currency_Code,
				TMP.Receipt_Amount,
				TMP.Outstanding_Amt,
				TMP.Last_Install_Date,
				--TMP.I_Course_ID,
				--TMP.Course_Code,
				--TMP.Course_Name,
				TMP.Last_Install_Amount,
				TMP.Student_Status

	SELECT		DISTINCT
				HRKY.I_Brand_ID AS BrandID,
				HRKY.S_Brand_Name AS BrandName,
				HRKY.I_Region_ID AS RegionID,
				HRKY.S_Region_Name AS RegionName,
				HRKY.I_Territory_ID AS TerritoryID,
				HRKY.S_Territiry_Name AS TerritiryName,
				HRKY.I_City_ID AS CityID,
				HRKY.S_City_Name AS CityName,
				TMP1.I_Centre_Id,
				TMP1.CenterCode,
				TMP1.CenterName,
				TMP1.I_Invoice_Header_ID,
				TMP1.I_Student_Detail_ID,
				TMP1.S_Student_ID,
				TMP1.S_Title,
				TMP1.S_First_Name,
				TMP1.S_Middle_Name,
				TMP1.S_Last_Name,
				ISNULL(TMP1.S_First_Name,'')+' '+ISNULL(TMP1.S_Middle_Name,'')+' '+ISNULL(TMP1.S_Last_Name,'') AS StudentName,
				TMP1.Invoice_No,
				TMP1.Invoice_Date,
				TMP1.Invoice_Amount,
				TMP1.Tax_Amount,
				TMP1.N_Discount_Amount,
				TMP1.InstanceChain,
				TMP1.S_Currency_Code,
				TMP1.Receipt_Amount,
				TMP1.Outstanding_Amt,
				TMP1.Last_Install_Date,
				--CM.I_Course_ID,
				--CM.S_Course_Code AS Course_Code,
				--CM.S_Course_Name AS Course_Name,
				TMP1.Last_Install_Amount,
				TMP1.Student_Status,
				TMP1.Amount_Due_LM,
				TMP2.Amount_Due_CM
		FROM #TmpOutStandingRpt3 TMP1
				INNER JOIN #TmpOutStandingRpt4 TMP2
				ON TMP1.I_Invoice_Header_ID = TMP2.I_Invoice_Header_ID
				AND TMP1.I_Centre_Id = TMP2.I_Centre_Id
				AND TMP1.I_Student_Detail_ID = TMP2.I_Student_Detail_ID				
				INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS HRKY ON TMP1.I_CENTRE_ID=HRKY.I_Center_ID
		GROUP BY 
				HRKY.I_Brand_ID,
				HRKY.S_Brand_Name,
				HRKY.I_Region_ID,
				HRKY.S_Region_Name,
				HRKY.I_Territory_ID,
				HRKY.S_Territiry_Name,
				HRKY.I_City_ID,
				HRKY.S_City_Name,
				TMP1.I_Centre_Id,
				TMP1.CenterCode,
				TMP1.CenterName,
				TMP1.I_Invoice_Header_ID,
				TMP1.I_Student_Detail_ID,
				TMP1.S_Student_ID,
				TMP1.S_Title,
				TMP1.S_First_Name,
				TMP1.S_Middle_Name,
				TMP1.S_Last_Name,
				TMP1.Invoice_No,
				TMP1.Invoice_Date,
				TMP1.Invoice_Amount,
				TMP1.Tax_Amount,
				TMP1.N_Discount_Amount,
				TMP1.InstanceChain,
				TMP1.S_Currency_Code,
				TMP1.Receipt_Amount,
				TMP1.Outstanding_Amt,
				TMP1.Last_Install_Date,
				TMP1.Last_Install_Amount,
				TMP1.Student_Status,
				TMP1.Amount_Due_LM,
				TMP2.Amount_Due_CM

	 DROP TABLE #TmpOutStandingRpt1
	 DROP TABLE #TmpOutStandingRpt2
	 DROP TABLE #TmpOutStandingRpt3
	 DROP TABLE #TmpOutStandingRpt4

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
