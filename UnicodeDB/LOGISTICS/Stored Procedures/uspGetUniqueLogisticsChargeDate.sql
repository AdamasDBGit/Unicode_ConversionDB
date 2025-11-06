/*
-- =================================================================
-- Author:Chandan Dey
-- Modified By : 
-- Create date:09/24/2007 
-- Description:Select Unique Logistics Charge Date in T_Logistics_ChrgDiscount_Config
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspGetUniqueLogisticsChargeDate]
(
	@iBrand		INT,
	@sDomInt	VARCHAR(50),
	@bChargeDiscount BIT,
	@dtStart	DATETIME,
	@dtEnd		DATETIME
)
AS
BEGIN
IF(@dtEnd IS NOT NULL)
	BEGIN
	SET @dtEnd = DATEADD(dd,1,@dtEnd)
	END

IF (@bChargeDiscount = 'true')
BEGIN
   SELECT 
		Count(*)
   FROM [LOGISTICS].T_Logistics_ChrgDiscount_Config
   WHERE I_Brand_ID = @iBrand
		--AND S_Logistics_Charge_Code LIKE '%' + @sDomInt + '%'
		AND S_Logistics_Charge_Code = @sDomInt
		AND (Dt_Start BETWEEN  @dtStart AND @dtEnd OR Dt_End BETWEEN  @dtStart AND @dtEnd)
END
ELSE 
BEGIN
   SELECT 
		Count(*)
   FROM [LOGISTICS].T_Logistics_Charge_Discount_Co
   WHERE I_Brand_ID = @iBrand
		--AND S_Logistics_Charge_Code LIKE '%' + @sDomInt + '%'
		AND S_Logistics_Charge_Code = @sDomInt
		AND (Dt_Start BETWEEN  @dtStart AND @dtEnd OR Dt_End BETWEEN  @dtStart AND @dtEnd)
END
END
