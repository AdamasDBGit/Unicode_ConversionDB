/*
-- =================================================================
-- Author:sanjay
-- Create date:07/31/2007 
-- Description: Select From  [T_Logistics_Master used in GetLogisticsItemList Method in LogisticsBuilder
-- =================================================================
*/
CREATE PROCEDURE[LOGISTICS].[uspGetLogisticsItemPlaceOrders]
(
	@iCenterID	 INT	= 0	,
	@iLogisticsType INT = 0,	
	@sItemGrade VARCHAR(200)= NULL,
	@CourseID INT = 0
)

AS
BEGIN
SET NOCOUNT OFF;
	SELECT DISTINCT
		ISNULL(LM.I_Logistics_ID,0) AS I_Logistics_ID,
		ISNULL(LM.I_Logistics_Type_ID,0) AS I_Logistic_Type_ID,
		ISNULL(LM.I_Logistics_ID,0) AS I_Logistics_ID,
		ISNULL(LM.S_SAP_Logistics_ID,0) AS S_SAP_Logistics_ID,
		ISNULL(LM.I_Course_ID,0) AS I_Course_ID,
		ISNULL(LM.I_Module_ID,0) AS I_Module_ID,
		ISNULL(LM.I_Module_ID,0) AS I_Module_ID,
		ISNULL(LM.I_Document_ID,0) AS I_Document_ID,
		ISNULL(LM.S_Item_Code,'') AS S_Item_Code,
		ISNULL(LM.S_Item_Desc,'') AS S_Item_Desc,
		ISNULL(LM.I_Item_Price_INR,0) AS I_Item_Price_INR,
		ISNULL(LM.I_Item_Price_USD,0) AS I_Item_Price_USD,
		ISNULL(LM.S_Item_Grade,'') AS S_Item_Grade,
		ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc
	FROM
		dbo.T_Course_Center_Detail CCD
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON LM.I_Course_ID = CCD.I_Course_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
	WHERE
		CCD.I_Centre_Id = COALESCE(@iCenterID, CCD.I_Centre_Id)
		AND LM.I_Logistics_Type_ID = COALESCE(@iLogisticsType, LM.I_Logistics_Type_ID)
		AND LM.S_Item_Grade = COALESCE(@sItemGrade, LM.S_Item_Grade)
		AND LM.I_Course_ID = COALESCE(@CourseID, LM.I_Course_ID)
END
