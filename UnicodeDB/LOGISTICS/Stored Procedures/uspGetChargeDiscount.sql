/*
-- =================================================================
-- Author:sanjay mitra
-- Create date:07/31/2007 
-- Description: Select Discount Charge From  [T_Logistics_ChrgDiscount_Config]
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspGetChargeDiscount]
(
	@BrandID	 INT	= 0,
	@iDomInt	 INT,
	@CurrentDate DATETIME = NULL
)

AS
BEGIN
SET NOCOUNT OFF;
IF (@iDomInt = 0)
BEGIN
	SELECT DISTINCT
		   ISNULL(lOGIS.[I_Brand_ID],'0') AS I_Brand_ID
		  ,ISNULL(lOGIS.[S_Logistics_Charge_Code],'') AS S_Logistics_Charge_Code
		  ,ISNULL(lOGIS.[S_Logistics_Charge_Desc],'') AS S_Logistics_Charge_Desc
		  ,ISNULL(lOGIS.[Dt_Start],'') AS Dt_Start
		  ,ISNULL(lOGIS.[Dt_End],'') AS Dt_End
		  ,ISNULL(lOGIS.[I_Amount],'0') AS I_Amount
		  ,ISNULL(lOGIS.[S_Crtd_By],'') AS lOGIS_S_Crtd_By
		  ,ISNULL(lOGIS.[S_Upd_By],'') AS lOGIS_S_Upd_By
		  ,ISNULL(lOGIS.[Dt_Crtd_On],getDAte()) AS lOGIS_Dt_Crtd_On
		  ,ISNULL(lOGIS.[Dt_Upd_On],getDAte()) AS lOGIS_Dt_Upd_On

		FROM [LOGISTICS].[T_Logistics_ChrgDiscount_Config] lOGIS
		WHERE 
		lOGIS.[I_Brand_ID] = COALESCE(@BrandID,lOGIS.[I_Brand_ID])
		AND lOGIS.[S_Logistics_Charge_Code] LIKE '%' + 'DOM_' + '%'
		AND lOGIS.Dt_Start <= COALESCE(@CurrentDate, lOGIS.Dt_Start)
		AND lOGIS.Dt_End >= COALESCE(@CurrentDate, lOGIS.Dt_End)
END
ELSE
BEGIN
	SELECT DISTINCT
		   ISNULL(lOGIS.[I_Brand_ID],'0') AS I_Brand_ID
		  ,ISNULL(lOGIS.[S_Logistics_Charge_Code],'') AS S_Logistics_Charge_Code
		  ,ISNULL(lOGIS.[S_Logistics_Charge_Desc],'') AS S_Logistics_Charge_Desc
		  ,ISNULL(lOGIS.[Dt_Start],'') AS Dt_Start
		  ,ISNULL(lOGIS.[Dt_End],'') AS Dt_End
		  ,ISNULL(lOGIS.[I_Amount],'0') AS I_Amount
		  ,ISNULL(lOGIS.[S_Crtd_By],'') AS lOGIS_S_Crtd_By
		  ,ISNULL(lOGIS.[S_Upd_By],'') AS lOGIS_S_Upd_By
		  ,ISNULL(lOGIS.[Dt_Crtd_On],getDate()) AS lOGIS_Dt_Crtd_On
		  ,ISNULL(lOGIS.[Dt_Upd_On],getDate()) AS lOGIS_Dt_Upd_On

		FROM [LOGISTICS].[T_Logistics_ChrgDiscount_Config] lOGIS
		WHERE 
		lOGIS.[I_Brand_ID] = COALESCE(@BrandID,lOGIS.[I_Brand_ID])
		AND lOGIS.[S_Logistics_Charge_Code] LIKE '%' + 'INT_' + '%'
		AND lOGIS.Dt_Start <= COALESCE(@CurrentDate, lOGIS.Dt_Start)
		AND lOGIS.Dt_End >= COALESCE(@CurrentDate, lOGIS.Dt_End)
END
END
