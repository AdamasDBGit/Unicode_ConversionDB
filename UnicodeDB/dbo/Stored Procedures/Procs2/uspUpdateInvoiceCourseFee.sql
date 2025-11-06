CREATE PROCEDURE [dbo].[uspUpdateInvoiceCourseFee]

AS
BEGIN
	DECLARE @iInvoiceChildHeaderID INT	
	DECLARE @iCourseFee numeric(18,2)
	DECLARE @iCourseTax numeric(18,2)

	DECLARE UPDATE_COURSEFEE CURSOR FOR
	SELECT I_Invoice_Child_Header_ID FROM dbo.T_Invoice_Child_Header
	WHERE N_Amount IS NULL


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
END
