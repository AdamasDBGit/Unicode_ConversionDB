/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 18/04/2007
Description: Attach Token Amount To Invoice
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspAttachTokenAmountToInvoice]
(
	@iInvoiceId INT,
	@iStudentDetailId INT,
	@sUpdatedBy VARCHAR(20)
)

AS

BEGIN TRY

	UPDATE T_RECEIPT_HEADER SET I_INVOICE_HEADER_ID = 	@iInvoiceId,
	I_STUDENT_DETAIL_ID = @iStudentDetailId
	WHERE
	I_ENQUIRY_REGN_ID IN
	(SELECT I_ENQUIRY_REGN_ID FROM T_STUDENT_DETAIL WHERE I_STUDENT_DETAIL_ID = @iStudentDetailId)
	
	
	SELECT I_Receipt_Header_ID, N_Receipt_Amount,DT_RECEIPT_DATE FROM T_RECEIPT_HEADER 
	WHERE I_Invoice_Header_ID = @iInvoiceId and I_STATUS = 1
		
END TRY
BEGIN CATCH

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
