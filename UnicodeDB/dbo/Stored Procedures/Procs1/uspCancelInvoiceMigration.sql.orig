CREATE PROCEDURE [dbo].[uspCancelInvoiceMigration]
(
	@iInvoiceId INT,
	@sUpdatedBy VARCHAR(20)
)


AS

BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @iStudentDetailID int
	
	--SET THE STATUS IN THE TABLE T_INVOICE_PARENT
	UPDATE T_INVOICE_PARENT SET I_STATUS = 0,  S_Upd_By = @sUpdatedBy, Dt_Upd_On = GETDATE() WHERE I_Invoice_Header_ID = @iInvoiceId
		
	--DELETE ASOOCIATED RECORDS FROM T_RECEIPT_TAX_DETAIL
	--Commented by Soumya on 29-Aug-08 as no child will deleted for FT purpose
	DELETE FROM T_RECEIPT_TAX_DETAIL WHERE I_Receipt_Comp_Detail_ID IN 
	(SELECT I_Receipt_Comp_Detail_ID FROM T_RECEIPT_COMPONENT_DETAIL WHERE I_Receipt_Detail_ID IN 
	(SELECT I_Receipt_Header_ID FROM T_RECEIPT_HEADER WHERE I_Invoice_Header_ID = @iInvoiceId and I_Status <> 0))
	
	--DELETE ASOOCIATED RECORDS FROM T_RECEIPT_COMPONENT_DETAIL
	DELETE FROM T_RECEIPT_COMPONENT_DETAIL WHERE I_Receipt_Detail_ID IN 
	(SELECT I_Receipt_Header_ID FROM T_RECEIPT_HEADER WHERE I_Invoice_Header_ID = @iInvoiceId and I_Status <> 0)
	
	
	--SELECT ALL RECEIPT HEADERS THAT CORRESPONDS TO THE PARTICULAR INVOICE
	--SELECT I_Receipt_Header_ID, N_Receipt_Amount,DT_RECEIPT_DATE FROM T_RECEIPT_HEADER WHERE I_Invoice_Header_ID = @iInvoiceId and I_STATUS = 1
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
