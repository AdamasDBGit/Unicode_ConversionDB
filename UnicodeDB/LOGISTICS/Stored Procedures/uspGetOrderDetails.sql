/*
-- =================================================================
-- Author:Avirup Das
-- Create date:31/07/2007
-- Description:Get Order Details From T_Logistics_Order table
-- Parameter : 
-- =================================================================
*/

CREATE  PROCEDURE [LOGISTICS].[uspGetOrderDetails]
(
	@iLogisticsOrderID INT = 0
)
AS
BEGIN
IF (@iLogisticsOrderID != 0)
BEGIN
	SELECT 
		ISNULL(LO.I_Logistic_Order_ID, 0) AS I_Logistics_Order_ID,
  		ISNULL(LO.I_Status_ID,0) AS I_Status_ID,
		ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount,
		ISNULL(LOL.I_Item_Qty, 0) AS I_Item_Qty,
		ISNULL(LM.S_Item_Code,' ') AS S_Item_Code,
		ISNULL(LM.S_Item_Desc, ' ') AS S_Item_Desc		
	FROM  [LOGISTICS].T_Logistics_Order LO
		  Left Outer Join [LOGISTICS].T_Logistics_Order_Line LOL
		  ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID
		  Left Outer Join [LOGISTICS].T_Logistics_Master LM
		  ON LOL.I_Logistics_ID = LM.I_Logistics_ID		  
	WHERE 
        LO.I_Logistic_Order_ID = COALESCE(@iLogisticsOrderID, I_Logistics_Order_ID)
		
END
ELSE
BEGIN
	SELECT 
		ISNULL(LO.I_Logistic_Order_ID, 0) AS I_Logistics_Order_ID,
  		ISNULL(LO.I_Status_ID,0) AS I_Status_ID,
		ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount,
		ISNULL(LOL.I_Item_Qty, 0) AS I_Item_Qty,
		ISNULL(LM.S_Item_Code,' ') AS S_Item_Code,
		ISNULL(LM.S_Item_Desc, ' ') AS S_Item_Desc			
	FROM  [LOGISTICS].T_Logistics_Order LO
		  Left Outer Join [LOGISTICS].T_Logistics_Order_Line LOL
		  ON LO.I_Logistic_Order_ID = LOL.I_Logistics_Order_ID
		  Left Outer Join [LOGISTICS].T_Logistics_Master LM
		  ON LOL.I_Logistics_ID = LM.I_Logistics_ID		  
END
END
