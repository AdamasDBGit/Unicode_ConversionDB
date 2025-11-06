/*
-- =================================================================
-- Author:Babin Saha
-- Create date:08/16/2007 
-- Description: SP For MBP Report 2
 
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspMBPVarianceReport]
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
	,@iProductID	INT
	,@sProductName	VARCHAR(50)= NULL
	,@iComponentID	INT
	,@sComponentName	VARCHAR(50)= NULL

/*
@iComponentID - 0
@iComponentID - 1 - Enquiry
@iComponentID - 2 - Admission
@iComponentID - 3 - Booking
@iComponentID - 4 - Billing
*/

)
AS
BEGIN TRY

DECLARE @BrandName VARCHAR (1000)
, @BrandCode VARCHAR (1000)
, @CenterName VARCHAR (1000)
, @CenterCode VARCHAR (1000)
, @InstanceChain VARCHAR(8000)
, @diff INT 
, @icountMonth INT
,@iTypeCount INT
,@ProductName VARCHAR (512)

SET @iTypeCount =1
SET @icountMonth =@startMonth
SET @diff = @endMonth - @startMonth

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
		AND MBP.I_Product_ID = @iProductID
/*End GET Brand,Center*/
SET @ProductName =(SELECT S_Product_Name FROM MBP.T_Product_Master WHERE I_Product_ID=@iProductID)
	--SELECT @BrandCode,@BrandName,@CenterName,@CenterCode,@InstanceChain
DECLARE @tblReport TABLE
(
	 ID				INT IDENTITY(1,1)
	,Brand			VARCHAR(255)
	,Region			VARCHAR(255)
	,Center			VARCHAR(255)
	,ProductName	VARCHAR(255)
	,MonthName		VARCHAR(50)
	,Component		VARCHAR(255)
	,Budget			INT NULL
	,Target			INT	NULL
	,Achievement	INT	NULL
	
)
/************************************************/
/**************** ALL COMPONENT  ****************/
IF @iComponentID =0
BEGIN
	WHILE @icountMonth < = @endMonth
	BEGIN
		WHILE @iTypeCount <= 4
		BEGIN
			INSERT INTO @tblReport
			(
				 Brand
				,Region	
				,Center
				,ProductName
				,MonthName
				,Component
				,Budget
				,Target	
				,Achievement
				
			)
			VALUES
			(
				@BrandCode
				,''--(SUBSTRING(REPLACE((REPLACE(@InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(@InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(@InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(@InstanceChain,' ','')),0)+2)))) 
				,@CenterCode
				,@ProductName
				,DATENAME(mm, DATEADD(mm, @icountMonth - 1, 0))
				,REPORT.fnGetMBPComponentName(@iTypeCount)
				,REPORT.fnGetTargetABP4(@iCenterID,@icountMonth,@startYear,@iTypeCount,4,@iProductID)	--ABP
				,REPORT.fnGetTargetMBP5(@iCenterID,@icountMonth,@startYear,@iTypeCount,5,@iProductID)	--MBP
				,REPORT.fnGetMBPActualPerformance(@iCenterID,@icountMonth,@startYear,@iTypeCount,@iProductID)	--ACTIAL
				
			)
			SET @iTypeCount = @iTypeCount +1
		END
		INSERT INTO @tblReport
			(
				 Brand
				,Region	
				,Center
				,ProductName
				,MonthName
				,Component
				,Budget
				,Target	
				,Achievement
			)
			VALUES
			(
				NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
			)
		SET @iTypeCount=1
		SET @icountMonth = @icountMonth + 1
	END
END
/************************************************/
/****************	 INDIVIDUAL  ****************/
ELSE
--IF @iComponentID =1 
BEGIN
	WHILE @icountMonth < = @endMonth
	BEGIN
			INSERT INTO @tblReport
			(
				 Brand
				,Region	
				,Center
				,ProductName
				,MonthName
				,Component
				,Budget
				,Target	
				,Achievement
			)
			VALUES
			(
				@BrandCode
				,''--(SUBSTRING(REPLACE((REPLACE(@InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(@InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(@InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(@InstanceChain,' ','')),0)+2)))) 
				,@CenterCode
				,@ProductName
				,DATENAME(mm, DATEADD(mm, @icountMonth - 1, 0))
				,REPORT.fnGetMBPComponentName(@iComponentID)
				,REPORT.fnGetTargetABP4(@iCenterID,@icountMonth,@startYear,@iComponentID,4,@iProductID)	--ABP
				,REPORT.fnGetTargetMBP5(@iCenterID,@icountMonth,@startYear,@iComponentID,5,@iProductID)	--MBP
				,REPORT.fnGetMBPActualPerformance(@iCenterID,@icountMonth,@startYear,@iComponentID,@iProductID)	--ACTIAL
			)
		SET @icountMonth = @icountMonth + 1
	END

END
/************************************************/


SELECT *,@InstanceChain AS InstanceChain  FROM @tblReport
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
