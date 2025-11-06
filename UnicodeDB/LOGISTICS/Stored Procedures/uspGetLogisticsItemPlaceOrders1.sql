/*
-- =================================================================
-- Author:sanjay
-- Create date:07/31/2007
-- Description: Select From [T_Logistics_Master used in GetLogisticsItemList Method in LogisticsBuilder
-- =================================================================
*/
CREATE PROCEDURE[LOGISTICS].[uspGetLogisticsItemPlaceOrders1]
(
@iCenterID INT = NULL,
@iLogisticsType INT = NULL,
@sItemGrade VARCHAR(200)= NULL,
@sItemCode VARCHAR(50) = NULL,
@sItemName VARCHAR(200) = NULL,
@CourseID INT = NULL,
@iBrandID INT = NULL
)

AS
BEGIN
IF(@iBrandID <> 55)
BEGIN
IF (@CourseID IS NOT NULL)
BEGIN
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
		ISNULL(LM.S_Remarks,'') AS S_Remarks,
		ISNULL(LM.I_Brand_ID,0) AS I_Brand_ID,
		ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc,
		

		ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
		ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
		ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
		ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
		ISNULL(UD.I_Document_ID,0) AS I_Document_ID
	FROM
		dbo.T_Course_Center_Detail CCD
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON LM.I_Course_ID = CCD.I_Course_ID
		--LOGISTICS.T_Logistics_Master LM
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
		LEFT OUTER JOIN dbo.T_Upload_Document UD
		ON LM.I_Document_ID = UD.I_Document_ID
	WHERE
		CCD.I_Centre_Id = COALESCE(@iCenterID, CCD.I_Centre_Id)
		AND LM.I_Logistics_Type_ID = COALESCE(@iLogisticsType, LM.I_Logistics_Type_ID)
		AND LM.S_Item_Grade = COALESCE(@sItemGrade, LM.S_Item_Grade)
		AND LM.S_Item_Code LIKE '%' + COALESCE(@sItemCode, LM.S_Item_Code) + '%'
		AND LM.S_Item_Desc LIKE '%' + COALESCE(@sItemName, LM.S_Item_Desc) + '%'
		AND LM.I_Course_ID = COALESCE(@CourseID, LM.I_Course_ID)
		AND LM.I_Brand_ID = COALESCE(@iBrandID, LM.I_Brand_ID)
		--AND (LM.I_Item_Price_INR IS NOT NULL OR LM.I_Item_Price_USD IS NOT NULL)
		--AND (LM.I_Item_Price_INR <> 0)
END
ELSE
BEGIN
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
		ISNULL(LM.S_Remarks,'') AS S_Remarks,
		ISNULL(LM.I_Brand_ID,0) AS I_Brand_ID,
		ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc,

		ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
		ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
		ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
		ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
		ISNULL(UD.I_Document_ID,0) AS I_Document_ID
	FROM
		-- dbo.T_Course_Center_Detail CCD
		-- LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		-- ON LM.I_Course_ID = CCD.I_Course_ID
		LOGISTICS.T_Logistics_Master LM
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
		LEFT OUTER JOIN dbo.T_Upload_Document UD
		ON LM.I_Document_ID = UD.I_Document_ID
	WHERE
		LM.I_Logistics_Type_ID = COALESCE(@iLogisticsType, LM.I_Logistics_Type_ID)
		AND LM.S_Item_Grade = COALESCE(@sItemGrade, LM.S_Item_Grade)
		AND LM.S_Item_Code LIKE '%' + COALESCE(@sItemCode, LM.S_Item_Code) + '%'
		AND LM.S_Item_Desc LIKE '%' + COALESCE(@sItemName, LM.S_Item_Desc) + '%'
		--AND LM.I_Course_ID = COALESCE(@CourseID, LM.I_Course_ID)
		AND LM.I_Brand_ID = COALESCE(@iBrandID, LM.I_Brand_ID)
		--AND (LM.I_Item_Price_INR IS NOT NULL OR LM.I_Item_Price_USD IS NOT NULL)
		--AND (LM.I_Item_Price_INR <> 0)
END
END

ELSE
BEGIN
IF (@CourseID IS NOT NULL)
BEGIN
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
		ISNULL(LM.S_Remarks,'') AS S_Remarks,
		ISNULL(LM.I_Brand_ID,0) AS I_Brand_ID,
		ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc,
		

		ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
		ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
		ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
		ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
		ISNULL(UD.I_Document_ID,0) AS I_Document_ID
	FROM
		dbo.T_Course_Center_Detail CCD
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON LM.I_Course_ID = CCD.I_Course_ID
		--LOGISTICS.T_Logistics_Master LM
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
		LEFT OUTER JOIN dbo.T_Upload_Document UD
		ON LM.I_Document_ID = UD.I_Document_ID
	WHERE
		CCD.I_Centre_Id = COALESCE(@iCenterID, CCD.I_Centre_Id)
		AND LM.I_Logistics_Type_ID = COALESCE(@iLogisticsType, LM.I_Logistics_Type_ID)
		AND LM.S_Item_Grade = COALESCE(@sItemGrade, LM.S_Item_Grade)
		AND LM.S_Item_Code LIKE '%' + COALESCE(@sItemCode, LM.S_Item_Code) + '%'
		AND LM.S_Item_Desc LIKE '%' + COALESCE(@sItemName, LM.S_Item_Desc) + '%'
		AND LM.I_Course_ID = COALESCE(@CourseID, LM.I_Course_ID)
		--AND LM.I_Brand_ID = COALESCE(@iBrandID, LM.I_Brand_ID)
		--AND (LM.I_Item_Price_INR IS NOT NULL OR LM.I_Item_Price_USD IS NOT NULL)
		--AND (LM.I_Item_Price_USD <> 0)
END
ELSE
BEGIN
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
		ISNULL(LM.S_Remarks,'') AS S_Remarks,
		ISNULL(LM.I_Brand_ID,0) AS I_Brand_ID,
		ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc,

		ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,
		ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,
		ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,
		ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,
		ISNULL(UD.I_Document_ID,0) AS I_Document_ID
	FROM
		-- dbo.T_Course_Center_Detail CCD
		-- LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		-- ON LM.I_Course_ID = CCD.I_Course_ID
		LOGISTICS.T_Logistics_Master LM
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
		LEFT OUTER JOIN dbo.T_Upload_Document UD
		ON LM.I_Document_ID = UD.I_Document_ID
	WHERE
		LM.I_Logistics_Type_ID = COALESCE(@iLogisticsType, LM.I_Logistics_Type_ID)
		AND LM.S_Item_Grade = COALESCE(@sItemGrade, LM.S_Item_Grade)
		AND LM.S_Item_Code LIKE '%' + COALESCE(@sItemCode, LM.S_Item_Code) + '%'
		AND LM.S_Item_Desc LIKE '%' + COALESCE(@sItemName, LM.S_Item_Desc) + '%'
		--AND LM.I_Course_ID = COALESCE(@CourseID, LM.I_Course_ID)
		--AND LM.I_Brand_ID = COALESCE(@iBrandID, LM.I_Brand_ID)
		--AND (LM.I_Item_Price_INR IS NOT NULL OR LM.I_Item_Price_USD IS NOT NULL)
		--AND (LM.I_Item_Price_USD <> 0)
END
END


END
