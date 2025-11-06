/*
-- =================================================================
-- Author: Chandan Dey
-- Create date:14/11/2007 
-- Description: 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspGetLogisticsOrderLine]
(
	@iOrderID	 INT = NULL,
	@iStatusID INT = NULL
)

AS
BEGIN
SET NOCOUNT OFF;
	SELECT DISTINCT
		ISNULL(LM.I_Logistics_ID,0) AS I_Logistics_ID,
		ISNULL(LM.I_Logistics_Type_ID,0) AS I_Logistic_Type_ID,
		ISNULL(LM.I_Logistics_ID,0) AS I_Logistics_ID,
		ISNULL(LM.S_Item_Code,'') AS S_Item_Code,
		ISNULL(LM.S_Item_Desc,'') AS S_Item_Desc,
		ISNULL(LOL.I_Sl_No,0) AS I_Sl_No,
		ISNULL(LOL.I_Item_Amount,0) AS I_Item_Amount,
		ISNULL(LM.S_Item_Grade,'') AS S_Item_Grade,
		ISNULL(LOL.I_Item_Qty,0) AS I_Item_Qty,
		ISNULL(LTM.S_Logistics_Type_Desc,'') AS S_Logistics_Type_Desc
	FROM
		LOGISTICS.T_Logistics_Order LO
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Order_Line LOL
		ON LOL.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		ON LM.I_Logistics_ID = LOL.I_Logistics_ID
		LEFT OUTER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		ON LTM.I_Logistics_Type_ID = LM.I_Logistics_Type_ID
	WHERE
		LOL.I_Logistics_Order_ID = @iOrderID
		AND LO.I_Status_ID = @iStatusID
END
