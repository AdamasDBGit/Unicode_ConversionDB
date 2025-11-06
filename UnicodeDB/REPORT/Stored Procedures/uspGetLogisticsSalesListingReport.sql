/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:08/21/2007 
-- Description: SP For Logistics Sales Listing Report
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspGetLogisticsSalesListingReport]
(
	@iBrandID INT = NULL,
	--@sHierarchyList VARCHAR(100) = NULL,
	@iDomInt INT = NULL,
	@sDomIntType VARCHAR(50) = NULL,
	@iCategoryID INT = NULL,
	@sCategoryName VARCHAR(50) = NULL,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
)
AS
BEGIN TRY

DECLARE @BrandName VARCHAR (1000)
--DECLARE @ItemTypeName VARCHAR (1000)

SELECT @BrandName=S_Brand_Name FROM dbo.T_Brand_Master WHERE I_Brand_ID = @iBrandID
--SELECT @ItemTypeName=S_Logistics_Type_Desc FROM LOGISTICS.T_Logistics_Type_Master WHERE I_Logistics_Type_ID = @iCategoryID

SELECT
		@BrandName AS BrandName
		,ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc
		,ISNULL(LM.S_Item_Code,'') AS S_Item_Code
		,ISNULL(LM.S_Item_Desc,'') AS S_Item_Desc
		,SUM(LM.I_Item_Price_INR) AS I_Item_Price_INR
		,SUM(LM.I_Item_Price_USD) AS I_Item_Price_USD
		--,FN2.InstanceChain AS InstanceChain
		--,FN1.CenterName AS CenterName
		--,(SUBSTRING(REPLACE((REPLACE(FN2.InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(FN2.InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0)+2)))) AS RegionName
		,SUM(LOL.I_Item_Qty) AS I_Item_Qty
FROM	
		LOGISTICS.T_Logistics_Order_Line LOL
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Order LO
		ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON LM.I_Logistics_ID = LOL.I_Logistics_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
		LEFT OUTER JOIN dbo.T_Centre_Master CM
		ON CM.I_Centre_Id = LO.I_Center_ID
WHERE
		DATEDIFF(dd, ISNULL(@dtStartDate, LO.Order_Date),  LO.Order_Date) >= 0
		AND DATEDIFF(dd, ISNULL(@dtEndDate, LO.Order_Date),  LO.Order_Date) <= 0
		AND LTM.I_Logistics_Type_ID = COALESCE(@iCategoryID, LTM.I_Logistics_Type_ID)
		AND CM.I_Country_ID = COALESCE(@iDomInt, CM.I_Country_ID)
GROUP BY
		--@BrandName
		LTM.S_Logistics_Type_Desc
		,LM.S_Item_Code
		,LM.S_Item_Desc
		
END TRY

BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
