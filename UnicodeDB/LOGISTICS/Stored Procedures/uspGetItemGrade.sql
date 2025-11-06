/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Item Grade List From T_Logistics_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetItemGrade]
AS
BEGIN
	SELECT DISTINCT		
  		ISNULL(S_Item_Grade, ' ') AS S_Item_Grade
	FROM  LOGISTICS.T_Logistics_Master
	ORDER BY S_Item_Grade
END
