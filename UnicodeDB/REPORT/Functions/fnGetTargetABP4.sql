/*******************************************************************************************************
* Author		: BabinSaha
* Create date	: 16/08/2007
* Description	: Get the target data of ABP plan of center 
* Return		: Value Integer
*******************************************************************************************************/
CREATE FUNCTION [REPORT].[fnGetTargetABP4]
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
	DECLARE @Value INT ,@MBPDetailID INT
	SET @MBPDetailID =0
	IF @iType =1
	BEGIN
		SET @Value = (SELECT 
		ISNULL(SUM(I_Target_Enquiry),0)
		FROM MBP.T_MBP_Detail
		WHERE I_Month =@iMonth
		AND I_Year = @iYear
		AND I_Center_ID =@iCenterID
		AND I_Type_ID=@iTypeID
		AND	I_Product_ID=@iProductID
		)
		IF @Value = 0 
		BEGIN
			IF NOT EXISTS (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail	WHERE I_Month =@iMonth	AND I_Year = @iYear	AND I_Center_ID =@iCenterID	AND I_Type_ID=@iTypeID	AND	I_Product_ID=@iProductID)
			BEGIN
				SET @Value = (SELECT 
				ISNULL(I_Target_Enquiry,0)
				FROM MBP.T_MBP_Detail_Audit
				WHERE I_Month =@iMonth
				AND I_Year = @iYear
				AND I_Center_ID =@iCenterID
				AND I_Type_ID=@iTypeID
				AND	I_Product_ID=@iProductID
				AND I_MBP_Detail_Audit_ID=(SELECT MAX(I_MBP_Detail_Audit_ID) FROM MBP.T_MBP_Detail_Audit)
				)
			END
		END
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
		AND	I_Product_ID=@iProductID
		)
		IF @Value = 0 
		BEGIN
			IF NOT EXISTS (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail	WHERE I_Month =@iMonth	AND I_Year = @iYear	AND I_Center_ID =@iCenterID	AND I_Type_ID=@iTypeID	AND	I_Product_ID=@iProductID)
			BEGIN
				SET @Value = (SELECT 
				ISNULL(I_Target_Enrollment,0)
				FROM MBP.T_MBP_Detail_Audit
				WHERE I_Month =@iMonth
				AND I_Year = @iYear
				AND I_Center_ID =@iCenterID
				AND I_Type_ID=@iTypeID
				AND	I_Product_ID=@iProductID
				AND I_MBP_Detail_Audit_ID=(SELECT MAX(I_MBP_Detail_Audit_ID) FROM MBP.T_MBP_Detail_Audit)
				)
			END
		END
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
		AND	I_Product_ID=@iProductID
		)
		IF @Value = 0 
		BEGIN
			IF NOT EXISTS (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail	WHERE I_Month =@iMonth	AND I_Year = @iYear	AND I_Center_ID =@iCenterID	AND I_Type_ID=@iTypeID	AND	I_Product_ID=@iProductID)
			BEGIN
				SET @Value = (SELECT 
				ISNULL(I_Target_Booking,0)
				FROM MBP.T_MBP_Detail_Audit
				WHERE I_Month =@iMonth
				AND I_Year = @iYear
				AND I_Center_ID =@iCenterID
				AND I_Type_ID=@iTypeID
				AND	I_Product_ID=@iProductID
				AND I_MBP_Detail_Audit_ID=(SELECT MAX(I_MBP_Detail_Audit_ID) FROM MBP.T_MBP_Detail_Audit)
				)
			END
		END
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
		AND	I_Product_ID=@iProductID
		)
		IF @Value = 0 
		BEGIN
			IF NOT EXISTS (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail	WHERE I_Month =@iMonth	AND I_Year = @iYear	AND I_Center_ID =@iCenterID	AND I_Type_ID=@iTypeID	AND	I_Product_ID=@iProductID)
			BEGIN
				SET @Value = (SELECT 
				ISNULL(I_Target_Billing,0)
				FROM MBP.T_MBP_Detail_Audit
				WHERE I_Month =@iMonth
				AND I_Year = @iYear
				AND I_Center_ID =@iCenterID
				AND I_Type_ID=@iTypeID
				AND	I_Product_ID=@iProductID
				AND I_MBP_Detail_Audit_ID=(SELECT MAX(I_MBP_Detail_Audit_ID) FROM MBP.T_MBP_Detail_Audit)
				)
			END
		END
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
		AND	I_Product_ID=@iProductID
		)
		IF @Value = 0 
		BEGIN
			IF NOT EXISTS (SELECT I_MBP_Detail_ID FROM MBP.T_MBP_Detail	WHERE I_Month =@iMonth	AND I_Year = @iYear	AND I_Center_ID =@iCenterID	AND I_Type_ID=@iTypeID	AND	I_Product_ID=@iProductID)
			BEGIN
				SET @Value = (SELECT 
				ISNULL(I_Target_RFF,0)
				FROM MBP.T_MBP_Detail_Audit
				WHERE I_Month =@iMonth
				AND I_Year = @iYear
				AND I_Center_ID =@iCenterID
				AND I_Type_ID=@iTypeID
				AND	I_Product_ID=@iProductID
				AND I_MBP_Detail_Audit_ID=(SELECT MAX(I_MBP_Detail_Audit_ID) FROM MBP.T_MBP_Detail_Audit)
				)
			END
		END
	END
-- end add
Return @Value
END