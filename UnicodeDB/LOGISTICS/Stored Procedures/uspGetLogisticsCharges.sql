/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:04/08/2007
-- Description:Get Logistics Chrgarges Discount Config From T_Logistics_ChrgDiscount_Config table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetLogisticsCharges]
(
	@BrandID INT
)
AS
BEGIN
	SELECT
		ISNULL(LCC.I_Logistic_Charge_ID, 0) AS I_Logistic_Charge_ID,
  		ISNULL(LCC.I_Brand_ID, 0) AS I_Brand_ID,
		ISNULL(LCC.S_Logistics_Charge_Code, 0) AS S_Logistics_Charge_Code,
		ISNULL(LCC.S_Logistics_Charge_Desc, ' ') AS S_Logistics_Charge_Desc,
		ISNULL(LCC.I_Amount, 0) AS I_Amount
	FROM  T_Logistics_ChrgDiscount_Config LCC
	WHERE
        LCC.I_Brand_ID = COALESCE(@BrandID, LCC.I_Brand_ID)
END
