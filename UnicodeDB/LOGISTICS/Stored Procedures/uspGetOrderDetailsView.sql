/*
-- =================================================================
-- Author:Beas
-- Create date:21/07/2009
-- Description:Get Order details
-- Parameter :
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetOrderDetailsView]
(
@iLogisticsOrderId INT
)
AS
BEGIN
SELECT

(LOI.I_Logistics_Order_ID) AS I_Logistics_Order_ID
,ISNULL(LOI.I_Logistics_ID,0) AS I_Logistics_ID
,ISNULL(LOI.I_Item_Qty,0) AS I_Item_Qty
,ISNULL(LOI.I_Item_Amount,0) AS I_Item_Amount
,ISNULL(LM.S_Item_Code,' ') AS S_Item_Code
,ISNULL(LM.S_Item_Desc,' ') AS S_Item_Desc
,ISNULL(LM.I_Item_Price_INR,0) AS I_Item_Price_INR
,ISNULL(LM.I_Item_Price_USD,0) AS I_Item_Price_USD
,ISNULL(LM.S_Item_Grade,' ') AS S_Item_Grade


FROM LOGISTICS.T_Logistics_Order_Line LOI

INNER JOIN LOGISTICS.T_Logistics_Master LM
ON LM.I_Logistics_ID = LOI.I_Logistics_ID

WHERE
LOI.I_Logistics_Order_ID = COALESCE(@iLogisticsOrderId, LOI.I_Logistics_Order_ID)
END
