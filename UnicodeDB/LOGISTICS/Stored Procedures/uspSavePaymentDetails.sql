/*
-- =================================================================
-- Author:sa
-- Create date:01/08/2007
-- Description:Insert order details  [LOGISTICS].[uspSaveALLOrderDetails]
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspSavePaymentDetails]
(		
		 @iLogisticsOrderID INT = NULL
		,@sDDChequeNo VARCHAR(20) = NULL
		,@sBankName VARCHAR(20) = NULL
		,@sBranchName VARCHAR(20) = NULL
		,@sPayableAt VARCHAR(20) = NULL
		,@iPaymentAmountINR INT = NULL
		,@iPaymentAmountUSD INT = NULL
		,@dtIssueDate DATETIME = NULL
		,@sRemarks VARCHAR(20) = NULL
		,@sCrtdBy VARCHAR(20) = NULL
		,@sUpdBy VARCHAR(20) = NULL
		,@dtCrtdOn DATETIME = NULL
		,@dtUpdOn DATETIME =NULL


)
AS
BEGIN TRY
SET NOCOUNT OFF;
	
	INSERT INTO [LOGISTICS].[T_Logistics_Payment]
		(
		I_Logistics_Order_ID
		,S_DD_Cheque_No
		,S_Bank_Name
		,S_Branch_Name
		,S_Payable_At
		,I_Payment_Amount_INR
		,I_Payment_Amount_USD
		,Dt_Issue_Date
		,S_Remarks
		,S_Crtd_By
		,S_Upd_By
		,Dt_Crtd_On
		,Dt_Upd_On
		)
		VALUES
		(
		 @iLogisticsOrderID 
		,@sDDChequeNo 
		,@sBankName
		,@sBranchName 
		,@sPayableAt
		,@iPaymentAmountINR 
		,@iPaymentAmountUSD 
		,@dtIssueDate 
		,@sRemarks 
		,@sCrtdBy
		,@sUpdBy
		,@dtCrtdOn 
		,@dtUpdOn 
		)

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
