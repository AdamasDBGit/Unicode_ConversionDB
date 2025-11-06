/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:08/21/2007 
-- Description: SP For Logistics Item Indent Track Report
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspGetLogisticsCycleTimeAnalysisReport]
(
	@iBrandID INT = NULL,
	@sHierarchyList VARCHAR(MAX) = NULL,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
)
AS
BEGIN TRY

SELECT	
		 		
		FN2.InstanceChain AS InstanceChain
		,FN1.CenterName AS CenterName
		--,(SUBSTRING(REPLACE((REPLACE(FN2.InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(FN2.InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0)+2)))) AS RegionName
		,(LO.Order_Date) AS Order_Date
		,ISNULL(LP.Dt_Issue_Date, ' ') AS Dt_Issue_Date
		--,COALESCE(LP.Dt_Issue_Date, Dt_Issue_Date) AS Dt_Issue_Date
		,(LDI.Dt_Despatch_Date) AS Dt_Despatch_Date
		,(LDI.S_Docket_No) AS S_Docket_No
		,(LDI.Dt_Crtd_On) AS Dt_Crtd_On

		FROM LOGISTICS.T_Logistics_Order LO
		RIGHT JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
		ON LO.I_Center_ID =FN1.CenterID
		RIGHT JOIN  [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
		ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
		--RIGHT JOIN 
		,LOGISTICS.T_Logistics_Payment LP
		--ON LP.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		--RIGHT JOIN 
		,LOGISTICS.T_Logistics_Despatch_Info LDI
		--ON LDI.I_Logistics_Order_ID = LO.I_Logistic_Order_ID

		WHERE DATEDIFF(dd, ISNULL(@dtStartDate, LO.Order_Date),  LO.Order_Date) >= 0
		AND DATEDIFF(dd, ISNULL(@dtEndDate, LO.Order_Date),  LO.Order_Date) <= 0
		AND LP.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		AND LDI.I_Logistics_Order_ID = LO.I_Logistic_Order_ID

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
