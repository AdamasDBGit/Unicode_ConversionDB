CREATE PROCEDURE [dbo].[uspUpdateReceiptHeaderCancelInvoice]
(
@sReceiptNo VARCHAR(20) ,
@iInvoiceHeaderID INT ,
@nReceiptAmount NUMERIC(18, 2) ,
@nReceiptTaxAmount NUMERIC(18, 2) ,
@sCrtdBy VARCHAR(20) ,
@dCreatedOn DATETIME ,
@iReceiptHeaderID INT
)
AS
SET NOCOUNT OFF
BEGIN TRY

UPDATE T_Receipt_Header
SET I_Invoice_Header_ID = @iInvoiceHeaderID ,
N_Receipt_Amount = @nReceiptAmount - @nReceiptTaxAmount ,
N_Tax_Amount = @nReceiptTaxAmount ,
S_Upd_By = @sCrtdBy ,
Dt_Upd_On = @dCreatedOn
WHERE I_Receipt_Header_ID = @iReceiptHeaderID

END TRY

BEGIN CATCH
--Error occurred:

DECLARE @ErrMsg NVARCHAR(4000) ,
@ErrSeverity INT
SELECT @ErrMsg = ERROR_MESSAGE() ,
@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
