/*****************************************************************************************************************
Created by: Aritra Saha
Date: 13/04/2007
Description: Updates the Invoice Details for Special Discounts
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspUpdateInvoiceforSpecialDiscount]
(
	@sInvoiceDetail XML,
	@dAmountDue numeric(18,2)
)

AS
BEGIN TRY

DECLARE	@InvoiceChildXML XML 
DECLARE @iInvoiceHeaderID int
DECLARE @iInvoiceChildHeaderId int
DECLARE	@InstallmentDetailXML XML 
DECLARE @iInvoiceDetailID int
DECLARE @nAmount numeric(18,2)
DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT, @InnerPosition SMALLINT, @InnerCount SMALLINT

BEGIN TRANSACTION
SELECT	@iInvoiceHeaderID = T.a.value('@I_Invoice_Header_ID','int')			
	FROM @sInvoiceDetail.nodes('/Invoice') T(a)
	
 UPDATE T_Invoice_Parent
   SET N_Invoice_Amount = @dAmountDue
   WHERE I_Invoice_Header_ID = @iInvoiceHeaderID
	
SET @AdjPosition = 1
SET @AdjCount = @sInvoiceDetail.value('count((Invoice/InvoiceChild))','int')
WHILE(@AdjPosition<=@AdjCount)
BEGIN
	SET @InvoiceChildXML = @sInvoiceDetail.query('Invoice/InvoiceChild[position()=sql:variable("@AdjPosition")]')	
	
	SELECT	@iInvoiceChildHeaderId = T.c.value('@I_Invoice_Child_Header_ID','int')
		FROM @InvoiceChildXML.nodes('/InvoiceChild') T(c)

  

	SET @InnerPosition = 1
	SET @InnerCount = @InvoiceChildXML.value('count((/InvoiceChild/InvoiceChildDetails/Installment))','int')

	
	WHILE(@InnerPosition<=@InnerCount)
	BEGIN
		SET @InstallmentDetailXML = @InvoiceChildXML.query('/InvoiceChild/InvoiceChildDetails/Installment[position()=sql:variable("@InnerPosition")]')
		SELECT	@iInvoiceDetailID = T.b.value('@I_Invoice_Detail_ID','int'),
				@nAmount = T.b.value('@N_Amount_Due','numeric')	
		FROM @InstallmentDetailXML.nodes('/Installment') T(b)

		

		UPDATE T_Invoice_Child_Detail 
		SET N_Amount_Due = @nAmount
		WHERE I_Invoice_Detail_ID = @iInvoiceDetailID
		
	

	SET @InnerPosition = @InnerPosition+1
	END
	
	--UPDATE T_INVOICE_DETAIL_TAX
	UPDATE T1
	SET T1.N_TAX_VALUE = ( T2.N_AMOUNT_DUE* T3.N_TAX_RATE)/100
	FROM T_INVOICE_DETAIL_TAX T1,T_INVOICE_CHILD_DETAIL T2,T_FEE_COMPONENT_TAX T3 
	WHERE 
	T2.I_INVOICE_CHILD_HEADER_ID =@iInvoiceChildHeaderId AND
	T1.I_TAX_ID = T3.I_TAX_ID AND
	T1.I_INVOICE_DETAIL_ID = T2.I_INVOICE_DETAIL_ID
	
 SET @AdjPosition = @AdjPosition + 1
END 


--	Update Course wise fees paid for the invoice
	DECLARE @iCourseFee numeric(18,2)
	DECLARE @iCourseTax numeric(18,2)


	DECLARE UPDATE_COURSEFEE CURSOR FOR
	SELECT I_Invoice_Child_Header_ID FROM dbo.T_Invoice_Child_Header
	where I_Invoice_Header_ID = @iInvoiceHeaderID


	OPEN UPDATE_COURSEFEE 
	FETCH NEXT FROM UPDATE_COURSEFEE INTO @iInvoiceChildHeaderID
		
	WHILE @@FETCH_STATUS = 0				
		BEGIN 
			SELECT @iCourseFee = SUM(N_Amount_Due)
			FROM dbo.T_Invoice_Child_Detail
			WHERE I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID

			SELECT @iCourseTax = SUM(IDT.N_Tax_Value)
			FROM dbo.T_Invoice_Detail_Tax IDT
			INNER JOIN dbo.T_Invoice_Child_Detail ICD
			ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
			WHERE ICD.I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID

			UPDATE dbo.T_Invoice_Child_Header
			SET N_Amount = @iCourseFee,
				N_Tax_Amount = @iCourseTax
			WHERE I_Invoice_Child_Header_ID = @iInvoiceChildHeaderID

			FETCH NEXT FROM UPDATE_COURSEFEE INTO @iInvoiceChildHeaderID						
				
		END
		
	CLOSE UPDATE_COURSEFEE 
	DEALLOCATE UPDATE_COURSEFEE 
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
