CREATE PROCEDURE [dbo].[uspUpdateInvoiceChild]
(
	@iInvoiceHeaderId INT,
	@iCourseId INT,
	@sIsLumpsum VARCHAR(1),	
	@iCourseFeePlanId INT,
	@iCourseStartDate DATETIME,
	@iCenterId INT,
	@iLastCourse INT
)


AS

BEGIN TRY
	SET NOCOUNT ON	
	DECLARE @dtSecondInstallmentDate DATETIME
	DECLARE @dtCurrentDate DATETIME
	DECLARE @iInvoiceChildHeader INT
	DECLARE @nTaxTotal NUMERIC(18,2)
	
	INSERT INTO T_INVOICE_CHILD_HEADER (I_Invoice_Header_ID,I_Course_ID,I_Course_FeePlan_ID,C_Is_LumpSum) VALUES
	(@iInvoiceHeaderId,@iCourseId,@iCourseFeePlanId,@sIsLumpsum)
	
	SET @iInvoiceChildHeader = 	SCOPE_IDENTITY()		
	
	SET @dtCurrentDate = CONVERT(VARCHAR(10), GETDATE(), 101)
	--second installment date should be 1st of the couse start date
	--if it is within 15 days of first installment (getdate), it should be 1st of next month
	SET @dtSecondInstallmentDate = DATEADD(DD,- DATEPART(DD,@iCourseStartDate) + 1 ,@iCourseStartDate)
	IF DATEDIFF(DD,@dtCurrentDate,@dtSecondInstallmentDate) < 15 
			SET @dtSecondInstallmentDate = DATEADD(MM,1, @dtSecondInstallmentDate)
			
	
	IF UPPER(@sIsLumpsum) = 'Y'
		BEGIN
			INSERT INTO T_INVOICE_CHILD_DETAIL (I_INVOICE_CHILD_HEADER_ID,I_FEE_COMPONENT_ID,I_INSTALLMENT_NO,DT_INSTALLMENT_DATE,N_AMOUNT_DUE,I_DISPLAY_FEE_COMPONENT_ID,I_SEQUENCE) 
			SELECT @iInvoiceChildHeader,I_FEE_COMPONENT_ID,1, @dtCurrentDate,I_ITEM_VALUE,I_DISPLAY_FEE_COMPONENT_ID,I_SEQUENCE 		
			FROM T_COURSE_FEE_PLAN_DETAIL WHERE I_COURSE_FEE_PLAN_ID = @iCourseFeePlanId AND
			C_IS_LUMPSUM = 'Y'			
		END
	ELSE
		BEGIN
			INSERT INTO T_INVOICE_CHILD_DETAIL (I_INVOICE_CHILD_HEADER_ID,I_FEE_COMPONENT_ID,I_INSTALLMENT_NO,DT_INSTALLMENT_DATE,N_AMOUNT_DUE,I_DISPLAY_FEE_COMPONENT_ID,I_SEQUENCE) 
			SELECT @iInvoiceChildHeader,I_FEE_COMPONENT_ID,I_INSTALLMENT_NO, @dtCurrentDate,I_ITEM_VALUE,I_DISPLAY_FEE_COMPONENT_ID,I_SEQUENCE 		
			FROM T_COURSE_FEE_PLAN_DETAIL WHERE I_COURSE_FEE_PLAN_ID = @iCourseFeePlanId AND
			C_IS_LUMPSUM = 'N'	AND I_INSTALLMENT_NO = 1
			
			INSERT INTO T_INVOICE_CHILD_DETAIL (I_INVOICE_CHILD_HEADER_ID,I_FEE_COMPONENT_ID,I_INSTALLMENT_NO,DT_INSTALLMENT_DATE,N_AMOUNT_DUE,I_DISPLAY_FEE_COMPONENT_ID,I_SEQUENCE) 
			SELECT @iInvoiceChildHeader,I_FEE_COMPONENT_ID,I_INSTALLMENT_NO, DATEADD(mm,T_COURSE_FEE_PLAN_DETAIL.I_INSTALLMENT_NO - 2, @dtSecondInstallmentDate),I_ITEM_VALUE,I_DISPLAY_FEE_COMPONENT_ID,I_SEQUENCE 		
			FROM T_COURSE_FEE_PLAN_DETAIL WHERE I_COURSE_FEE_PLAN_ID = @iCourseFeePlanId AND
			C_IS_LUMPSUM = 'N'	AND I_INSTALLMENT_NO > 1	
		
		END
		
	
	INSERT INTO T_INVOICE_DETAIL_TAX (I_TAX_ID,I_INVOICE_DETAIL_ID,N_TAX_VALUE)
	SELECT TFCT.I_TAX_ID,TICD.I_INVOICE_DETAIL_ID, (TICD.N_AMOUNT_DUE*TFCT.N_TAX_RATE)/100 FROM 
	T_FEE_COMPONENT_TAX TFCT, T_INVOICE_CHILD_DETAIL TICD,T_Tax_Master TTM WHERE
	TTM.I_Tax_ID = TFCT.I_Tax_ID AND
	TFCT.I_CENTRE_ID = @iCenterId AND
	TFCT.I_FEE_COMPONENT_ID = TICD.I_FEE_COMPONENT_ID AND
	TICD.I_INVOICE_CHILD_HEADER_ID = @iInvoiceChildHeader
	AND TTM.I_STATUS <> 0
	
	-- FOR THE LAST COURSE, UPDATE THE INSTALLMENT NUMBER ACCORDING TO THE INSTALLMENT DATE
	IF @iLastCourse = 1 
	BEGIN
		DECLARE @TEMPTABLE TABLE(ID INT IDENTITY(1,1), INSALLMENT_DATE VARCHAR(10), Dt_Installment_Date DateTime)
		INSERT INTO @TEMPTABLE
		SELECT DISTINCT CONVERT(VARCHAR(10), Dt_Installment_Date, 101), Dt_Installment_Date
		FROM T_INVOICE_CHILD_DETAIL WHERE I_INVOICE_CHILD_HEADER_ID IN
		(SELECT I_INVOICE_CHILD_HEADER_ID FROM T_INVOICE_CHILD_HEADER WHERE I_INVOICE_HEADER_ID = @iInvoiceHeaderId)
		ORDER BY Dt_Installment_Date 
		
		UPDATE TICD SET I_Installment_No = TT.ID 
		FROM T_INVOICE_CHILD_DETAIL TICD, @TEMPTABLE TT 
		WHERE
		TT.INSALLMENT_DATE = CONVERT(VARCHAR(10), TICD.DT_INSTALLMENT_DATE, 101)  
		AND TICD.I_INVOICE_CHILD_HEADER_ID IN
		(SELECT I_INVOICE_CHILD_HEADER_ID FROM T_INVOICE_CHILD_HEADER WHERE I_INVOICE_HEADER_ID = @iInvoiceHeaderId)
		
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
	DECLARE @iInvoiceChildHeaderID INT	
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



	END 
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
