
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec [dbo].[usp_ERP_InitiateTransaction] 1,1,'string545','2024-05-31','Initiated','Online App_Arivoo','UPI',10475,1,32,'24-0044'
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_InitiatePaymentTransaction]
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@iCenterID INT = NULL,
	@sTransactionNo NVARCHAR(MAX),
	@dtTransactionDate datetime,
	@sTransactionStatus NVARCHAR(MAX),
	@sTransactionSource NVARCHAR(MAX),
	@sTransactionMode NVARCHAR(MAX),
	@TotalTransactionAmount decimal(8,2),
	@iPaymentGatewayBrandID INT,
	@iSmsPaymentMode INT,
	@sStudentID NVARCHAR(MAX),
	@XmlData XML='<Root></Root/>',
	@PaymentJson NVARCHAR(MAX)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
        -- Your existing code...
   BEGIN TRANSACTION;	

	DECLARE @StudentDetailID INT
	DECLARE @sErrorMSG NVARCHAR(4000)


	select @StudentDetailID=I_Student_Detail_ID from T_Student_Detail where S_Student_ID=@sStudentID

	IF @StudentDetailID IS NULL
	BEGIN

	set  @sErrorMSG='Student ID does not exists';

    RAISERROR(@sErrorMSG, 11, 1);

	END

	IF @iCenterID IS NULL
	select top 1 @iCenterID=I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@iBrandID and I_Status=1


 -- Create temporary tables
    CREATE TABLE #FeeScheduleTable (
        FeeScheduleID INT PRIMARY KEY
    );

    CREATE TABLE #InvoiceTable (
        FeeScheduleID INT,
        InvoiceDetailID INT,
        ReceiptDetailID INT,
        AmountPaid DECIMAL(18, 2)
    );

    CREATE TABLE #AdhocDetailsTable (
        FeeScheduleID INT,
		StatusValue INT,
        Amount DECIMAL(18, 2),
        InvoiceNo NVARCHAR(50),
        InstallmentDate DATETIME
    );

    CREATE TABLE #InvoiceTaxTable (
        InvoiceDetailID INT,
        TaxID INT,
        TaxPaid DECIMAL(18, 2)
    );

    CREATE TABLE #OnAccountTaxTable (
        InvoiceNo NVARCHAR(50),
        TaxID INT,
        TaxPaid DECIMAL(18, 2)
    );

    -- XML data
--    DECLARE @XmlData XML = '<Root>
--       <RowFeeSheduleDtl FeeScheduleID="19">
--	<TblRctCompDtl>
--		<RowRctCompDtl I_Invoice_Detail_ID="121" I_Receipt_Detail_ID="0" N_Amount_Paid="10375.00">
--			<TblRctTaxDtl>
--				<RowRctTaxDtl I_Tax_ID="0" I_Receipt_Comp_Detail_ID="0" I_Invoice_Detail_ID="121" N_Tax_Paid="200.00" />
--			</TblRctTaxDtl>
--		</RowRctCompDtl>
--		<RowRctCompDtl I_Invoice_Detail_ID="121" I_Receipt_Detail_ID="0" N_Amount_Paid="10375.00">
--			<TblRctTaxDtl>
--				<RowRctTaxDtl I_Tax_ID="0" I_Receipt_Comp_Detail_ID="0" I_Invoice_Detail_ID="121" N_Tax_Paid="200.00" />
--			</TblRctTaxDtl>
--		</RowRctCompDtl>
--	</TblRctCompDtl>
--	<TblDueOnAccountDtl>
--		<RowDueOnAccountDtl Amount="100" InvoiceNo="TEMP/0000046" InstallmentDate="01-01-2025 00:00:00" StatusValue="32">
--			<ReceiptTax>
--				<TaxDetails TaxID="0" TaxPaid="50.00" />
--				<TaxDetails TaxID="0" TaxPaid="30.00" />
--			</ReceiptTax>
--		</RowDueOnAccountDtl>
--	</TblDueOnAccountDtl>
--</RowFeeSheduleDtl>
--<RowFeeSheduleDtl FeeScheduleID="20">
--	<TblRctCompDtl>
--		<RowRctCompDtl I_Invoice_Detail_ID="123" I_Receipt_Detail_ID="0" N_Amount_Paid="10975.00">
--			<TblRctTaxDtl>
--				<RowRctTaxDtl I_Tax_ID="0" I_Receipt_Comp_Detail_ID="0" I_Invoice_Detail_ID="123" N_Tax_Paid="200.00" />
--			</TblRctTaxDtl>
--		</RowRctCompDtl>
--	</TblRctCompDtl>
--	<TblDueOnAccountDtl>
--		<RowDueOnAccountDtl Amount="100" InvoiceNo="TEMP/0000047" InstallmentDate="01-01-2029 00:00:00" StatusValue="32">
--			<ReceiptTax>
--				<TaxDetails TaxID="0" TaxPaid="50.00" />
--				<TaxDetails TaxID="0" TaxPaid="30.00" />
--			</ReceiptTax>
--		</RowDueOnAccountDtl>
--	</TblDueOnAccountDtl>
--</RowFeeSheduleDtl>
--    </Root>';

    -- Insert into fee schedule table
    INSERT INTO #FeeScheduleTable (FeeScheduleID)
    SELECT FeeSchedule.value('@FeeScheduleID', 'int')
    FROM @XmlData.nodes('/Root/RowFeeSheduleDtl') AS FeeSchedules(FeeSchedule);

    -- Insert into invoice table
    INSERT INTO #InvoiceTable (FeeScheduleID, InvoiceDetailID, ReceiptDetailID, AmountPaid)
    SELECT 
        FeeSchedule.value('../../@FeeScheduleID', 'int') AS FeeScheduleID,
        InvoiceDetail.value('@I_Invoice_Detail_ID', 'int') AS InvoiceDetailID,
        InvoiceDetail.value('@I_Receipt_Detail_ID', 'int') AS ReceiptDetailID,
        InvoiceDetail.value('@N_Amount_Paid', 'decimal(18, 2)') AS AmountPaid
    FROM @XmlData.nodes('/Root/RowFeeSheduleDtl/TblRctCompDtl/RowRctCompDtl') AS FeeSchedules(FeeSchedule)
    CROSS APPLY FeeSchedule.nodes('.') AS InvoiceDetails(InvoiceDetail);

     --Insert into adhoc details table
    INSERT INTO #AdhocDetailsTable (FeeScheduleID,StatusValue, Amount, InvoiceNo, InstallmentDate)
    SELECT 
        FeeSchedule.value('../../@FeeScheduleID', 'int') AS FeeScheduleID,
		AdhocDetail.value('@StatusValue', 'int') AS StatusValue,
        AdhocDetail.value('@Amount', 'decimal(18, 2)') AS Amount,
        AdhocDetail.value('@InvoiceNo', 'nvarchar(50)') AS InvoiceNo,
        AdhocDetail.value('@InstallmentDate', 'datetime') AS InstallmentDate
    FROM @XmlData.nodes('/Root/RowFeeSheduleDtl/TblDueOnAccountDtl/RowDueOnAccountDtl') AS FeeSchedules(FeeSchedule)
    CROSS APPLY FeeSchedule.nodes('.') AS AdhocDetails(AdhocDetail);

    -- Insert into invoice tax table
    INSERT INTO #InvoiceTaxTable (InvoiceDetailID, TaxID, TaxPaid)
    SELECT 
        InvoiceDetail.value('@I_Invoice_Detail_ID', 'int') AS InvoiceDetailID,
        TaxDetail.value('@I_Tax_ID', 'int') AS TaxID,
        TaxDetail.value('@N_Tax_Paid', 'decimal(18, 2)') AS TaxPaid
    FROM @XmlData.nodes('/Root/RowFeeSheduleDtl/TblRctCompDtl/RowRctCompDtl/TblRctTaxDtl/RowRctTaxDtl') AS FeeSchedules(FeeSchedule)
    CROSS APPLY FeeSchedule.nodes('.') AS InvoiceDetails(InvoiceDetail)
    CROSS APPLY InvoiceDetail.nodes('.') AS TaxDetails(TaxDetail);

 -- Insert into on account tax table
INSERT INTO #OnAccountTaxTable (InvoiceNo, TaxID, TaxPaid)
SELECT 
    AdhocDetail.value('@InvoiceNo', 'nvarchar(50)') AS InvoiceNo,
    TaxDetails.value('@TaxID', 'int') AS TaxID,
    TaxDetails.value('@TaxPaid', 'decimal(18, 2)') AS TaxPaid
FROM @XmlData.nodes('/Root/RowFeeSheduleDtl/TblDueOnAccountDtl/RowDueOnAccountDtl') AS FeeSchedule(AdhocDetail)
CROSS APPLY AdhocDetail.nodes('ReceiptTax/TaxDetails') AS TaxDetails(TaxDetails);

      -- Drop temporary tables
    select * from  #FeeScheduleTable
	 select * from #InvoiceTable
	  select * from #AdhocDetailsTable
	   select * from #InvoiceTaxTable 
	    select * from #OnAccountTaxTable


	--insert into T_ERP_Transaction_Master 
	--(
	--I_ERP_TransactionNo,
	--I_BrandID,
	--I_CentreID,
	--I_StudentDetailID,
	--Dt_TransactionDate,
	--S_TransactionSource,
	--S_TransactionStatus,
	--I_ERP_Brand_PaymentGateway_Map_id,
	--S_TransactionMode,
	--I_TransactionTotalAmount,
	--Dt_CreatedOn,
	--I_CreatedBy,
	--PaymentDetailsXML,
	--SMSPaymentMode,
	--PaymentJson,
	--CanBeProcessed,
	--I_StatusID
	--)
	--select top 1 @sTransactionNo,@iBrandID,@iCenterID,@StudentDetailID,@dtTransactionDate,@sTransactionSource,@sTransactionStatus
	--,@iPaymentGatewayBrandID,@sTransactionMode,@TotalTransactionAmount,GETDATE(),1,@XmlData,@iSmsPaymentMode,@PaymentJson
	--,1,1

	--Declare @iTransactionMasterID INT

	--set @iTransactionMasterID=SCOPE_IDENTITY()

	--insert into T_ERP_Transaction_Invoice_Details
	--(
	--I_ERP_Transaction_Master_ID,
	--I_Invoice_Header_ID,
	--S_Installment_invoice_NO,
	--Dt_Installment_Date,
	--TotalAmoutPaid,
	--CanBeProcessed,
	--StudentID
	--)
	--select @iTransactionMasterID,IT.FeeScheduleID,CD.S_Invoice_Number,CD.Dt_Installment_Date,sum(IT.AmountPaid),1,@sStudentID  from #InvoiceTable as IT
	--inner join
	--T_Invoice_Child_Detail as CD on CD.I_Invoice_Detail_ID=IT.InvoiceDetailID
	--group by CD.S_Invoice_Number,IT.FeeScheduleID,CD.Dt_Installment_Date

	--insert into T_ERP_Transaction_Invoice_Details
	--(
	--I_ERP_Transaction_Master_ID,
	--I_Invoice_Header_ID,
	--StatusValue,
	--S_Installment_invoice_NO,
	--Dt_Installment_Date,
	--TotalAmoutPaid,
	--CanBeProcessed,
	--StudentID
	--)
	--select @iTransactionMasterID,IT.FeeScheduleID,IT.StatusValue,IT.InvoiceNo,IT.InstallmentDate,sum(IT.Amount),1,@sStudentID 
	--from #AdhocDetailsTable as IT
	--group by IT.FeeScheduleID,IT.InstallmentDate,IT.InvoiceNo,IT.StatusValue



	 
	--update ICD set ICD.is_Freezed='true' from
	--T_Invoice_Child_Detail as ICD 
	--inner join #InvoiceTable IT on ICD.I_Invoice_Detail_ID=IT.InvoiceDetailID




    -- Drop temporary tables
    DROP TABLE #FeeScheduleTable, #InvoiceTable, #AdhocDetailsTable, #InvoiceTaxTable, #OnAccountTaxTable;


	select 1 StatusFlag,'Payment has been Initiated' Message

	--exec [dbo].[usp_ERP_InitiateTransaction] 1,1,'string545','2024-05-31','Initiated','Online App_Arivoo','UPI',10475,1,32,'24-0044'

	COMMIT;
	END TRY
    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

	-- Rollback the transaction
		ROLLBACK;
        -- Raise the error
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH




END

