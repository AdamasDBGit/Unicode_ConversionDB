/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Logistics Type List From T_Logistics_Type_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetItemType]
AS
BEGIN
	SELECT DISTINCT
		ISNULL(I_Logistics_Type_ID, 0) AS I_Logistics_Type_ID 		
	FROM  LOGISTICS.T_Logistics_Master	
	ORDER BY I_Logistics_Type_ID
END
