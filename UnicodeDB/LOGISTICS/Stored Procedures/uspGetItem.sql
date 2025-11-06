/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Kit Details From T_Kit_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetItem]
AS
BEGIN
	SELECT 
		ISNULL(LM.I_Logistics_ID, '') AS I_Logistics_ID,
  		ISNULL(LM.S_Item_Code, '') AS S_Item_Code,
		ISNULL(LM.S_Item_Desc, '') AS S_Item_Desc,
		ISNULL(LTM.S_Logistics_Type_Desc, '') AS S_Logistics_Type_Desc
	FROM  LOGISTICS.T_Logistics_Master LM
		  INNER JOIN LOGISTICS.T_Logistics_Type_Master LTM
		  ON LM.I_Logistics_Type_ID = LTM.I_Logistics_Type_ID
END
