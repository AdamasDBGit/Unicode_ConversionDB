/*
-- =================================================================
-- Author:Avirup Das
-- Create date:31/07/2007
-- Description:Get Order Status From T_Logistics_Order table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspGetOrderStatus]
(
	--@iCenterID INT = NULL,
	@iLogisticsOrderID INT = NULL,
	@iOrderID INT = NULL,	
	@iCenterID INT,
	--@iStatusID INT = NULL,
	@dtFromDate DATETIME = NULL,
	@dtToDate DATETIME = NULL
)
AS
BEGIN
IF(@dtToDate IS NOT NULL)
	BEGIN
	SET @dtTodate = DATEADD(dd,1,@dtTodate)
	END

IF (@iOrderID IS NULL)
BEGIN
	SELECT
		DISTINCT(ISNULL(LO.I_Logistic_Order_ID, 0)) AS I_Logistics_Order_ID,
  		ISNULL(LO.I_Status_ID,0) AS I_Status_ID,
		ISNULL(LDI.I_Despatch_ID, 0) AS I_Despatch_ID,
		ISNULL(LDI.I_Courier_ID, ' ') AS I_Courier_ID,
		ISNULL(LDI.Dt_Despatch_Date,' ') AS Dt_Despatch_Date,
		ISNULL(LDI.Dt_Exp_Delivery_Date,' ') AS Dt_Exp_Delivery_Date,
		ISNULL(LDI.S_Docket_No, ' ') AS S_Docket_No,
		ISNULL(LDI.S_Remarks,' ') AS S_Remarks,
		ISNULL(LDI.Dt_Act_Delivery_Date,' ') AS Dt_Act_Delivery_Date,
		ISNULL(LDI.S_Air_Bill_No,' ') AS S_Air_Bill_No,
		ISNULL(LDI.S_Transporter,' ') AS S_Transporter,
		ISNULL(TCM.S_Courier_Name,' ') AS S_Courier_Name,		
		ISNULL(TCM.S_Courier_Code,' ') AS S_Courier_Code,
		ISNULL(LO.Order_Date, '') AS Order_Date
	FROM  [LOGISTICS].T_Logistics_Order LO
		  --Left Outer Join [LOGISTICS].T_Logistics_Line_Despatch LLD
		  --ON LO.I_Logistic_Order_ID = LLD.I_Logistics_Order_ID
		  Left Outer Join [LOGISTICS].T_Logistics_Despatch_Info LDI
		  ON LDI.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		  Left Outer Join dbo.T_Courier_Master TCM
	      ON TCM.I_Courier_ID = LDI.I_Courier_ID
	WHERE 
        LO.I_Logistic_Order_ID = COALESCE(@iOrderID, LO.I_Logistic_Order_ID) 
		--AND LO.I_Status_ID = COALESCE(@iStatusID, LO.I_Status_ID)
        AND LO.I_Center_ID = COALESCE(@iCenterID, LO.I_Center_ID)
		AND LO.Order_Date >= COALESCE(@dtFromDate, LO.Order_Date)
		AND LO.Order_Date <= COALESCE(@dtToDate, LO.Order_Date)
		
END
ELSE
BEGIN
	SELECT 
		DISTINCT(ISNULL(LO.I_Logistic_Order_ID, 0)) AS I_Logistics_Order_ID,
  		ISNULL(LO.I_Status_ID,0) AS I_Status_ID,
		ISNULL(LDI.I_Despatch_ID, 0) AS I_Despatch_ID,
		ISNULL(LDI.I_Courier_ID, ' ') AS I_Courier_ID,
		ISNULL(LDI.Dt_Despatch_Date,' ') AS Dt_Despatch_Date,
		ISNULL(LDI.Dt_Exp_Delivery_Date,' ') AS Dt_Exp_Delivery_Date,
		ISNULL(LDI.S_Docket_No, '') AS S_Docket_No,
		ISNULL(LDI.S_Remarks,' ') AS S_Remarks,
		ISNULL(LDI.Dt_Act_Delivery_Date,' ') AS Dt_Act_Delivery_Date,
		ISNULL(LDI.S_Air_Bill_No,' ') AS S_Air_Bill_No,
		ISNULL(LDI.S_Transporter,' ') AS S_Transporter,
		ISNULL(TCM.S_Courier_Name,' ') AS S_Courier_Name,
		ISNULL(TCM.S_Courier_Code,' ') AS S_Courier_Code,
		ISNULL(LO.Order_Date, '') AS Order_Date
	FROM  [LOGISTICS].T_Logistics_Order LO
		  Left Outer Join [LOGISTICS].T_Logistics_Line_Despatch LLD
		  ON LO.I_Logistic_Order_ID = LLD.I_Logistics_Order_ID
		  Left Outer Join [LOGISTICS].T_Logistics_Despatch_Info LDI
		  ON LDI.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		  Left Outer Join dbo.T_Courier_Master TCM
	      ON TCM.I_Courier_ID = LDI.I_Courier_ID
	WHERE
        LO.I_Logistic_Order_ID = COALESCE(@iOrderID, LO.I_Logistic_Order_ID) 
		--LO.I_Status_ID = COALESCE(@iStatusID, LO.I_Status_ID)
        AND LO.I_Center_ID = COALESCE(@iCenterID, LO.I_Center_ID)
		AND LO.Order_Date >= COALESCE(@dtFromDate, LO.Order_Date)
		AND LO.Order_Date <= COALESCE(@dtToDate, LO.Order_Date)
END
END
