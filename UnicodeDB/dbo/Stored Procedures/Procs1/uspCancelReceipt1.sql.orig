/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 12/04/2007
Description: Deletes a receipt header and corresponding details
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspCancelReceipt1]
(
	@iReceiptHeaderId int,
	@sCancellationReason varchar(500)
)

AS

BEGIN TRY
		DECLARE @iInvoiceHeaderID INT
		DECLARE @dtInvoiceDate DateTime
		DECLARE @dtReceiptDate DateTime
		DECLARE @iStudentDetailID INT
		DECLARE @iCenterID INT

		BEGIN TRANSACTION
		
		SELECT @iInvoiceHeaderID = RH.I_Invoice_Header_ID, @dtReceiptDate = RH.Dt_Receipt_Date 
		FROM T_Receipt_Header RH
		INNER JOIN dbo.T_Invoice_Parent IP
		ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
		WHERE RH.I_Receipt_Header_ID = @iReceiptHeaderId
		AND IP.I_Status <> 0

		select 0
			
		UPDATE T_Receipt_Header
		SET I_Status=0,
			S_Cancellation_Reason = @sCancellationReason,
			S_Fund_Transfer_Status = 'N'
		WHERE I_Receipt_Header_ID = @iReceiptHeaderId
		COMMIT TRANSACTION	
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
