/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Order List From T_Logistics_Order table
-- Parameter :
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetOrderListNew]
(
@iCenterID INT,
@iStatusID INT = NULL,
@dtFromDate DATETIME = NULL,
@dtToDate DATETIME = NULL,
@iOrderID INT = NULL
)
AS
BEGIN
SELECT

(LO.I_Packing_Charges) AS I_Packing_Charges
,ISNULL(LO.I_Transportation_Charges,0) AS I_Transportation_Charges
,ISNULL(LOI.I_Logistics_Order_ID,0) AS I_Logistics_Order_ID
,ISNULL(SUM(LOI.I_Item_Qty),0) AS I_Item_Qty
,(LO.Order_Date) AS Order_Date
,ISNULL(LO.S_Payment_Mode, ' ') AS S_Payment_Mode
,ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount
,ISNULL(LO.B_Free_Item_Flag, 0) AS B_Free_Item_Flag
,ISNULL(LO.I_Status_ID, 0) AS I_Status_ID
,ISNULL(LP.S_Remarks,'') AS S_Remarks
,ISNULL(LO.I_Center_ID, 0) AS I_Center_ID
,ISNULL(CM.S_Center_Code,0) AS S_Center_Code
,ISNULL(CM.S_Center_Name,0) AS S_Center_Name

FROM LOGISTICS.T_Logistics_Order LO
INNER JOIN LOGISTICS.T_Logistics_Order_Line LOI
ON LO.I_Logistic_Order_ID = LOI.I_Logistics_Order_ID
INNER JOIN LOGISTICS.T_Logistics_Payment LP
ON LP.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
INNER JOIN dbo.T_Centre_Master CM
ON CM.I_Centre_Id = LO.I_Center_ID
WHERE
LO.I_Center_ID = COALESCE(@iCenterID, LO.I_Center_ID)
AND LO.I_Status_ID = COALESCE(@iStatusID, LO.I_Status_ID)
AND LO.Order_Date >= COALESCE(@dtFromDate, LO.Order_Date)
AND LO.Order_Date <= COALESCE(@dtToDate, LO.Order_Date)
AND LO.I_Logistic_Order_ID = COALESCE(@iOrderID, LO.I_Logistic_Order_ID)
AND LO.I_Status_ID NOT IN (11,12)
GROUP BY
LO.I_Packing_Charges
,LO.I_Transportation_Charges
,LOI.I_Logistics_Order_ID
,LO.Order_Date
,LO.S_Payment_Mode
,LO.I_Total_Amount
,LO.B_Free_Item_Flag
,LO.I_Status_ID
,LP.S_Remarks
,LO.I_Center_ID
,CM.S_Center_Code
,CM.S_Center_Name
ORDER BY 
LO.Order_Date DESC
END
