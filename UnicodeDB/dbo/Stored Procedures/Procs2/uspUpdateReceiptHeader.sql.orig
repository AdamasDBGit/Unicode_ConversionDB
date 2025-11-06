CREATE PROCEDURE [dbo].[uspUpdateReceiptHeader]
(
	@iReceiptID int,
	@iInvoiceHeaderID int,
	@dReceiptDate VARCHAR(12),
	@iStudentDetailID int,
	@iPaymentModeID int,
	@iCentreId int,
	@nReceiptAmount numeric(18,2),
	@nReceiptTaxAmount numeric(18,2),
	@sFundTransferStatus char(1),
	@sUpdatedBy varchar(20),
	@dUpdatedOn datetime,
	@nCreditCardNo numeric(18,0),
	@dCreditCardExpiry VARCHAR(12),
	@sCreditCardIssuer varchar(500),
	@sChequeDDNo varchar(20),
	@dChequeDDDate VARCHAR(12),
	@sBankName varchar(50),
	@sBranchName varchar(20),
	@iReceiptType int		
) 

AS
SET NOCOUNT OFF
BEGIN TRY 
	BEGIN TRANSACTION
	UPDATE T_Receipt_Header
	SET		I_Invoice_Header_ID = @iInvoiceHeaderID ,
			I_Student_Detail_ID = @iStudentDetailID,
			N_Receipt_Amount = @nReceiptAmount - @nReceiptTaxAmount,
			N_Tax_Amount = @nReceiptTaxAmount,
			S_Upd_By = @sUpdatedBy ,
			Dt_Upd_On = @dUpdatedOn,
			I_Receipt_Type = @iReceiptType
			WHERE I_Receipt_Header_ID = @iReceiptID		


DECLARE @N_Amount_Rff numeric(18,2)
DECLARE @N_Receipt_Tax_Rff NUMERIC(18,2)

SELECT @N_Amount_Rff = SUM (isnull(N_Comp_Amount_Rff,0)) 
FROM dbo.T_Receipt_Component_Detail 
WHERE I_Receipt_Detail_ID = @iReceiptID

SELECT @N_Receipt_Tax_Rff = SUM (ISNULL(RTD.N_Tax_Rff,0))
FROM dbo.T_Receipt_Tax_Detail RTD
INNER JOIN dbo.T_Receipt_Component_Detail RCD
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
WHERE RCD.I_Receipt_Detail_ID = @iReceiptID

UPDATE dbo.T_Receipt_Header
SET N_Amount_Rff = @N_Amount_Rff,
	N_Receipt_Tax_Rff = @N_Receipt_Tax_Rff
WHERE I_Receipt_Header_ID = @iReceiptID
COMMIT TRANSACTION
END TRY

BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION 
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
