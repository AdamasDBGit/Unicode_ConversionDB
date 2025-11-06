-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [REPORT].[uspGetInvoiceHierarchyReportDetailsForGraph] 
	--Add the parameters for the stored procedure here
	@sHierarchyID VARCHAR(MAX),
	@sBrandID VARCHAR(20),
	@sCenterIDs VARCHAR(MAX),
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
	--@sCourseIDs VARCHAR(MAX)
AS
BEGIN

	DECLARE @YEARMONTH TABLE (	[MONTH] INT,[YEAR] INT	)
	DECLARE @MONTH_START INT, @MONTH_CURRENT INT, @MONTH_END INT, @YR_START INT, @YR_CURRENT INT, @YR_END INT	
	
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
		INVOICE_NO VARCHAR(50),
		INVOICE_DATE DATETIME,
		STUDENT_ID VARCHAR(50),
		STUDENT_NAME VARCHAR(200),
		INVOICE_AMOUNT NUMERIC(18,2),
		INVOICE_TAX NUMERIC(18,2),
		TOTAL NUMERIC(18,2)
	)
	
	DECLARE @index INT, @rowCount INT, @iTempCenterID INT
	DECLARE @tblCenter TABLE(ID INT IDENTITY(1,1), CenterId INT)
	
	--DECLARE @tblCourse TABLE(CourseID INT)
	DECLARE @iHierarchDetailID INT, @sHierarchyChain VARCHAR(100)
	DECLARE @CenterName VARCHAR(100), @BrandID INT, @BrandName VARCHAR(100), @RegionID INT, 
		@RegionName VARCHAR(100), @TerritoryID INT, @TerritoryName VARCHAR(100), @CityID INT, @CityName VARCHAR(100)
		
	DECLARE @tblTempHierarchy TABLE (ID INT)
	
	SELECT @MONTH_START=MONTH(@dtStartDate)
	SELECT @MONTH_CURRENT=MONTH(@dtStartDate)
	SELECT @MONTH_END=MONTH(@dtEndDate)
	SELECT @YR_START=YEAR(@dtStartDate)
	SELECT @YR_CURRENT=YEAR(@dtStartDate)
	SELECT @YR_END=YEAR(@dtEndDate)

	WHILE (@YR_END>@YR_CURRENT) OR (@YR_END=@YR_CURRENT AND @MONTH_END>=@MONTH_CURRENT)
	BEGIN
		INSERT INTO @YEARMONTH VALUES(@MONTH_CURRENT,@YR_CURRENT)
		IF @MONTH_CURRENT =12
			BEGIN
				SELECT @MONTH_CURRENT = 1
				SELECT @YR_CURRENT=@YR_CURRENT+1
			END
		ELSE
			BEGIN
				SELECT @MONTH_CURRENT = @MONTH_CURRENT +1
			END
	END
	
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
	
	
	INSERT INTO @EEBCANALYSIS (I_CENTRE_ID,CENTERCODE,S_CURRENCY_CODE,I_COURSE_ID,S_COURSE,S_COURSE_FAMILY,[MONTH],[YEAR],[INVOICE_NO],[INVOICE_DATE],[STUDENT_ID],[STUDENT_NAME],[INVOICE_AMOUNT],[INVOICE_TAX],[TOTAL])
	
	SELECT DISTINCT
	A.I_CENTRE_ID, 
	A.CENTERCODE, 
	A.S_CURRENCY_CODE,
	tich.[I_Course_ID] as CourseID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([IP].[Dt_Invoice_Date]),
	YEAR([IP].[Dt_Invoice_Date]),
	IP.S_Invoice_No,
	IP.Dt_Invoice_Date,
	TSD.S_Student_ID,
	RTRIM(LTRIM(ISNULL(TSD.S_First_Name,'') + ' ' + ISNULL(TSD.S_Middle_Name,'') + ' ' + ISNULL(TSD.S_Last_Name,''))),
	ISNULL(tich.N_Amount,0),
	ISNULL(tich.N_Tax_Amount,0),
	ISNULL(tich.N_Amount,0)+ISNULL(tich.N_Tax_Amount,0) AS Total
	FROM DBO.T_INVOICE_PARENT IP 
	INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=IP.I_CENTRE_ID
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON IP.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
	INNER JOIN DBO.T_Student_Detail TSD ON IP.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	-------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD ON [TSCD].[I_Student_Detail_ID] = IP.[I_Student_Detail_ID]
	--INNER JOIN @tblCourse TC ON TC.CourseID = TSCD.[I_Course_ID]
	INNER JOIN [dbo].[T_Course_Master] AS TCM ON tich.[I_Course_ID] = [TCM].[I_Course_ID]
	INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]
	WHERE (DATEDIFF(DD,[IP].[Dt_Invoice_Date],@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,[IP].[Dt_Invoice_Date])<= 0)
	AND IP.[I_Student_Detail_ID] NOT IN 
	(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))
	UNION
	SELECT DISTINCT
	A.I_CENTRE_ID, 
	A.CENTERCODE, 
	A.S_CURRENCY_CODE,
	tich.[I_Course_ID] as CourseID,
	TCM.S_Course_Name,
	TCFM.S_CourseFamily_Name,
	MONTH([IP].[DT_UPD_ON]),
	YEAR([IP].[DT_UPD_ON]),
	IP.S_Invoice_No,
	IP.DT_UPD_ON,
	TSD.S_Student_ID,
	RTRIM(LTRIM(ISNULL(TSD.S_First_Name,'') + ' ' + ISNULL(TSD.S_Middle_Name,'') + ' ' + ISNULL(TSD.S_Last_Name,''))),
	ISNULL(tich.N_Amount,0) *(-1),
	ISNULL(tich.N_Tax_Amount,0) *(-1),
	(ISNULL(tich.N_Amount,0)+ISNULL(tich.N_Tax_Amount,0)) * (-1) AS Total
	FROM DBO.T_INVOICE_PARENT IP 
	INNER JOIN @EEBCINITIAL A ON A.I_CENTRE_ID=IP.I_CENTRE_ID
	INNER JOIN dbo.T_Invoice_Child_Header AS tich ON IP.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
	INNER JOIN DBO.T_Student_Detail TSD ON IP.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	-------INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD ON [TSCD].[I_Student_Detail_ID] = IP.[I_Student_Detail_ID]
	--INNER JOIN @tblCourse TC ON TC.CourseID = TSCD.[I_Course_ID]
	INNER JOIN [dbo].[T_Course_Master] AS TCM ON tich.[I_Course_ID] = [TCM].[I_Course_ID]
	INNER JOIN [dbo].[T_CourseFamily_Master] AS TCFM ON [TCM].[I_CourseFamily_ID] = [TCFM].[I_CourseFamily_ID]
	WHERE (DATEDIFF(DD,IP.DT_UPD_ON,@dtStartDate) <= 0 AND DATEDIFF(DD,@dtEndDate,IP.DT_UPD_ON) <= 0)
	AND IP.[I_Student_Detail_ID] NOT IN 
	(SELECT [TCSIM].[I_Student_Detail_ID] FROM [dbo].[T_Corp_Student_Invoice_Map] AS TCSIM WITH(NOLOCK))	
	
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
	ON B.I_Center_ID = TCM.I_Centre_Id
	WHERE [TCM].[I_Status] <> 0

END
--EXEC [REPORT].[uspGetInvoiceHierarchyReportDetailsForGraphNew] 1,2,'','2011-01-01','2011-06-30'
--EXEC [REPORT].[uspGetInvoiceHierarchyReportDetailsForGraph] 1,2,'','2011-01-01','2011-06-30'
