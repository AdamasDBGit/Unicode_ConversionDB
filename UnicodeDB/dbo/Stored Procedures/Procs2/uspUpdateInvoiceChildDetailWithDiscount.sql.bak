CREATE PROCEDURE [dbo].[uspUpdateInvoiceChildDetailWithDiscount]
(
	@iInvoiceHeaderId INT,
	@iDiscountSchemeId INT,
	@iDiscountSchemeAppliedAt INT,
	@dTotalInvoiceAmount NUMERIC(18,2),
	@dDiscountPercent NUMERIC(18,2) = null
)


AS

BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @iDiscountRate NUMERIC(18,2)
	DECLARE @iTotalDiscount NUMERIC(18,2)
	DECLARE @idiscountPerInstallment NUMERIC(18,2)
	DECLARE @iTotalInstallments INT
	DECLARE @iInvoiceChildHeaderId INT
	DECLARE @iCounter INT
	DECLARE @iAmtDue NUMERIC(18,2) 
	DECLARE @nMaxRange NUMERIC(18,2)
	DECLARE @nTaxTotal NUMERIC(18,2)
	
	SELECT @nMaxRange = MAX(N_RANGE_TO) FROM T_DISCOUNT_DETAILS WHERE I_DISCOUNT_SCHEME_ID = @iDiscountSchemeId
	
	IF @dTotalInvoiceAmount > @nMaxRange
		BEGIN
			SELECT @iDiscountRate = N_DISCOUNT_RATE FROM T_DISCOUNT_DETAILS WHERE N_RANGE_TO = @nMaxRange AND I_DISCOUNT_SCHEME_ID = @iDiscountSchemeId
		END
	ELSE
		BEGIN
			SELECT @iDiscountRate = N_DISCOUNT_RATE FROM T_DISCOUNT_DETAILS WHERE @dTotalInvoiceAmount > N_RANGE_FROM AND @dTotalInvoiceAmount < N_RANGE_TO AND I_DISCOUNT_SCHEME_ID = @iDiscountSchemeId
		END
	
	IF @iDiscountRate IS NULL
		SET @iDiscountRate = 0
		SET @iDiscountRate = @iDiscountRate + @dDiscountPercent
	
	
	SET @iTotalDiscount = (@dTotalInvoiceAmount * @iDiscountRate) / 100
	SELECT @iInvoiceChildHeaderId  = I_INVOICE_CHILD_HEADER_ID FROM T_INVOICE_CHILD_HEADER WHERE I_INVOICE_HEADER_ID = @iInvoiceHeaderId
	
	--UPDATE T_INVOICE_PARENT
	UPDATE T_INVOICE_PARENT SET N_INVOICE_AMOUNT = N_INVOICE_AMOUNT - @iTotalDiscount, N_DISCOUNT_AMOUNT = @iTotalDiscount , 
	I_Discount_Scheme_ID = @iDiscountSchemeId ,I_Discount_Applied_At = @iDiscountSchemeAppliedAt
	WHERE I_STATUS = 1 AND
	I_INVOICE_HEADER_ID  = @iInvoiceHeaderId 
	--IN(SELECT DISTINCT I_INVOICE_HEADER_ID FROM T_INVOICE_CHILD_HEADER WHERE I_INVOICE_CHILD_HEADER_ID = @iInvoiceChildHeaderId)
	
	IF @iDiscountSchemeAppliedAt = 1 -- PRO-RATA 
		BEGIN
			--SELECT @iTotalInstallments = COUNT(*) FROM T_INVOICE_CHILD_DETAIL WHERE I_INVOICE_CHILD_HEADER_ID IN
			--(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)
			
			--SET @idiscountPerInstallment = 	@iTotalDiscount / @iTotalInstallments
			--UPDATE T_INVOICE_CHILD_DETAIL SET N_AMOUNT_DUE = N_AMOUNT_DUE - @idiscountPerInstallment WHERE I_INVOICE_CHILD_HEADER_ID IN
			--(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)			
			UPDATE T_INVOICE_CHILD_DETAIL SET N_AMOUNT_DUE = N_AMOUNT_DUE - (N_AMOUNT_DUE * @iDiscountRate)/ 100 
			WHERE I_INVOICE_CHILD_HEADER_ID IN
			(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)	
		END
	
	IF @iDiscountSchemeAppliedAt = 2  -- LAST INSTALLMENT
		BEGIN
			DECLARE @TEMPTABLE TABLE(ID INT IDENTITY(1,1),INSTALLMENT_NUMBER INT)
			INSERT INTO @TEMPTABLE(INSTALLMENT_NUMBER) 
			SELECT DISTINCT I_Installment_No FROM T_INVOICE_CHILD_DETAIL 
			WHERE I_INVOICE_CHILD_HEADER_ID IN
			(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)	
			ORDER BY I_Installment_No DESC
	
			SET @iCounter = 1
			WHILE @iTotalDiscount > 0
				BEGIN
					DECLARE @dInstallmentSum NUMERIC(18,2)
					SELECT @dInstallmentSum = SUM(N_AMOUNT_DUE) FROM T_INVOICE_CHILD_DETAIL WHERE I_Installment_No = 
					(SELECT INSTALLMENT_NUMBER FROM @TEMPTABLE WHERE ID = @iCounter) AND I_INVOICE_CHILD_HEADER_ID IN
					(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER 
					WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)	
					
					IF @dInstallmentSum > @iTotalDiscount
						BEGIN
							UPDATE T_INVOICE_CHILD_DETAIL SET N_Amount_Due = N_Amount_Due - ((N_Amount_Due)/@dInstallmentSum)*@iTotalDiscount
							WHERE I_Installment_No = 
							(SELECT INSTALLMENT_NUMBER FROM @TEMPTABLE WHERE ID = @iCounter) AND 			
							I_INVOICE_CHILD_HEADER_ID IN
							(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER 
							WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)
								
							SET @iTotalDiscount = 0
						END
					ELSE
						BEGIN
							UPDATE T_INVOICE_CHILD_DETAIL SET N_Amount_Due = 0 WHERE I_Installment_No = 
							(SELECT INSTALLMENT_NUMBER FROM @TEMPTABLE WHERE ID = @iCounter) AND 			
							I_INVOICE_CHILD_HEADER_ID IN
							(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER 
							WHERE I_Invoice_Header_ID = @iInvoiceHeaderId)	
					
							SET @iTotalDiscount = @iTotalDiscount - @dInstallmentSum
						END
					SET @iCounter = @iCounter + 1
				END
		END		
		
		
	--UPDATE T_INVOICE_DETAIL_TAX
	UPDATE T1
	SET T1.N_TAX_VALUE = ( T2.N_AMOUNT_DUE* T3.N_TAX_RATE)/100
	FROM T_INVOICE_DETAIL_TAX T1,T_INVOICE_CHILD_DETAIL T2,T_FEE_COMPONENT_TAX T3 
	WHERE 
	T2.I_INVOICE_CHILD_HEADER_ID IN
	(SELECT I_Invoice_Child_Header_ID from T_INVOICE_CHILD_HEADER WHERE I_Invoice_Header_ID = @iInvoiceHeaderId) AND
	T1.I_TAX_ID = T3.I_TAX_ID AND
	T1.I_INVOICE_DETAIL_ID = T2.I_INVOICE_DETAIL_ID 
	
	--ADD THE CODE FOR HOLDING TOTAL TAX INFO IN INVOICE PARENT
	
	SET @nTaxTotal = 0.0
	
	-- GET THE TAX TOTAL AMOUNT
		SELECT @nTaxTotal = @nTaxTotal + IDT.N_Tax_Value
		FROM dbo.T_Invoice_Detail_Tax IDT
		INNER JOIN dbo.T_Invoice_Child_Detail ICD
		ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
		INNER JOIN dbo.T_Invoice_Child_Header ICH
		ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
		AND ICH.I_Invoice_Header_ID = @iInvoiceHeaderId
		 
		-- POPULATE THE INVOICE TAX AMOUNT
		UPDATE dbo.T_Invoice_Parent
		SET N_Tax_Amount = @nTaxTotal
		WHERE I_Invoice_Header_ID = @iInvoiceHeaderId
		
	
--	Update Course wise fees paid for the invoice
	DECLARE @iCourseFee numeric(18,2)
	DECLARE @iCourseTax numeric(18,2)


	DECLARE UPDATE_COURSEFEE CURSOR FOR
	SELECT I_Invoice_Child_Header_ID FROM dbo.T_Invoice_Child_Header
	where I_Invoice_Header_ID = @iInvoiceHeaderId


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
		
	
END TRY
  
  
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
