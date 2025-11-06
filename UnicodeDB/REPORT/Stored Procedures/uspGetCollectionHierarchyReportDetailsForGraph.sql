CREATE PROCEDURE [REPORT].[uspGetCollectionHierarchyReportDetailsForGraph] 
	-- Add the parameters for the stored procedure here
	@sHierarchyID VARCHAR(MAX),
	@sBrandID VARCHAR(20),
	@sCenterIDs VARCHAR(MAX),
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
	--@sCourseIDs VARCHAR(MAX)
AS
BEGIN

	
	DECLARE @EEBCINITIAL TABLE
	(
		I_CENTRE_ID INT,
		CENTERCODE VARCHAR(20),
		CENTERNAME VARCHAR(100),
		S_CURRENCY_CODE VARCHAR(20)
	)

	DECLARE @EEBCANALYSIS TABLE
	(
		I_CENTRE_ID INT,
		CENTERCODE VARCHAR(20),
		S_CURRENCY_CODE VARCHAR(20),
		S_COURSE_FAMILY VARCHAR(50),
		I_COURSE_ID INT,
		S_COURSE VARCHAR(250),
		[MONTH] INT,
		[YEAR] INT,
		RECEIPT_NO VARCHAR(50),
		RECEIPT_DATE DATETIME,
		STUDENT_ID VARCHAR(50),
		STUDENT_NAME VARCHAR(200),
		COLLECTION_AMOUNT NUMERIC(18,2),
		COLLECTION_TAX NUMERIC(18,2),
		TOTAL NUMERIC(18,2),
		I_Rec_ID INT
	)
	
	DECLARE @index INT, @rowCount INT, @iTempCenterID INT
	DECLARE @tblCenter TABLE(ID INT IDENTITY(1,1), CenterId INT)
	
	--DECLARE @tblCourse TABLE(CourseID INT)
	DECLARE @iHierarchDetailID INT, @sHierarchyChain VARCHAR(100)
	DECLARE @CenterName VARCHAR(100), @BrandID INT, @BrandName VARCHAR(100), @RegionID INT, 
		@RegionName VARCHAR(100), @TerritoryID INT, @TerritoryName VARCHAR(100), @CityID INT, @CityName VARCHAR(100)
		
	DECLARE @tblTempHierarchy TABLE (ID INT)
	
	
	INSERT INTO @tblCenter
	SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCenterIDs, ',') AS FSR
	
	IF ((SELECT COUNT(ID) FROM @tblCenter) = 0)
	BEGIN
		INSERT INTO @tblCenter
		SELECT [I_Center_ID] FROM [dbo].[fnGetCenterIDFromHierarchy](@sHierarchyID, CAST(@sBrandID AS INT)) AS FGCIFH
	END
	
	--INSERT INTO @tblCourse
	--SELECT CAST([Val] AS INT) FROM [dbo].[fnString2Rows](@sCourseIDs, ',') AS FSR
	
	DECLARE @INVOICE_AMOUNT NUMERIC(18,2)
	
	DECLARE @CENTERID INT
	DECLARE @CENTERCODE VARCHAR(20)
	DECLARE @CURRENCYCODE VARCHAR(20)
	
	INSERT INTO @EEBCINITIAL
	SELECT DISTINCT 
	FN1.CENTERID,
	TCM.[S_Center_Code] AS CENTERCODE,
	TCM.[S_Center_Name] AS CENTERNAME,
	CUM.S_CURRENCY_CODE
	FROM @tblCenter FN1
	INNER JOIN [dbo].[T_Centre_Master] AS TCM ON [FN1].[CenterId] = [TCM].[I_Centre_Id]
	INNER JOIN DBO.T_COUNTRY_MASTER COM ON TCM.[I_Country_ID] = COM.I_COUNTRY_ID
	INNER JOIN DBO.T_CURRENCY_MASTER CUM ON COM.I_CURRENCY_ID = CUM.I_CURRENCY_ID
	ORDER BY CENTERID

	
	
	INSERT INTO @EEBCANALYSIS (I_CENTRE_ID,CENTERCODE,S_CURRENCY_CODE,I_COURSE_ID,S_COURSE,S_COURSE_FAMILY,[MONTH],[YEAR],[RECEIPT_NO],[RECEIPT_DATE],[STUDENT_ID],[STUDENT_NAME],[COLLECTION_AMOUNT],[COLLECTION_TAX],[TOTAL],[I_Rec_ID])
	(
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	TCM.I_Course_ID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	TSD2.S_Student_ID,
	RTRIM(LTRIM(ISNULL(TSD2.S_First_Name,'') + ' ' + ISNULL(TSD2.S_Middle_Name,'') + ' ' + ISNULL(TSD2.S_Last_Name,''))) STUDENTNAME,
	ISNULL(TRCD.N_Amount_Paid,0) AMOUNT,
	ISNULL(Tax.N_Tax_Paid,0) TAX,
	(ISNULL(TRCD.N_Amount_Paid,0)+ISNULL(TAX.N_Tax_Paid,0)) TOTAL
	,TRCD.I_Receipt_Comp_Detail_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)	
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID	
	--AND [RH].[I_Status] = 1
	INNER JOIN [dbo].[T_Receipt_Component_Detail] AS TRCD ON [RH].[I_Receipt_Header_ID] = [TRCD].[I_Receipt_Detail_ID]
	INNER JOIN [dbo].[T_Invoice_Child_Detail] AS TICD ON [TRCD].[I_Invoice_Detail_ID] = [TICD].[I_Invoice_Detail_ID]
	INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON TICD.[I_Invoice_Child_Header_ID] = [TICH].[I_Invoice_Child_Header_ID]
	INNER JOIN [DBO].[T_COURSE_MASTER] TCM ON TICH.I_Course_ID = TCM.I_Course_ID
	INNER JOIN DBO.T_CourseFamily_Master TCFM ON TCM.I_CourseFamily_ID = TCFM.I_CourseFamily_ID
	INNER JOIN DBO.T_Student_Detail TSD2 ON RH.I_Student_Detail_ID=TSD2.I_Student_Detail_ID
	LEFT OUTER JOIN 
	(
	SELECT trtd.I_Receipt_Comp_Detail_ID,ICH.I_Course_ID, SUM(trtd.N_Tax_Paid) AS N_Tax_Paid 
	FROM dbo.T_Receipt_Tax_Detail AS trtd 
	INNER JOIN DBO.T_Invoice_Child_Detail ICD ON trtd.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
	INNER JOIN DBO.T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID 
	GROUP BY trtd.I_Receipt_Comp_Detail_ID,ICH.I_Course_ID
	) 
	AS Tax
	ON TRCD.I_Receipt_Comp_Detail_ID = Tax.I_Receipt_Comp_Detail_ID
	AND TICH.I_Course_ID=Tax.I_Course_ID
	WHERE RH.[I_Student_Detail_ID] IS NOT NULL 
		AND	RH.[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))
	AND (DATEDIFF(DD,RH.DT_RECEIPT_DATE,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_RECEIPT_DATE) <= 0)
	
	UNION ALL
	
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	TCM.I_Course_ID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	TSD2.S_Student_ID,
	RTRIM(LTRIM(ISNULL(TSD2.S_First_Name,'') + ' ' + ISNULL(TSD2.S_Middle_Name,'') + ' ' + ISNULL(TSD2.S_Last_Name,''))) STUDENTNAME,
	ISNULL(TRCD.N_Amount_Paid,0) AMOUNT,
	ISNULL(Tax.N_Tax_Paid,0) TAX,
	(ISNULL(TRCD.N_Amount_Paid,0)+ISNULL(TAX.N_Tax_Paid,0)) TOTAL
	,TRCD.I_Receipt_Comp_Detail_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)	
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID	
	AND [RH].[I_Status] = 0
	INNER JOIN [dbo].[T_Receipt_Component_Detail] AS TRCD ON [RH].[I_Receipt_Header_ID] = [TRCD].[I_Receipt_Detail_ID]
	INNER JOIN [dbo].[T_Invoice_Child_Detail] AS TICD ON [TRCD].[I_Invoice_Detail_ID] = [TICD].[I_Invoice_Detail_ID]
	INNER JOIN [dbo].[T_Invoice_Child_Header] AS TICH ON TICD.[I_Invoice_Child_Header_ID] = [TICH].[I_Invoice_Child_Header_ID]
	INNER JOIN [DBO].[T_COURSE_MASTER] TCM ON TICH.I_Course_ID = TCM.I_Course_ID
	INNER JOIN DBO.T_CourseFamily_Master TCFM ON TCM.I_CourseFamily_ID = TCFM.I_CourseFamily_ID
	INNER JOIN DBO.T_Student_Detail TSD2 ON RH.I_Student_Detail_ID=TSD2.I_Student_Detail_ID
	LEFT OUTER JOIN 
	(
	SELECT trtd.I_Receipt_Comp_Detail_ID,ICH.I_Course_ID, SUM(trtd.N_Tax_Paid) AS N_Tax_Paid 
	FROM dbo.T_Receipt_Tax_Detail AS trtd 
	INNER JOIN DBO.T_Invoice_Child_Detail ICD ON trtd.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
	INNER JOIN DBO.T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID 
	GROUP BY trtd.I_Receipt_Comp_Detail_ID,ICH.I_Course_ID
	) 
	AS Tax
	ON TRCD.I_Receipt_Comp_Detail_ID = Tax.I_Receipt_Comp_Detail_ID
	AND TICH.I_Course_ID=Tax.I_Course_ID
	WHERE RH.[I_Student_Detail_ID] IS NOT NULL 
		AND	RH.[I_Student_Detail_ID] NOT IN 
			(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))
	AND (DATEDIFF(DD,RH.DT_UPD_ON,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_UPD_ON) <= 0)
	
	UNION ALL
	
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	TCM.I_Course_ID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	erd.S_Enquiry_No,
	RTRIM(LTRIM(ISNULL(erd.S_First_Name,'') + ' ' + ISNULL(erd.S_Middle_Name,'') + ' ' + ISNULL(erd.S_Last_Name,''))) STUDENTNAME,
	
	ISNULL(RH.N_Receipt_Amount,0) AMOUNT,
	ISNULL(RH.N_Tax_Amount,0) TAX,
	ISNULL(RH.N_Receipt_Amount,0) + ISNULL(RH.N_Tax_Amount,0) TOTAL
	
	,RH.I_Receipt_Header_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID
	--AND [RH].[I_Status] = 1
	INNER JOIN [dbo].T_Student_Registration_Details AS TSRD WITH(NOLOCK) 
	ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID
	AND [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]
	INNER JOIN dbo.T_Enquiry_Regn_Detail erd ON RH.I_Enquiry_Regn_ID = erd.I_Enquiry_Regn_ID
	INNER JOIN T_Student_Batch_Master AS TSBM WITH(NOLOCK) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID
	INNER JOIN dbo.T_Course_Master tcm ON TSBM.I_Course_ID=tcm.I_Course_ID
	INNER JOIN DBO.T_CourseFamily_Master TCFM ON TCM.I_CourseFamily_ID = TCFM.I_CourseFamily_ID
	WHERE RH.[I_Student_Detail_ID] IS NULL
	AND (DATEDIFF(DD,RH.DT_RECEIPT_DATE,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_RECEIPT_DATE) <= 0)
	
	UNION ALL
	
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	TCM.I_Course_ID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	erd.S_Enquiry_No,
	RTRIM(LTRIM(ISNULL(erd.S_First_Name,'') + ' ' + ISNULL(erd.S_Middle_Name,'') + ' ' + ISNULL(erd.S_Last_Name,''))) STUDENTNAME,

	ISNULL(RH.N_Receipt_Amount,0) * (-1) AMOUNT,
	ISNULL(RH.N_Tax_Amount,0) * (-1) TAX,
	ISNULL(RH.N_Receipt_Amount,0) + ISNULL(RH.N_Tax_Amount,0) * (-1) TOTAL

	,RH.I_Receipt_Header_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID
	AND [RH].[I_Status] = 0
	INNER JOIN [dbo].T_Student_Registration_Details AS TSRD WITH(NOLOCK) 
	ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID
	AND [TSRD].[I_Receipt_Header_ID] = [RH].[I_Receipt_Header_ID]
	INNER JOIN dbo.T_Enquiry_Regn_Detail erd ON RH.I_Enquiry_Regn_ID = erd.I_Enquiry_Regn_ID
	INNER JOIN T_Student_Batch_Master AS TSBM WITH(NOLOCK) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID
	INNER JOIN dbo.T_Course_Master tcm ON TSBM.I_Course_ID=tcm.I_Course_ID
	INNER JOIN DBO.T_CourseFamily_Master TCFM ON TCM.I_CourseFamily_ID = TCFM.I_CourseFamily_ID
	WHERE RH.[I_Student_Detail_ID] IS NULL
	AND (DATEDIFF(DD,RH.DT_UPD_ON,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_UPD_ON) <= 0)
	
	UNION ALL
	
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	99999999 I_Course_ID,
	'On-Account Receipts' S_Course_Name,
	'On-Account Receipts' S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	SD.S_Student_ID,
	RTRIM(LTRIM(ISNULL(SD.S_First_Name,'') + ' ' + ISNULL(SD.S_Middle_Name,'') + ' ' + ISNULL(SD.S_Last_Name,''))) STUDENTNAME,
	ISNULL(RH.N_Receipt_Amount,0) AMOUNT,
	ISNULL(RH.N_Tax_Amount,0) TAX,
	ISNULL(RH.N_Receipt_Amount,0) + ISNULL(RH.N_Tax_Amount,0) TOTAL
	,RH.I_Receipt_Header_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID
	INNER JOIN T_STUDENT_DETAIL SD ON RH.I_Student_Detail_ID=SD.I_Student_Detail_ID
	WHERE RH.[I_Student_Detail_ID] IS NOT NULL AND I_Invoice_Header_ID IS NULL
	AND (DATEDIFF(DD,RH.DT_RECEIPT_DATE,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.DT_RECEIPT_DATE) <= 0)

	UNION ALL
	
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	99999999 I_Course_ID,
	'On-Account Receipts' S_Course_Name,
	'On-Account Receipts' S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	SD.S_Student_ID,
	RTRIM(LTRIM(ISNULL(SD.S_First_Name,'') + ' ' + ISNULL(SD.S_Middle_Name,'') + ' ' + ISNULL(SD.S_Last_Name,''))) STUDENTNAME,
	ISNULL(RH.N_Receipt_Amount,0) * (-1) AMOUNT,
	ISNULL(RH.N_Tax_Amount,0) * (-1) TAX,
	ISNULL(RH.N_Receipt_Amount,0) + ISNULL(RH.N_Tax_Amount,0) * (-1) TOTAL
	,RH.I_Receipt_Header_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID
	AND [RH].[I_Status] = 0
	INNER JOIN T_STUDENT_DETAIL SD ON RH.I_Student_Detail_ID=SD.I_Student_Detail_ID
	WHERE RH.[I_Student_Detail_ID] IS NOT NULL AND I_Invoice_Header_ID IS NULL
	AND (DATEDIFF(DD,RH.Dt_Upd_On,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.Dt_Upd_On) <= 0)

	UNION ALL
	
	SELECT DISTINCT
	RH.I_CENTRE_ID,
	A.CENTERCODE,
	A.S_CURRENCY_CODE, 
	TCM.I_Course_ID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([RH].Dt_Receipt_Date) MON,
	YEAR([RH].Dt_Receipt_Date) YR,
	RH.S_Receipt_No,
	RH.Dt_Receipt_Date,
	erd.S_Enquiry_No,
	RTRIM(LTRIM(ISNULL(erd.S_First_Name,'') + ' ' + ISNULL(erd.S_Middle_Name,'') + ' ' + ISNULL(erd.S_Last_Name,''))) STUDENTNAME,
	ISNULL(RH.N_Receipt_Amount,0) AMOUNT,
	ISNULL(RH.N_Tax_Amount,0) TAX,
	ISNULL(RH.N_Receipt_Amount,0) + ISNULL(RH.N_Tax_Amount,0) TOTAL
	,RH.I_Receipt_Header_ID
	FROM DBO.T_RECEIPT_HEADER RH WITH(NOLOCK)
	INNER JOIN @EEBCINITIAL A
	ON RH.I_CENTRE_ID = A.I_CENTRE_ID
	AND I_Receipt_Type = 21
	INNER JOIN [dbo].T_Student_Registration_Details AS TSRD WITH(NOLOCK) 
	ON [TSRD].I_Enquiry_Regn_ID = [RH].I_Enquiry_Regn_ID
	AND DATEDIFF(s,RH.Dt_Receipt_Date,TSRD.Updt_On) >= 0 AND DATEDIFF(s,RH.Dt_Receipt_Date,TSRD.Updt_On) < 15
	INNER JOIN T_Student_Batch_Master AS TSBM WITH(NOLOCK) ON TSBM.I_Batch_ID = TSRD.I_Batch_ID
	INNER JOIN dbo.T_Course_Master tcm ON TSBM.I_Course_ID=tcm.I_Course_ID
	INNER JOIN DBO.T_CourseFamily_Master TCFM ON TCM.I_CourseFamily_ID = TCFM.I_CourseFamily_ID
	INNER JOIN DBO.T_Enquiry_Regn_Detail ERD ON TSRD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
	WHERE RH.[I_Student_Detail_ID] IS NULL
	AND (DATEDIFF(DD,RH.Dt_Receipt_Date,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,RH.Dt_Receipt_Date) <= 0)
)
	-----------------------
	
	SELECT DISTINCT [B].[I_Center_ID] AS CenterID ,
	        [B].[S_Center_Name] AS CenterName ,
	        [B].[I_Brand_ID] AS BrandID ,
	        [B].[S_Brand_Name] AS BrandName ,
	        [B].[I_Region_ID] AS RegionID ,
	        [B].[S_Region_Name] AS RegionName ,
	        [B].[I_Territory_ID] AS TerritoryID ,
	        [B].[S_Territiry_Name]  AS TerritiryName,
	        [B].[I_City_ID] AS CityID ,
	        [B].[S_City_Name] AS CityName, A.* FROM @EEBCANALYSIS A
	INNER JOIN [dbo].[T_Centre_Master] AS TCM
	ON [TCM].[I_Centre_Id] = A.I_Centre_ID
	INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS B
	ON TCM.I_Centre_Id = B.I_Center_ID
	WHERE [TCM].[I_Status] <> 0
	
END


--EXEC [REPORT].[uspGetCollectionHierarchyReportDetailsForGraph] 1,2,NULL,'2011-07-01','2011-07-31'
