/*
-- =================================================================
-- Author: Sanjay Mitra
-- Create date:08/20/2007 
-- Description: SP For Logistics Item Indent Track Report
 
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspGetLogisticsConsumptionReport]
(
	@iBrandID INT = NULL,
	@sHierarchyList VARCHAR(MAX) = NULL,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
)
AS
BEGIN TRY

--DECLARE @BrandCode VARCHAR (1000)
--SELECT @BrandCode = S_Brand_Code FROM dbo.T_Brand_Master WHERE I_Brand_ID =  1 @iBrandID

SELECT	
		 		
		 FN2.InstanceChain AS InstanceChain
		,FN1.CenterName AS CenterName
		--,(SUBSTRING(REPLACE((REPLACE(FN2.InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(FN2.InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0)+2)))) AS RegionName
		,SUM(LOL.I_Item_Amount) AS TotalAmount
		,COUNT(LO.I_Logistic_Order_ID)  NoOfIndents
		 FROM LOGISTICS.T_Logistics_Order LO 
			
		INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		ON LO.I_Center_ID =FN1.CenterID
		
		LEFT OUTER JOIN  [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		ON FN1.HierarchyDetailID=FN2.HierarchyDetailID

	
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Order_Line LOL
		ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID

		WHERE
		DATEDIFF(dd, ISNULL(@dtStartDate, LO.Order_Date),  LO.Order_Date) >= 0
		AND DATEDIFF(dd, ISNULL(@dtEndDate, LO.Order_Date),  LO.Order_Date) <= 0

		GROUP BY 
		FN2.InstanceChain
		,FN1.CenterName

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
