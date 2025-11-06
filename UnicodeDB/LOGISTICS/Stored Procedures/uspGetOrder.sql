/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:07/02/2008
-- Description:Get Order From T_Logistics_Order table
-- Parameter :  
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetOrder]
(
	@iOrderID INT
)
AS
BEGIN
	SELECT
		 (LO.I_Packing_Charges) AS I_Packing_Charges
		 ,ISNULL(LO.I_Transportation_Charges,0) AS I_Transportation_Charges
		 ,ISNULL(LO.I_Logistic_Order_ID,0) AS I_Logistic_Order_ID
		 ,(LO.Order_Date) AS Order_Date
		 ,ISNULL(LO.S_Payment_Mode, '') AS S_Payment_Mode
		 ,ISNULL(LO.I_Total_Amount, 0) AS I_Total_Amount
		 ,ISNULL(LO.B_Free_Item_Flag, 0) AS B_Free_Item_Flag
		 ,ISNULL(LO.I_Status_ID, 0) AS I_Status_ID
		 ,ISNULL(CM.S_Center_Code,0) AS S_Center_Code
		 ,ISNULL(CM.S_Center_Name,0) AS S_Center_Name

		 ,ISNULL(LP.S_DD_Cheque_No,'') AS S_DD_Cheque_No
		 ,ISNULL(LP.S_Bank_Name,'') AS S_Bank_Name
		 ,ISNULL(LP.S_Branch_Name,'') AS S_Branch_Name
		 ,(LP.Dt_Issue_Date) AS Dt_Issue_Date
		 ,ISNULL(LP.S_Payable_At, '') AS S_Payable_At
		 ,ISNULL(LP.I_Payment_Amount_INR, 0) AS I_Payment_Amount_INR
		 ,ISNULL(LP.I_Payment_Amount_USD, 0) AS I_Payment_Amount_USD
		 ,ISNULL(LP.S_Remarks,0) AS S_Remarks

		 ,(LD.Dt_Despatch_Date) AS Dt_Despatch_Date
		 ,(LD.Dt_Exp_Delivery_Date) AS Dt_Exp_Delivery_Date
		 ,ISNULL(LD.S_Docket_No,'') AS S_Docket_No
		 ,ISNULL(LD.S_Air_Bill_No,'') AS S_Air_Bill_No
		 ,ISNULL(LD.S_Transporter,'') AS S_Transporter
		 ,ISNULL(LD.Dt_Despatch_Date,'') AS Dt_Despatch_Date
		 ,ISNULL(LD.S_Remarks,'') AS S_Despatch_Remarks
		 ,(LD.Dt_Act_Delivery_Date) AS Dt_Act_Delivery_Date
		 ,(CU.S_Courier_Name) AS S_Courier_Name

	FROM LOGISTICS.T_Logistics_Order LO
		 LEFT OUTER JOIN LOGISTICS.T_Logistics_Payment LP
		 ON LP.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		 LEFT OUTER JOIN dbo.T_Centre_Master CM
		 ON CM.I_Centre_Id = LO.I_Center_ID
		 LEFT OUTER JOIN LOGISTICS.T_Logistics_Despatch_Info LD
		 ON LD.I_Logistics_Order_ID = LO.I_Logistic_Order_ID
		 LEFT OUTER JOIN dbo.T_Courier_Master CU
		 ON CU.I_Courier_ID = LD.I_Courier_ID
	WHERE
         LO.I_Logistic_Order_ID = COALESCE(@iOrderID, LO.I_Logistic_Order_ID)
END




SET ANSI_NULLS ON
