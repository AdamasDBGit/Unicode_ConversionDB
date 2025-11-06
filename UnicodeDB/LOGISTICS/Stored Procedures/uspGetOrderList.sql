/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Order List From T_Logistics_Order table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetOrderList]
(
	@iCenterID INT,
	@iStatusID INT
)
AS
BEGIN
	SELECT 
		ISNULL(LO.I_Center_ID, 0) AS I_Center_ID,
  		ISNULL(LO.Order_Date, ' ') AS Order_Date,
		ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount,
		ISNULL(LO.S_Transportation_Mode, ' ') AS S_Transportation_Mode,
		ISNULL(LO.I_Packing_Charges, 0) AS I_Packing_Charges,
		ISNULL(LO.B_Packing_Waiver, 0) AS B_Packing_Waiver,
		ISNULL(LO.I_Transportation_Charges, 0) AS I_Transportation_Charges,
		ISNULL(LO.B_Transportation_Waiver, 0) AS B_Transportation_Waiver,
		ISNULL(LO.B_Free_Item_Flag, 0) AS B_Free_Item_Flag,
		ISNULL(LO.S_Payment_Mode, ' ') AS S_Payment_Mode,
		ISNULL(LO.I_Status_ID, 0) AS I_Status_ID,
		ISNULL(LOI.I_Item_Qty, 0) AS I_Item_Qty,
		ISNULL(LO.I_Packing_Charges, 0) + ISNULL(LO.I_Transportation_Charges, 0) AS I_Discount
	FROM  LOGISTICS.T_Logistics_Order LO
		  LEFT OUTER JOIN LOGISTICS.T_Logistics_Order_Line LOI
		  ON LO.I_Logistic_Order_ID = LOI.I_Logistics_Order_ID
	WHERE 
        I_Center_ID = COALESCE(@iCenterID, I_Center_ID)
		AND I_Status_ID = COALESCE(@iStatusID, I_Status_ID)
END
