/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:08/21/2007 
-- Description: SP For Logistics Sales Analysis Report
-- =================================================================
*/
CREATE PROCEDURE [REPORT].[uspGetLogisticsSalesAnalysisReport]
(
	@iBrandID INT = NULL,
	@iDomInt INT = NULL,
	@sDomIntType VARCHAR(50) = NULL,
	@iCategoryID INT = NULL,
	@sCategoryName VARCHAR(50) = NULL,
	@dtStartMonth DATETIME,
	@dtEndMonth DATETIME
)
AS
BEGIN TRY

DECLARE @BrandName VARCHAR (1000)

SELECT @BrandName=S_Brand_Name FROM dbo.T_Brand_Master WHERE I_Brand_ID = @iBrandID

SELECT	
		 @BrandName AS BrandName
		,ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc
		,SUM(LOL.I_Item_Qty) AS I_Item_Qty
		,SUM(LOL.I_Item_Amount) AS I_Item_Amount
		--,SUM(LOL.I_Item_Qty)/DATEDIFF(dd,@dtStartMonth,@dtEndMonth) AS Avg_I_Item_Qty -- Chandan
		--,SUM(LOL.I_Item_Amount)/DATEDIFF(dd,@dtStartMonth,@dtEndMonth) AS Avg_I_Item_Amount-- Chandan
		,SUM(LOL.I_Item_Qty)/DATEDIFF(mm,@dtStartMonth,@dtEndMonth) AS Avg_I_Item_Qty --babin
		,SUM(LOL.I_Item_Amount)/DATEDIFF(mm,@dtStartMonth,@dtEndMonth) AS Avg_I_Item_Amount --babin
FROM	
		LOGISTICS.T_Logistics_Order_Line LOL
		
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Order LO
		ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON LM.I_Logistics_ID = LOL.I_Logistics_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
WHERE
		LO.Order_Date >= @dtStartMonth 
		AND LO.Order_Date <= @dtEndMonth 
		AND LM.I_Logistics_Type_ID = COALESCE(@iCategoryID, LM.I_Logistics_Type_ID)
		
GROUP BY
		LTM.S_Logistics_Type_Desc

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
