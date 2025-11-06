/*
-- =================================================================
-- Author:Babin SAha
-- Create date:20/16/2007 
-- Description: SP For MBP Report 1
 
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspMBPProductWiseReport]
(
	@sHierarchyList VARCHAR(MAX) = NULL
	,@iBrandID		INT = NULL
	,@iCenterID		INT = NULL
	,@startMonth	INT	
	,@startMonthName	VARCHAR(50)= NULL
	,@startYear		INT
	,@startYearName		VARCHAR(50)= NULL
	,@endMonth		INT
	,@endMonthName		VARCHAR(50)= NULL
)

AS
BEGIN TRY

DECLARE @BrandName VARCHAR (1000)
, @BrandCode VARCHAR (1000)
, @CenterName VARCHAR (1000)
, @CenterCode VARCHAR (1000)
, @InstanceChain VARCHAR(8000)
, @diff INT 
, @icount INT
,@iRow INT
,@ProductName VARCHAR (512)


/*Start GET Brand,Center*/
SELECT	DISTINCT
		 @BrandCode = BND.S_Brand_Code
		,@BrandName = BND.S_Brand_Name
		,@CenterName = CEN.S_Center_Name
		,@CenterCode = CEN.S_Center_Code
		,@InstanceChain = FN2.InstanceChain
		FROM MBP.T_MBP_Detail MBP

		LEFT OUTER JOIN dbo.T_Centre_Master CEN
		ON CEN.I_Centre_Id = MBP.I_Center_ID
		
		LEFT OUTER JOIN dbo.T_Brand_Center_Details BNDCEN
		ON BNDCEN.I_Centre_Id = CEN.I_Centre_ID
	
		LEFT OUTER JOIN dbo.T_Brand_Master BND
		ON BND.I_Brand_ID = BNDCEN.I_Brand_ID
		
		LEFT OUTER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		ON FN1.CenterID = MBP.I_Center_ID
		LEFT OUTER JOIN  [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		ON FN1.HierarchyDetailID=FN2.HierarchyDetailID

		WHERE MBP.I_Center_ID = @iCenterID
		
/*End GET Brand,Center*/


DECLARE @temTable TABLE
(
	ID INT IDENTITY(1,1)
	,ProductID	VARCHAR(255)
	,ProductName	VARCHAR(255)
	,Admission		VARCHAR(50)
	,Billing		VARCHAR(255)
)
INSERT INTO @temTable
SELECT 
PER.I_Product_ID
,PROD.S_Product_Name
,ISNULL(SUM(I_Actual_Enrollment),0)  AS Admission
,ISNULL(SUM(I_Actual_Billing),0) AS Billing
FROM MBP.T_MBPerformance PER

INNER JOIN MBP.T_Product_Master PROD
ON PER.I_Product_ID = PROD.I_Product_ID

WHERE PER.I_Month >= @startMonth
AND PER.I_Month <= @endMonth
AND PER.I_Year = @startYear
AND PER.I_Center_ID =@iCenterID

GROUP BY PER.I_Product_ID,PROD.S_Product_Name

DECLARE @tblReport TABLE
(
	 ID				INT IDENTITY(1,1)
	,InstanceChain			VARCHAR(1024)
	,Region			VARCHAR(255)
	,Center			VARCHAR(255)
	,ProductName	VARCHAR(255)
	,Admission		VARCHAR(50)
	,Billing		VARCHAR(255)
)

SET @iRow = (SELECT COUNT(*) FROM @temTable)
SET @icount =1
WHILE @icount<= @iRow
BEGIN
DECLARE @Pname VARCHAR(255)
,@Enrol VARCHAR(255)
,@Bill VARCHAR(255)

SET  @Pname = (SELECT ProductName FROM @temTable WHERE ID = @icount)
SET  @Enrol = (SELECT Admission FROM @temTable WHERE ID = @icount)
SET  @Bill =  (SELECT Billing FROM @temTable WHERE ID = @icount)
			INSERT INTO @tblReport
			(
				InstanceChain
				,Region	
				,Center
				,ProductName
				,Admission
				,Billing
			)
			VALUES
			(
				@InstanceChain	
				,''--(SUBSTRING(REPLACE((REPLACE(@InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(@InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(@InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(@InstanceChain,' ','')),0)+2)))) 
				,@CenterName
				,LTRIM(@Pname)
				,LTRIM(@Enrol)
				,LTRIM(@Bill)
			)

SET @icount = @icount + 1
END




--SELECT * FROM @tblReport

SELECT 
	 ID
	,InstanceChain
	,Region		
	,Center
	,ProductName	
	,CONVERT(INT,Admission) AS Admission		
	,CONVERT(NUMERIC(18,2),Billing ) AS Billing	
	FROM @tblReport	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
