CREATE PROCEDURE [dbo].[uspAttachReceiptToNewInvoice]
(
	@iOldInvoiceId INT,
	@iNewInvoiceId INT,
	@sUpdatedBy VARCHAR(20)
)

AS

BEGIN TRY
	SET NOCOUNT ON;
	
	-- ASSOCIATE THE OLD RECEIPT TO THE NEW INVOICE
	UPDATE T_RECEIPT_HEADER SET I_Invoice_Header_ID = @iNewInvoiceId , S_Upd_By = @sUpdatedBy WHERE I_Invoice_Header_ID = @iOldInvoiceId
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
