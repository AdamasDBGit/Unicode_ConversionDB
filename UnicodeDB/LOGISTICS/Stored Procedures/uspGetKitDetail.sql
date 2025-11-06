/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Kit Details From T_Kit_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetKitDetail]
(
	@iKitID INT
)
AS
BEGIN
	SELECT 
		ISNULL(LM.I_Logistics_ID, 0) AS I_Logistics_ID,
  		ISNULL(KL.I_Kit_Qty, 0) AS I_Kit_Qty,
		ISNULL(LTM.I_Logistics_Type_ID, 0) AS I_Logistics_Type_ID,
		ISNULL(LTM.S_Logistics_Type_Desc, ' ') AS S_Logistics_Type_Desc,
		ISNULL(LM.S_Item_Code, ' ') AS S_Item_Code,
		ISNULL(LM.S_Item_Desc, ' ') AS S_Item_Desc
	FROM  LOGISTICS.T_Kit_Logistics KL
	      LEFT OUTER JOIN LOGISTICS.T_Logistics_Master LM
		  ON KL.I_Logistics_ID = LM.I_Logistics_ID
		  INNER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		  ON LM.I_Logistics_Type_ID = LTM.I_Logistics_Type_ID
	WHERE 
        KL.I_Kit_ID = COALESCE(@iKitID, KL.I_Kit_ID)
END
