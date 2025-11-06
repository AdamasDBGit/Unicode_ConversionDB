/*******************************************************************************************************
* Author		: BabinSaha
* Create date	: 16/08/2007
* Description	: Get MBP details from MBP table
* Return		: Value Integer
*******************************************************************************************************/
CREATE FUNCTION [REPORT].[fnGetTargetMBP5]
(
	@iCenterID  INT
	,@iMonth	INT
	,@iYear		INT
	,@iType		INT
	,@iTypeID	INT
	,@iProductID	INT
)
RETURNS INT

AS
BEGIN
	DECLARE @Value INT 
	IF @iType =1
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Target_Enquiry),0)
		FROM MBP.T_MBP_Detail
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Type_ID=@iTypeID
		AND I_Product_ID=@iProductID)
	END
	IF @iType =2
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Target_Enrollment),0)
		FROM MBP.T_MBP_Detail
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Type_ID=@iTypeID
		AND I_Product_ID=@iProductID)
	END
	IF @iType =3
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Target_Booking),0)
		FROM MBP.T_MBP_Detail
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Type_ID=@iTypeID
		AND I_Product_ID=@iProductID)
	END
	IF @iType =4
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Target_Billing),0)
		FROM MBP.T_MBP_Detail
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Type_ID=@iTypeID
		AND I_Product_ID=@iProductID)
	END
--add sanju
	IF @iType =5
		BEGIN
			SET @Value = (SELECT 
			ISNULL(SUM(I_Target_RFF),0)
			FROM MBP.T_MBP_Detail
			WHERE I_Month =@iMonth
			AND I_Year = @iYear
			AND I_Center_ID =@iCenterID
			AND I_Type_ID=@iTypeID
			AND I_Product_ID=@iProductID)
		END
--end add
Return @Value
END