-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for all center Payments
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterPayments]
	@iCenterID INT =NULL		
AS
BEGIN
	SET NOCOUNT OFF;
	
	SELECT I_Center_Payment_Details_ID,
		   I_Centre_Id,
		   I_Payment_Charges_ID,
		   I_PaymentMode_ID,
		   Dt_Cheque_Date,
		   Dt_Payment_Date,
		   S_Cheque_Number,
		   S_Bank_Name,
		   S_CreditCard_No,
		   S_Credit_Card_Issuer,
		   S_Credit_Card_Expiry,
		   D_Total_Amount,
		   I_Transfer_To_SAP,
		   S_Remarks,
		   S_Reason,
		   I_Status,
		   I_Payment_Type
	FROM NETWORK.T_Center_Payment_Details
	WHERE ISNULL(@iCenterID,I_Centre_Id) = I_Centre_Id
		AND I_Status <> 0
	
END
