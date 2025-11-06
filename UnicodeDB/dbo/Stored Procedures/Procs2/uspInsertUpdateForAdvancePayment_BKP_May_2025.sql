
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertUpdateForAdvancePayment_BKP_May_2025] --exec uspInsertUpdateForAdvancePayment 695056
(
	@uspReceiptDetailId INT = NULL	
)
	
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #RTMP(
		ID INT IDENTITY(1,1),
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

	CREATE TABLE #RTMCH(
		ID INT IDENTITY(1,1),
		CHTotAdvAmt NUMERIC(18,2) DEFAULT 0,
		CHInvoiceChildHeaderID int,
		CHReceiptDate DATE,
		CHReceiptHeaderID int,
		CHFeeComponentID int
	)

	INSERT INTO #RTMP(ReceiptHeaderID,InvoiceChildHeaderID,ReceiptComponentDetailID,InvoiceDetailID,
					  FeeComponentID,ReceiptDate,InstallmentNo,InstallmentDate,AmountDue,AmountPaid,AmountAdvColn)
	SELECT RH.I_Receipt_Header_ID, TICD.I_Invoice_Child_Header_ID, TRCD.I_Receipt_Comp_Detail_ID, TICD.I_Invoice_Detail_ID, 
		   TICD.I_Fee_Component_ID, RH.Dt_Receipt_Date, TICD.I_Installment_No, TICD.Dt_Installment_Date, TICD.N_Amount_Due, TRCD.N_Amount_Paid, TICD.N_Amount_Adv_Coln
	FROM T_Receipt_Component_Detail TRCD
	INNER JOIN T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
	INNER JOIN (SELECT I_Receipt_Header_ID, Dt_Receipt_Date FROM T_Receipt_Header WHERE I_Receipt_Header_ID = @uspReceiptDetailId) AS RH
	ON RH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
	WHERE TRCD.I_Receipt_Detail_ID = @uspReceiptDetailId
	AND CONVERT(DATE, RH.Dt_Receipt_Date) < CONVERT(DATE, TICD.Dt_Installment_Date)
	AND CONVERT(DATE, RH.Dt_Receipt_Date) >= CONVERT(DATE,GETDATE())
	AND TRCD.N_Amount_Paid > 0
	ORDER BY TICD.I_Invoice_Detail_ID asc

	DECLARE @row INT = 1
	DECLARE @count INT

	DECLARE @chrow INT = 1
	DECLARE @chcount INT

	DECLARE @idtInvoiceDetailId INT
	DECLARE @idtAdvMapInvoiceDetailId INT

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

	DECLARE @iInvoiceNo VARCHAR(256)
	DECLARE @TotAdvPerInv NUMERIC(18,2)

	DECLARE @CHTotAdvAmt NUMERIC(18,2)
	DECLARE @CHInvoiceChildHeaderID int
	DECLARE @CHReceiptDate DATE
	DECLARE @CHReceiptHeaderID int
	DECLARE @CHFeeComponentID int

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
			SET @TotAdvPerInv = (@AmountAdvColn + @AmountPaid)

			SELECT TOP(1) @InvoiceHeaderID = I_Invoice_Header_ID FROM T_Invoice_Child_Header WHERE I_Invoice_Child_Header_ID = @InvoiceChildHeaderID

			EXEC dbo.uspGenerateInvoiceNumber @InvoiceHeaderID, @InstallmentNo, @InstallmentDate,'I',@iInvoiceNo OUTPUT

			-----update existing records T_Invoice_Child_Detail
			UPDATE T_Invoice_Child_Detail  
			SET N_Amount_Adv_Coln = @TotAdvPerInv,
				S_Invoice_Number =  @iInvoiceNo
			WHERE I_Invoice_Detail_ID = @InvoiceDetailID
		
		
			-----delete existing record and insert new record into tax table
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
		SET @row = @row + 1
	END

	INSERT INTO #RTMCH(CHTotAdvAmt,CHInvoiceChildHeaderID,CHReceiptDate,CHReceiptHeaderID,CHFeeComponentID)
	SELECT SUM(ISNULL(TRCD.N_Amount_Paid,0)),
		   TICD.I_Invoice_Child_Header_ID, RH.Dt_Receipt_Date, RH.I_Receipt_Header_ID, MIN(TICD.I_Fee_Component_ID)
	FROM T_Receipt_Component_Detail TRCD
	INNER JOIN T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
	INNER JOIN (SELECT I_Receipt_Header_ID, Dt_Receipt_Date FROM T_Receipt_Header WHERE I_Receipt_Header_ID = @uspReceiptDetailId) AS RH
	ON RH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
	WHERE TRCD.I_Receipt_Detail_ID = @uspReceiptDetailId
	AND CONVERT(DATE, RH.Dt_Receipt_Date) < CONVERT(DATE, TICD.Dt_Installment_Date)
	AND CONVERT(DATE, RH.Dt_Receipt_Date) >= CONVERT(DATE,GETDATE())
	AND TRCD.N_Amount_Paid > 0
	GROUP BY TICD.I_Invoice_Child_Header_ID, RH.Dt_Receipt_Date, RH.I_Receipt_Header_ID
	ORDER BY TICD.I_Invoice_Child_Header_ID asc

	SELECT @chcount = COUNT(ID) FROM #RTMCH

	IF (@chcount>0)
	BEGIN

		WHILE (@chrow <= @chcount)
		BEGIN	
			SELECT @CHTotAdvAmt = CHTotAdvAmt,
			   @CHInvoiceChildHeaderID = CHInvoiceChildHeaderID,
			   @CHReceiptDate = CHReceiptDate,
			   @CHReceiptHeaderID = CHReceiptHeaderID,
			   @CHFeeComponentID = CHFeeComponentID
			FROM #RTMCH
			WHERE ID = @chrow

			SELECT TOP(1) @InvoiceHeaderID = I_Invoice_Header_ID FROM T_Invoice_Child_Header WHERE I_Invoice_Child_Header_ID = @CHInvoiceChildHeaderID

			EXEC dbo.uspGenerateInvoiceNumber @InvoiceHeaderID, @InstallmentNo, @CHReceiptDate,'A',@iInvoiceNo OUTPUT

			INSERT INTO T_Invoice_Child_Detail(I_Fee_Component_ID,I_Invoice_Child_Header_ID,I_Installment_No,
						Dt_Installment_Date,N_Amount_Due,I_Display_Fee_Component_ID,I_Sequence,N_Amount_Adv_Coln,Flag_IsAdvanceTax,I_Receipt_Header_ID,S_Invoice_Number)
			VALUES(@CHFeeComponentID, @CHInvoiceChildHeaderID, 
				   0, @CHReceiptDate, 0.00, 0
				   ,0
				   ,@CHTotAdvAmt
				   ,'Y'
				   ,@CHReceiptHeaderID
				   ,@iInvoiceNo)

			SET @idtInvoiceDetailId=SCOPE_IDENTITY()

			INSERT INTO T_Advance_Receipt_Mapping(I_Receipt_Header_ID,I_Invoice_Child_Header_ID,I_Invoice_Detail_ID)
			VALUES(@ReceiptHeaderID, @InvoiceChildHeaderID,@idtInvoiceDetailId)
			
			CREATE TABLE #RTMTAXN(
				ID INT IDENTITY(1,1),
				RTMTaxID INT,
				RTMTotalTaxAmount NUMERIC(18,2) DEFAULT 0					
			)
			
			CREATE TABLE #RTMTAXNW(
				ID INT IDENTITY(1,1),
				RTMTaxID INT,
				RTMTotalTaxAmount NUMERIC(18,2) DEFAULT 0					
			)
			
			CREATE TABLE #RTMPNW(
				ID INT IDENTITY(1,1),
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
			INSERT INTO #RTMPNW(ReceiptHeaderID,InvoiceChildHeaderID,ReceiptComponentDetailID,InvoiceDetailID,
							  FeeComponentID,ReceiptDate,InstallmentNo,InstallmentDate,AmountDue,AmountPaid,AmountAdvColn)
			SELECT RH.I_Receipt_Header_ID, TICD.I_Invoice_Child_Header_ID, TRCD.I_Receipt_Comp_Detail_ID, TICD.I_Invoice_Detail_ID, 
				   TICD.I_Fee_Component_ID, RH.Dt_Receipt_Date, TICD.I_Installment_No, TICD.Dt_Installment_Date, TICD.N_Amount_Due, TRCD.N_Amount_Paid, TICD.N_Amount_Adv_Coln
			FROM T_Receipt_Component_Detail TRCD
			INNER JOIN T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
			INNER JOIN (SELECT I_Receipt_Header_ID, Dt_Receipt_Date FROM T_Receipt_Header WHERE I_Receipt_Header_ID = @uspReceiptDetailId) AS RH
			ON RH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
			WHERE TRCD.I_Receipt_Detail_ID = @uspReceiptDetailId
			AND TICD.I_Invoice_Child_Header_ID = @CHInvoiceChildHeaderID
			AND CONVERT(DATE, RH.Dt_Receipt_Date) < CONVERT(DATE, TICD.Dt_Installment_Date)
			AND CONVERT(DATE, RH.Dt_Receipt_Date) >= CONVERT(DATE,GETDATE())
			AND TRCD.N_Amount_Paid > 0			

			SET @row = 1
			SELECT @count = COUNT(ID) FROM #RTMPNW
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
				FROM #RTMPNW WHERE ID = @row

				INSERT INTO T_Advance_Invoice_Child_Detail_Mapping(I_Advance_Ref_Invoice_Child_Detail_ID,I_Receipt_Component_Detail_ID,I_Invoice_Detail_ID,N_Advance_Amount)
				VALUES(@idtInvoiceDetailId,@ReceiptComponentDetailID,@InvoiceDetailID,@AmountPaid)

				SET @idtAdvMapInvoiceDetailId=SCOPE_IDENTITY()

				INSERT INTO T_Advance_Invoice_Detail_Tax_Mapping(I_Advance_Invoice_Detail_Map_ID,I_Tax_ID,N_Tax_Value)
				SELECT @idtAdvMapInvoiceDetailId, TAX.I_Tax_ID, CAST(@AmountPaid * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value
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
				
				
				INSERT INTO #RTMTAXN(RTMTaxID,RTMTotalTaxAmount)
				SELECT TAX.I_Tax_ID, CAST(@AmountPaid * TAX.N_Tax_Rate / 100.00 AS NUMERIC(18,2)) AS N_Tax_Value
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
				
				SET @row = @row + 1				
				
			END
			
			DECLARE @rtmrow INT = 1
			DECLARE @rtmcount INT
			
			DECLARE @rtmTaxNID INT
			DECLARE @rtmTaxNAmt NUMERIC(18,2)
			
			INSERT INTO #RTMTAXNW(RTMTaxID,RTMTotalTaxAmount)
			SELECT RTMTaxID, SUM(RTMTotalTaxAmount) FROM #RTMTAXN GROUP BY RTMTaxID
			
			SELECT @rtmcount = COUNT(ID) FROM #RTMTAXNW
			
			WHILE (@rtmrow <= @rtmcount)
			BEGIN				
				SELECT @rtmTaxNID = RTMTaxID,
					   @rtmTaxNAmt = RTMTotalTaxAmount
				FROM #RTMTAXNW WHERE ID = @rtmrow
				
				INSERT INTO T_Invoice_Detail_Tax(I_Tax_ID,I_Invoice_Detail_ID,N_Tax_Value,N_Tax_Value_Scheduled)
				VALUES(@rtmTaxNID,@idtInvoiceDetailId,0,@rtmTaxNAmt)
				
				SET @rtmrow = @rtmrow + 1
			END
			
			SET @chrow = @chrow + 1
			
			DROP TABLE #RTMPNW
			DROP TABLE #RTMTAXN
			DROP TABLE #RTMTAXNW
		END
	END
	DROP TABLE #RTMP
	DROP TABLE #RTMCH
END
