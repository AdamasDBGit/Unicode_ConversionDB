CREATE PROCEDURE [dbo].[uspSaveOfflineReceipts] 
(	
	@sReceiptsXML xml
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ReceiptListPosition SMALLINT, @ReceiptListCount SMALLINT
	DECLARE @ReceiptsXML XML
	
	DECLARE @sStudentNo nvarchar(max)
	DECLARE @sInvoiceNo nvarchar(max)
	DECLARE @dtReceiptDate DATETIME
	DECLARE @sFirstName nvarchar(max)
	DECLARE @sLastName nvarchar(max)
	DECLARE @iReceiptType INT
	DECLARE @iPaymentMode INT
	DECLARE @iCenterID INT
	DECLARE @nReceiptAmount NUMERIC(18,2)
	DECLARE @iStatus INT

	DECLARE @sChequeNo nvarchar(max)
	DECLARE @sBankName nvarchar(max)
	DECLARE @sBranchName nvarchar(max)
	DECLARE @dtChequeDate DATETIME

	DECLARE @nCreditCardNo NUMERIC(18,0)
	DECLARE @sCreditCardIssuer nvarchar(max)
	DECLARE @dtCreditCardExpiryDate DATETIME

	DECLARE @sCreatedBy nvarchar(max)
	DECLARE @dtCreatedOn DATETIME

	BEGIN TRANSACTION
	
	SET @ReceiptListPosition = 1
	SET @ReceiptListCount = @sReceiptsXML.value('count((ReceiptList/Receipt))','int')
	
	WHILE (@ReceiptListPosition<=@ReceiptListCount)
	-- Loop for each Receipt in the ReceiptList xml
	BEGIN

		SET @nCreditCardNo = NULL
		SET	@sCreditCardIssuer = NULL
		SET	@dtCreditCardExpiryDate = NULL
		SET	@sChequeNo = NULL
		SET @sBankName = NULL
		SET	@sBranchName = NULL
		SET	@dtChequeDate = NULL
		SET	@sInvoiceNo = NULL

			--Get the Receipt node for the Current Position
			SET @ReceiptsXML = @sReceiptsXML.query('/ReceiptList/Receipt[position()=sql:variable("@ReceiptListPosition")]')
			SELECT @sStudentNo = Receipt.a.value('@StudentNo','nvarchar(max)'),
				   @dtReceiptDate = Receipt.a.value('@ReceiptDate','datetime'),
				   @sFirstName = Receipt.a.value('@FirstName','nvarchar(max)'),
				   @sLastName = Receipt.a.value('@LastName','nvarchar(max)'),
				   @iReceiptType = Receipt.a.value('@ReceiptType','INT'),
				   @iPaymentMode = Receipt.a.value('@PaymentMode','INT'),
				   @iCenterID = Receipt.a.value('@CenterId','INT'),
				   @nReceiptAmount = Receipt.a.value('@ReceiptAmount','numeric(18,2)'),
				   @iStatus = Receipt.a.value('@Status','INT'),
				   @sCreatedBy = Receipt.a.value('@CreatedBy','nvarchar(max)'),
				   @dtCreatedOn = Receipt.a.value('@CreatedOn','datetime')
			
 			FROM @ReceiptsXML.nodes('/Receipt') Receipt(a)
				   
				   IF (@iPaymentMode = 2)
				   BEGIN
				    SELECT	@sChequeNo = Receipt.a.value('@ChequeNo','nvarchar(max)'),
						@sBankName = Receipt.a.value('@BankName','nvarchar(max)'),
						@sBranchName = Receipt.a.value('@BranchName','nvarchar(max)'),
						@dtChequeDate = Receipt.a.value('@ChequeDate','datetime')
					FROM @ReceiptsXML.nodes('/Receipt') Receipt(a)					   
				   END
				   
				   IF (@iPaymentMode = 3)
				   BEGIN
					SELECT @nCreditCardNo = Receipt.a.value('@CreditCardNo','numeric(18,0)'),
					     @sCreditCardIssuer = Receipt.a.value('@CreditCardIssuer','nvarchar(max)'),
					     @dtCreditCardExpiryDate = Receipt.a.value('@CreditCardExpiryDate','datetime')	
					FROM @ReceiptsXML.nodes('/Receipt') Receipt(a)
				   END
			
				   IF (@iReceiptType = 2)
				   BEGIN
					SELECT @sInvoiceNo = Receipt.a.value('@InvoiceNo','nvarchar(max)')
				    FROM @ReceiptsXML.nodes('/Receipt') Receipt(a)
				   END
			
			INSERT INTO T_Center_Receipt
			(
				S_Invoice_No,
				Dt_Receipt_Date,
				S_Student_ID,
				S_First_Name,
				S_Last_Name,
				I_PaymentMode_ID,
				I_Center_ID,
				N_Receipt_Amount,
				I_Status,
				I_Flag_IsAdjusted,

				S_ChequeDD_No,
				S_Bank_Name,
				S_Branch_Name,
				Dt_ChequeDD_Date,

				N_CreditCard_No,
				S_CreditCard_Issuer,
				Dt_CreditCard_Expiry,
					
				I_Receipt_Type,
				S_Crtd_By,
				Dt_Crtd_On
			)
			VALUES
			(
				@sInvoiceNo,
				@dtReceiptDate,
				@sStudentNo,
				@sFirstName,
				@sLastName,
				@iPaymentMode,
				@iCenterID,
				@nReceiptAmount,
				@iStatus,
				'0',
				
				@sChequeNo,
				@sBankName, 
				@sBranchName, 
				@dtChequeDate, 

				@nCreditCardNo, 
				@sCreditCardIssuer, 
				@dtCreditCardExpiryDate, 
				
				@iReceiptType,
				@sCreatedBy,
				@dtCreatedOn
			)			
			

			SET @ReceiptListPosition = @ReceiptListPosition + 1
	END
	
	COMMIT TRANSACTION
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
