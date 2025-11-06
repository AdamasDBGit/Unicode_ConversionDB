CREATE PROCEDURE [SelfService].[uspUpdateOnAccTransactionStatus]
(
	@DueID INT,
	@TransactionNo VARCHAR(MAX),
	@TransactionStatus VARCHAR(MAX)
)
AS
BEGIN TRY


	DECLARE @CentreID INT,
			@Amount DECIMAL(14,2)=0,
			@iStudentDetailID INT,
			@dtDate DATETIME,
			@PaymentModeID INT,
			@OnAccReceiptTypeID INT,
			@Tax DECIMAL(14,2)=0,
			@OnAccTaxXML XML='<ReceiptTax />',
			@BrandID INT,
			@iReceiptHeader INT=0,
			@CurrTransactionStatus VARCHAR(MAX)

	BEGIN TRANSACTION

	IF NOT EXISTS(select * from SelfService.T_Online_Payment_Master where TransactionNo=@TransactionNo and StatusID=1 and OnAccDueID=@DueID and TransactionStatus!='Success')
	BEGIN

		RAISERROR('Invalid Tranaction No',11,1)

	END
	ELSE
	BEGIN

		select @CurrTransactionStatus=TransactionStatus from SelfService.T_Online_Payment_Master where TransactionNo=@TransactionNo and StatusID=1 and OnAccDueID=@DueID and TransactionStatus!='Success'

	END

	IF(@TransactionStatus='Success' and @CurrTransactionStatus='Pending')
	BEGIN

		select @CentreID=CenterID,@BrandID=BrandID,@Amount=Amount,@Tax=Tax,@OnAccReceiptTypeID=OnAccReceiptTypeID,
		@PaymentModeID=CASE WHEN TransactionSource='Online-SelfService' THEN 27 ELSE 0 END,
		@iStudentDetailID=B.I_Student_Detail_ID,@dtDate=GETDATE()
		from SelfService.T_Online_Payment_Master A
		inner join T_Student_Detail B on A.StudentID=B.S_Student_ID
		inner join T_Student_Center_Detail C on A.CenterID=C.I_Centre_Id and B.I_Student_Detail_ID=C.I_Student_Detail_ID and C.I_Status=1
		where 
		TransactionNo=@TransactionNo and StatusID=1 and OnAccDueID=@DueID


		IF(@PaymentModeID>0 and @iStudentDetailID>0)
			BEGIN

				DECLARE @cgst DECIMAL(14,2)=0
				DECLARE @sgst DECIMAL(14,2)=0

				IF (@Tax IS NOT NULL AND @Tax>0)                                    
                BEGIN
					SET @cgst=ROUND((@Tax/2),2)
					SET @sgst=@Tax-@cgst
														
					SET @OnAccTaxXML='<ReceiptTax><TaxDetails TaxID="7" TaxPaid="'+CAST(@cgst AS VARCHAR)+'"/>
					<TaxDetails TaxID="8" TaxPaid="'+CAST(@sgst AS VARCHAR)+'"/></ReceiptTax>'
														
				END


				EXEC uspGenerateReceiptForOnAccountAPI @iCenterId = @CentreID,
													@iAmount = @Amount,
													@iStudentDetailId = @iStudentDetailID,
													@iReceiptDate = @dtDate,
													@iPaymentModeId = @PaymentModeID,
													@sChequeDDno = NULL,
													@dChequeDate = NULL,
													@sBankName = NULL,
													@sBranchName = NULL,
													@iCreditCardNo = NULL,
													@sCreditCardIssuer = NULL,
													@dCardExpiryDate = NULL,
													@sCrtdBy = 'rice-group-admin',
													@iReceiptType = @OnAccReceiptTypeID,
													@dTaxAmount = @Tax,
													@TaxXML = @OnAccTaxXML,
													@iBrandID = @BrandID,
													@iEnquiryID = NULL,
													@sFormNo = NULL,
													@sNarration = '',
													@iReceiptHeader = @iReceiptHeader OUTPUT


				IF(@iReceiptHeader>0)
				BEGIN

					UPDATE SelfService.T_Online_Payment_Master set ReceiptHeaderID=@iReceiptHeader,ReceiptDate=@dtDate,TransactionStatus=@TransactionStatus 
					where 
					TransactionNo=@TransactionNo and OnAccDueID=@DueID and StatusID=1


					UPDATE SelfService.T_OnAccount_Due set ReceiptHeaderID=@iReceiptHeader,PaidOn=@dtDate where ID=@DueID and StatusID=1

				END


			END

			


	END
	ELSE
	BEGIN

		UPDATE SelfService.T_Online_Payment_Master set TransactionStatus=@TransactionStatus 
		where 
		TransactionNo=@TransactionNo and OnAccDueID=@DueID and StatusID=1

	END



	EXEC [SelfService].[uspGetStudentOnAccDuePaymentDetails] @DueID

	COMMIT TRANSACTION


END TRY

BEGIN CATCH

 --Error occurred:      
        ROLLBACK TRANSACTION    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1) 

END CATCH
