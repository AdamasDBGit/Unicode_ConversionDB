CREATE PROCEDURE [dbo].[uspGenerateReceiptForRegistrationTokenAmount]
(
	@iCenterId INT,
	@iAmount NUMERIC(18,2),
	@iEnquiryId INT,
	@iReceiptDate DATETIME,
	@iPaymentModeId INT,
	@sChequeDDno VARCHAR(20),
	@dChequeDate DATETIME,
	@sBankName VARCHAR(50), 
	@sBranchName VARCHAR(20),
	@iCreditCardNo NUMERIC(18,0),
	@sCreditCardIssuer VARCHAR(50),
	@dCardExpiryDate DATETIME,
	@sCrtdBy VARCHAR(20),
	@iReceiptType int,
	@dTaxAmount numeric(12,6),
	@TaxXML xml
)
 
AS

BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @CompanyShare numeric(8,4)
	DECLARE @TaxShare NUMERIC(18,2)
	DECLARE @bUseCenterServiceTax BIT
	SET @bUseCenterServiceTax = 'FALSE'
	
	BEGIN TRANSACTION
	--This checks whether the receipt entered within 5 minutes from now

		IF (convert(int,(SELECT dbo.fnCheckReceiptValidity(null,@iCenterId,@iEnquiryId,@iAmount))) = 0 )
		BEGIN
		SELECT -1
		RETURN;
		END


	SELECT @CompanyShare = [dbo].fnGetCompanyShareOnAccountReceipts(@iReceiptDate,CM.I_Country_ID,CM.I_Centre_Id,@iReceiptType,BCD.I_Brand_ID)
	FROM dbo.T_Centre_Master CM
	INNER JOIN dbo.T_Brand_Center_Details BCD
	ON BCD.I_Centre_Id = CM.I_Centre_Id
	AND BCD.I_Status = 1
	WHERE CM.I_Centre_ID = @iCenterId
	
	SELECT @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,'False')
	FROM dbo.T_Centre_Master CM WITH (NOLOCK)
	WHERE CM.I_Centre_ID = @iCenterId
	
	IF (@bUseCenterServiceTax = 'TRUE')
	BEGIN
		SET @TaxShare = @CompanyShare
	END
	ELSE
	BEGIN
		SET @TaxShare = 100
	END
	
	INSERT INTO 
	T_RECEIPT_HEADER 
	(I_Centre_Id,N_Receipt_Amount,I_Enquiry_Regn_ID,Dt_Receipt_Date,I_PaymentMode_ID,S_ChequeDD_No,
	Dt_ChequeDD_Date,S_Bank_Name,S_Branch_Name,N_CreditCard_No,S_CreditCard_Issuer,Dt_CreditCard_Expiry,
	S_Crtd_By,Dt_Crtd_On,I_Status,S_Fund_Transfer_Status,I_Receipt_Type,N_Tax_Amount,N_Amount_Rff,N_Receipt_Tax_Rff) 
	VALUES
	(@iCenterId,@iAmount,@iEnquiryId,@iReceiptDate,@iPaymentModeId,@sChequeDDno,
	@dChequeDate,@sBankName,@sBranchName,@iCreditCardNo,@sCreditCardIssuer,@dCardExpiryDate,@sCrtdBy,
	GETDATE(),1,'N',@iReceiptType,@dTaxAmount,@iAmount*@CompanyShare/100, @CompanyShare*@dTaxAmount /100)
	
	DECLARE @iReceiptIDnew INT
	SET @iReceiptIDnew = SCOPE_IDENTITY()
	DECLARE @iReceiptNo int

	SELECT @iReceiptNo = MAX(CAST(S_Receipt_No AS INT)) FROM T_RECEIPT_HEADER 
	WHERE S_Receipt_No NOT LIKE '%[A-Z]' --AND I_Centre_Id = @iCenterId
	
	SET @iReceiptNo = ISNULL(@iReceiptNo,0) + 1

	UPDATE T_RECEIPT_HEADER 
	SET S_Receipt_No = @iReceiptNo
	WHERE I_Receipt_Header_ID = @iReceiptIDnew

	CREATE TABLE #TEMPTABLE 
	(
		I_Tax_ID INT,
		N_Tax_Paid numeric(18,2)
	)
		
	INSERT INTO #TEMPTABLE
	SELECT T.c.value('@TaxID','int'),			
			T.c.value('@TaxPaid','numeric(18,2)')
	FROM   @TaxXML.nodes('/ReceiptTax/TaxDetails') T(c)

	INSERT INTO dbo.T_OnAccount_Receipt_Tax
	SELECT @iReceiptIDnew,I_Tax_ID,N_Tax_Paid,N_Tax_Paid*@TaxShare/100  FROM #TEMPTABLE

	DROP TABLE #TEMPTABLE
	
	SELECT @iReceiptIDnew
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
