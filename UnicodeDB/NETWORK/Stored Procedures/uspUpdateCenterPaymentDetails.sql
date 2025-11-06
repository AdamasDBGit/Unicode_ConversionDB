-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Inserts/Updates/Deletes the center Payment detals
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateCenterPaymentDetails] 
	@iPaymentID INT = NULL,
	@iCenterID INT = NULL,
	@iPaymentChargesID INT = NULL,
	@iPaymentmodeID INT = NULL,
	@dtChequeDate DATETIME = NULL,
	@dtPaymentDate DATETIME = NULL,
	@sChequeNumber VARCHAR(20) = NULL,
	@sBankname VARCHAR(100) = NULL,
	@sCreditCardNo VARCHAR(20) = NULL,
	@sCreditCardIssuer VARCHAR(100) = NULL,
	@dtCreditCardExpiryDt DATETIME = NULL,
	@dTotalAmount decimal(18,2) = NULL,
	@iTransferToSap bit = NULL,
	@sRemarks VARCHAR(200) = NULL,
	@sReason Varchar(1000) = NULL,
	@iStatus INT = NULL,
	@iPaymentType INT = NULL,
	@sCreatedBy VARCHAR(20) = NULL,
	@dtCreatedOn DATETIME = NULL,
	@iFlag INT
AS
BEGIN

--	for insertion
	IF (@iFlag = 1)
		BEGIN
			INSERT INTO NETWORK.T_Center_Payment_Details
			(I_Centre_Id,
			I_Payment_Charges_ID,
			I_PaymentMode_ID,
			Dt_Cheque_Date,
			Dt_Payment_Date,
			S_Crtd_By,
			S_Cheque_Number,
			S_Bank_Name,
			Dt_Crtd_On,
			S_CreditCard_No,
			S_Credit_Card_Issuer,
			I_Status,
			S_Credit_Card_Expiry,
			D_Total_Amount,
			I_Transfer_To_SAP,
			S_Remarks,
			S_Reason,
			I_Payment_Type
			)
			VALUES
			(
			@iCenterID,
			@iPaymentChargesID,
			@iPaymentmodeID,
			@dtChequeDate,
			@dtPaymentDate,
			@sCreatedBy,
			@sChequeNumber,
			@sBankname,
			@dtCreatedOn,
			@sCreditCardNo,
			@sCreditCardIssuer,
			@iStatus,
			@dtCreditCardExpiryDt,
			@dTotalAmount,
			@iTransferToSap,
			@sRemarks,
			@sReason,
			@iPaymentType
			)

			SELECT @iPaymentID=SCOPE_IDENTITY()
		END
--	For Updation
	ELSE IF (@iFlag = 2)
		BEGIN
			INSERT INTO NETWORK.T_Center_Payment_Details_Audit
			(I_Payment_ID,I_Centre_Id,I_Payment_Charges_ID,I_Payment_Mode,
			 Dt_Payment_Date,S_Crtd_By,Dt_Cheque_Date,S_Upd_By,S_Cheque_Number,
			 Dt_Crtd_On,S_Bank_Name,S_CreditCard_No,Dt_Upd_On,I_Status,
			 S_Credit_Card_Issuer,S_Credit_Card_Expiry,D_Total_Amount,
			 I_Transfer_To_SAP,Dt_From_Date,Dt_To_Date,Dt_Due_Date,S_Reason,S_Remarks,I_Payment_Type)
			SELECT 
			I_Center_Payment_Details_ID,I_Centre_Id,I_Payment_Charges_ID,
			I_PaymentMode_ID,Dt_Payment_Date,S_Crtd_By,Dt_Cheque_Date,
			S_Upd_By,S_Cheque_Number,Dt_Crtd_On,S_Bank_Name,S_CreditCard_No,
			Dt_Upd_On,I_Status,S_Credit_Card_Issuer,S_Credit_Card_Expiry,
			D_Total_Amount,I_Transfer_To_SAP,Dt_Crtd_On,@dtCreatedOn,NULL,S_Reason,S_Remarks,I_Payment_Type
			FROM NETWORK.T_Center_Payment_Details
			WHERE I_Center_Payment_Details_ID = @iPaymentID

			
			UPDATE NETWORK.T_Center_Payment_Details
				SET I_Payment_Charges_ID = @iPaymentChargesID,
					I_PaymentMode_ID = @iPaymentmodeID,
					Dt_Cheque_Date = @dtChequeDate,
					Dt_Payment_Date = @dtPaymentDate,
					S_Cheque_Number = @sChequeNumber,
					S_Upd_By = @sCreatedBy,
					Dt_Upd_On = @dtCreatedOn,
					S_Bank_Name = @sBankname,
					S_CreditCard_No = @sCreditCardNo,
					S_Credit_Card_Issuer = @sCreditCardIssuer,
					I_Status = @iStatus,
					S_Credit_Card_Expiry = @dtCreditCardExpiryDt,
					D_Total_Amount = @dTotalAmount,
					I_Transfer_To_SAP = @iTransferToSap,
					S_Remarks = @sRemarks,
					S_Reason = @sReason,
					I_Payment_Type = @iPaymentType
				WHERE I_Center_Payment_Details_ID = @iPaymentID
		END 
--	For deletion
	ELSE IF (@iFlag = 3)
		BEGIN
			INSERT INTO NETWORK.T_Center_Payment_Details_Audit
			(I_Payment_ID,I_Centre_Id,I_Payment_Charges_ID,I_Payment_Mode,
			 Dt_Payment_Date,S_Crtd_By,Dt_Cheque_Date,S_Upd_By,S_Cheque_Number,
			 Dt_Crtd_On,S_Bank_Name,S_CreditCard_No,Dt_Upd_On,I_Status,
			 S_Credit_Card_Issuer,S_Credit_Card_Expiry,D_Total_Amount,
			 I_Transfer_To_SAP,Dt_From_Date,Dt_To_Date,Dt_Due_Date,S_Reason,S_Remarks,I_Payment_Type)
			SELECT 
			I_Center_Payment_Details_ID,I_Centre_Id,I_Payment_Charges_ID,
			I_PaymentMode_ID,Dt_Payment_Date,S_Crtd_By,Dt_Cheque_Date,
			S_Upd_By,S_Cheque_Number,Dt_Crtd_On,S_Bank_Name,S_CreditCard_No,
			Dt_Upd_On,I_Status,S_Credit_Card_Issuer,S_Credit_Card_Expiry,
			D_Total_Amount,I_Transfer_To_SAP,Dt_Crtd_On,@dtCreatedOn,NULL,S_Reason,S_Remarks,I_Payment_Type
			FROM NETWORK.T_Center_Payment_Details
			WHERE I_Center_Payment_Details_ID = @iPaymentID

			
			UPDATE NETWORK.T_Center_Payment_Details
				SET I_Status = 0,
					S_Upd_By = @sCreatedBy,
					Dt_Upd_On = @dtCreatedOn
				WHERE I_Center_Payment_Details_ID = @iPaymentID
		END 
		 
	SELECT 	@iPaymentID AS PaymentID

END
