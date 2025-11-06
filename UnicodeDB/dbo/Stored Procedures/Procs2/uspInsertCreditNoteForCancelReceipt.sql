
CREATE PROCEDURE [dbo].[uspInsertCreditNoteForCancelReceipt] --EXEC uspInsertCreditNoteForCancelReceipt 771407
(
	@uspReceiptDetailId INT
)
	
AS
BEGIN
	SET NOCOUNT ON;	
	IF EXISTS
	(
		SELECT 1 FROM T_Advance_Receipt_Mapping ARM
		INNER JOIN T_Invoice_Child_Header AS ICH ON ARM.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
		INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
		AND	ARM.I_Receipt_Header_ID = @uspReceiptDetailId
	)
	BEGIN
		DECLARE @row INT = 1
		DECLARE @count INT

		DECLARE @idtInvoiceDetailId INT
		DECLARE @idtAdvMapInvoiceDetailId INT
		
		DECLARE @AdvInvoiceHeaderId INT
		DECLARE @AdvInvoiceChildHeaderId INT
		DECLARE @AdvInvoiceDetailId INT

		DECLARE @InvoiceHeaderID int
		DECLARE @ReceiptHeaderID int
		DECLARE @InvoiceChildHeaderID int
		DECLARE @ReceiptComponentDetailID int
		DECLARE @InvoiceDetailID INT 
		DECLARE @FeeComponentID INT
		DECLARE @ReceiptDate DATE
		DECLARE @InstallmentNo INT
		DECLARE @InstallmentDate DATE
		DECLARE @AmountDue NUMERIC(18,2)
		DECLARE @AmountPaid NUMERIC(18,2)
		DECLARE @AmountAdvColn NUMERIC(18,2)
		
		DECLARE @S_Invoice_Number VARCHAR(100)
		DECLARE @I_Credit_Note_Invoice_Child_Detail_ID INT
		
		DECLARE @TotAdvPerInv NUMERIC(18,2)
	
		CREATE TABLE #RTMPX(
			ID INT IDENTITY(1,1),
			InvoiceHeaderID int,
			InvoiceChildHeaderID int,
			InvoiceDetailID INT
		)
		
		INSERT INTO #RTMPX(InvoiceHeaderID,InvoiceChildHeaderID,InvoiceDetailID)
		SELECT IP.I_Invoice_Header_ID, ARM.I_Invoice_Child_Header_ID, ARM.I_Invoice_Detail_ID
		FROM T_Advance_Receipt_Mapping ARM
		INNER JOIN T_Invoice_Child_Header AS ICH ON ARM.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
		INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
		AND	ARM.I_Receipt_Header_ID = @uspReceiptDetailId
			
		CREATE TABLE #RTMP(
			ID INT IDENTITY(1,1),
			InvoiceHeaderID int,
			ReceiptHeaderID int,
			InvoiceChildHeaderID int,
			ReceiptComponentDetailID int,
			InvoiceDetailID INT, 
			FeeComponentID INT, 
			ReceiptDate DATE,
			InstallmentNo INT,
			InstallmentDate DATE, 
			AmountDue NUMERIC(18,2) DEFAULT 0, 
			AmountPaid NUMERIC(18,2) DEFAULT 0,
			AmountAdvColn NUMERIC(18,2) DEFAULT 0
		)

		INSERT INTO #RTMP(InvoiceHeaderID,ReceiptHeaderID,InvoiceChildHeaderID,ReceiptComponentDetailID,InvoiceDetailID,
						  FeeComponentID,ReceiptDate,InstallmentNo,InstallmentDate,AmountDue,AmountPaid,AmountAdvColn)
		SELECT RH.I_Invoice_Header_ID, RH.I_Receipt_Header_ID, TICD.I_Invoice_Child_Header_ID, TRCD.I_Receipt_Comp_Detail_ID, TICD.I_Invoice_Detail_ID, 
			   TICD.I_Fee_Component_ID, RH.Dt_Receipt_Date, TICD.I_Installment_No, TICD.Dt_Installment_Date, TICD.N_Amount_Due, TRCD.N_Amount_Paid, 
			   TICD.N_Amount_Adv_Coln
		FROM T_Receipt_Component_Detail TRCD
		INNER JOIN T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
		INNER JOIN (SELECT I_Receipt_Header_ID, I_Invoice_Header_ID, Dt_Receipt_Date, I_Status FROM T_Receipt_Header WHERE I_Receipt_Header_ID = @uspReceiptDetailId) AS RH
		ON RH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
		WHERE TRCD.I_Receipt_Detail_ID = @uspReceiptDetailId
		AND CONVERT(DATE, RH.Dt_Receipt_Date) < CONVERT(DATE, TICD.Dt_Installment_Date)
		AND TRCD.N_Amount_Paid > 0
		AND RH.I_Status = 0
		ORDER BY TICD.I_Invoice_Detail_ID asc
		
		SELECT @count = COUNT(ID) FROM #RTMP
    
		WHILE (@row <= @count)
		BEGIN
			SELECT @ReceiptHeaderID = ReceiptHeaderID,
				   @InvoiceChildHeaderID = InvoiceChildHeaderID,
				   @ReceiptComponentDetailID = ReceiptComponentDetailID,
				   @InvoiceDetailID = InvoiceDetailID, 
				   @FeeComponentID = FeeComponentID, 
				   @ReceiptDate = ReceiptDate, 
				   @InstallmentNo = InstallmentNo, 
				   @InstallmentDate = InstallmentDate, 
				   @AmountDue = ISNULL(AmountDue,0), 
				   @AmountPaid = ISNULL(AmountPaid,0),
				   @AmountAdvColn = ISNULL(AmountAdvColn,0)
			FROM #RTMP WHERE ID = @row
			IF (@AmountPaid > 0)
			BEGIN
				SET @TotAdvPerInv = 0
				SET @TotAdvPerInv = (@AmountAdvColn - @AmountPaid)
				
				IF(@TotAdvPerInv>=0)
				BEGIN
					-----update existing records T_Invoice_Child_Detail
					UPDATE T_Invoice_Child_Detail  
					SET N_Amount_Adv_Coln = @TotAdvPerInv
					WHERE I_Invoice_Detail_ID = @InvoiceDetailID
				
				
					-------delete existing record and insert new record into tax table
					DELETE FROM T_Invoice_Detail_Tax WHERE I_Invoice_Detail_ID = @InvoiceDetailID

					INSERT INTO T_Invoice_Detail_Tax(I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value,N_Tax_Value_Scheduled)
					SELECT TAX.I_Tax_ID, RTM.InvoiceDetailID, 
					CAST(ISNULL(RTM.AmountDue,0) * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value,
					CAST((ISNULL(RTM.AmountDue,0) - ISNULL(@TotAdvPerInv,0)) * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2))  AS N_Tax_Value_Scheduled
					FROM
					(SELECT TCFC.N_Tax_Rate, TM.I_Tax_ID 
					FROM (select * from dbo.T_Tax_Master) AS TM
					INNER JOIN (select * from dbo.T_Tax_Country_Fee_Component where I_Fee_Component_ID=@FeeComponentID) AS TCFC
						ON (TM.I_Tax_ID = TCFC.I_Tax_ID
							AND TM.I_Country_ID = TCFC.I_Country_ID AND TCFC.N_Tax_Rate > 0
							AND @installmentDate BETWEEN TCFC.Dt_Valid_From AND TCFC.Dt_Valid_To
							)
					) TAX
					INNER JOIN #RTMP RTM ON RTM.InvoiceDetailID = @InvoiceDetailID --1309664
				END
			END
			SET @row = @row + 1
		END
		
		SET @row = 1
		SELECT @count = COUNT(ID) FROM #RTMP
	    
		WHILE (@row <= @count)
		BEGIN
			SELECT @InvoiceHeaderID = InvoiceHeaderID,
				   @ReceiptHeaderID = ReceiptHeaderID,
				   @InvoiceChildHeaderID = InvoiceChildHeaderID,
				   @ReceiptComponentDetailID = ReceiptComponentDetailID,
				   @InvoiceDetailID = InvoiceDetailID, 
				   @FeeComponentID = FeeComponentID, 
				   @ReceiptDate = ReceiptDate, 
				   @InstallmentNo = InstallmentNo, 
				   @InstallmentDate = InstallmentDate, 
				   @AmountDue = ISNULL(AmountDue,0), 
				   @AmountPaid = ISNULL(AmountPaid,0),
				   @AmountAdvColn = ISNULL(AmountAdvColn,0)
			FROM #RTMP WHERE ID = @row
			
			SET @AdvInvoiceHeaderId = 0
			SET @AdvInvoiceChildHeaderId = 0
			SET @AdvInvoiceDetailId = 0
			
			SELECT TOP 1 @AdvInvoiceHeaderId = InvoiceHeaderID, 
						 @AdvInvoiceChildHeaderId = InvoiceChildHeaderID
			FROM #RTMPX R
			WHERE InvoiceHeaderID = @InvoiceHeaderID AND InvoiceChildHeaderID = @InvoiceChildHeaderID
			
			SELECT TOP 1 @AdvInvoiceDetailId = AICDM.I_Advance_Ref_Invoice_Child_Detail_ID
			FROM T_Advance_Invoice_Child_Detail_Mapping AICDM
			INNER JOIN T_Receipt_Component_Detail RCD ON AICDM.I_Receipt_Component_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
			WHERE RCD.I_Receipt_Detail_ID = @uspReceiptDetailId AND AICDM.I_Invoice_Detail_ID = @InvoiceDetailID
			
			IF(@AdvInvoiceHeaderId <> 0)
			BEGIN
				EXEC dbo.uspGenerateInvoiceNumberForCreditNote @AdvInvoiceHeaderId, 0, @ReceiptDate, @S_Invoice_Number OUTPUT
				
				INSERT INTO T_Credit_Note_Invoice_Child_Detail(I_Invoice_Header_ID,I_Invoice_Detail_ID,S_Invoice_Number, Dt_Crtd_On, N_Amount, N_Amount_Due, N_Amount_Adv)
				VALUES(@AdvInvoiceHeaderId,@AdvInvoiceDetailID, @S_Invoice_Number, GETDATE(), @AmountPaid, 0, @AmountPaid)
				
				SET @I_Credit_Note_Invoice_Child_Detail_ID = SCOPE_IDENTITY()
				
				INSERT INTO T_Credit_Note_Invoice_Child_Detail_Tax(I_Credit_Note_Invoice_Child_Detail_ID,I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value)
				SELECT @I_Credit_Note_Invoice_Child_Detail_ID, TAX.I_Tax_ID, @AdvInvoiceDetailID, CAST(@AmountPaid * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value
				FROM
				(SELECT TCFC.N_Tax_Rate, TM.I_Tax_ID 
				FROM (select * from dbo.T_Tax_Master) AS TM
				INNER JOIN (select * from dbo.T_Tax_Country_Fee_Component where I_Fee_Component_ID=@FeeComponentID) AS TCFC
					ON (TM.I_Tax_ID = TCFC.I_Tax_ID
						AND TM.I_Country_ID = TCFC.I_Country_ID AND TCFC.N_Tax_Rate > 0
						AND @ReceiptDate BETWEEN TCFC.Dt_Valid_From AND TCFC.Dt_Valid_To
						)
				) TAX
				INNER JOIN #RTMP RTM ON RTM.InvoiceDetailID = @InvoiceDetailID
			END
			SET @row = @row + 1
		END
		DROP TABLE #RTMP
		DROP TABLE #RTMPX
	END
END
