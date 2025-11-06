/*******************************************************************************************************
* Author		: BabinSaha
* Create date	: 16/08/2007
* Description	: Get the actual data for MBP depends upon type id 
* Return		: Value Integer
*******************************************************************************************************/
CREATE FUNCTION [REPORT].[fnGetMBPActualPerformance]
(
	@iCenterID  INT
	,@iMonth	INT
	,@iYear		INT
	,@iType		INT
	,@iProductID	INT
)
RETURNS INT

AS
BEGIN
	DECLARE @Value INT 
	IF @iType =1
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Actual_Enquiry),0)
		FROM MBP.T_MBPerformance
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Product_ID = @iProductID)
	END
	IF @iType =2
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Actual_Enrollment),0)
		FROM MBP.T_MBPerformance
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Product_ID = @iProductID)
	END
	IF @iType =3
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Actual_Booking),0)
		FROM MBP.T_MBPerformance
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Product_ID = @iProductID)
	END
	IF @iType =4
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Actual_Billing),0)
		FROM MBP.T_MBPerformance
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Product_ID = @iProductID)
	END
	IF @iType =5
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Actual_RFF),0)
		FROM MBP.T_MBPerformance
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Product_ID = @iProductID)
	END
Return @Value
END