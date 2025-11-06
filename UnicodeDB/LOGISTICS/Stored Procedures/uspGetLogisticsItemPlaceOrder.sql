/*
-- =================================================================
-- Author:sanjay
-- Create date:07/31/2007 
-- Description: Select From  [T_Logistics_Master used in GetLogisticsItemList Method in LogisticsBuilder
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspGetLogisticsItemPlaceOrder]
(
	@iCenterID	 INT	= 0	,
	@iLogisticsType INT = 0,	
	@sItemGrade VARCHAR(200)= NULL
)

AS
BEGIN

	SET NOCOUNT OFF;

		SELECT 
			  --'0' AS I_Logistics_ID
			   ISNULL(lOGIS.[I_Logistics_ID],'') AS I_Logistics_ID
			  ,ISNULL(lOGIS.[I_Logistics_Type_ID],'') AS I_Logistic_Type_ID
			  ,ISNULL(lOGIS.[S_SAP_Logistics_ID],'') AS S_SAP_Logistics_ID
			  ,ISNULL(lOGIS.[I_Course_ID],'') AS I_Course_ID
			  ,ISNULL(lOGIS.[I_Module_ID],'') AS I_Module_ID
			  ,ISNULL(lOGIS.[S_Item_Code],'') AS S_Item_Code
			  ,ISNULL(lOGIS.[S_Item_Desc],'') AS S_Item_Desc
			  ,ISNULL(lOGIS.[I_Document_ID],'') AS I_Document_ID
			  ,ISNULL(lOGIS.[I_Item_Price_INR],'0') AS I_Item_Price_INR
			  ,ISNULL(lOGIS.[I_Item_Price_USD],'0') AS I_Item_Price_USD
			  ,ISNULL(lOGIS.[S_Item_Grade],'') AS S_Item_Grade
			  ,ISNULL(lOGIS.[S_Crtd_By],'') AS lOGIS_S_Crtd_By
			  ,ISNULL(lOGIS.[S_Upd_By],'') AS lOGIS_S_Upd_By
			  ,ISNULL(lOGIS.[Dt_Crtd_On],getDAte()) AS lOGIS_Dt_Crtd_On
			  ,ISNULL(lOGIS.[Dt_Upd_On],getDAte()) AS lOGIS_Dt_Upd_On
			  ,ISNULL(LogisType.[S_Logistics_Type_Desc],'') AS S_Logistics_Type_Desc

			FROM [LOGISTICS].[T_Logistics_Master] lOGIS

			LEFT OUTER JOIN  [LOGISTICS].[T_Logistics_Type_Master] LogisType
			ON lOGIS.[I_Logistics_Type_ID] = LogisType.[I_Logistics_Type_ID]
			WHERE 
			lOGIS.[I_Logistics_Type_ID] = COALESCE(@iLogisticsType,lOGIS.[I_Logistics_Type_ID])
			AND 
			lOGIS.[S_Item_Grade] =	COALESCE(@sItemGrade,lOGIS.[S_Item_Grade])
END
