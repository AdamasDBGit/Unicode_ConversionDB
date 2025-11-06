CREATE PROCEDURE [dbo].[uspInsertFundTransferDetails] 
(
	@iCenterID int,
	@dtFundTransferDate datetime,
	@nCourseFees numeric(18,2),
	@nOtherCollections numeric(18,2),
	@nTotalCollection numeric(18,2),
	@nRFFCompany numeric(18,2),
	@nTotalReceivable numeric(18,2),
	@nTotalShareCenter numeric(18,2),	
	@iDocumentID int,
	@sConfigXML xml,
	@ReceiptIDs xml,
	@dtDateFrom DATETIME,
	@dtDateTo DATETIME
)
AS
BEGIN TRY
	SET NOCOUNT OFF

	DECLARE @FundTransferID int
	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT
	DECLARE	@InnerDetailXML XML

	DECLARE @iReceiptID INT
	DECLARE @iFeeComponent int
	DECLARE @nAmount numeric(18,2)
	DECLARE @nCompanyShare numeric(18,2)

	DECLARE @iTaxID int
	DECLARE @nCompanyTax numeric(18,2)
	DECLARE @nBPTax numeric(18,2)

--	Insert the values is the main table
	INSERT INTO dbo.T_Fund_Transfer_Header
	(I_Centre_Id,Dt_Fund_Transfer_Date,N_CourseFees,
	N_Other_Collections,N_Total_Collection,N_RFF_Company,
	N_Total_Receivable,N_Total_Share_Center,I_Document_ID,Dt_Date_From,Dt_Date_To)
	VALUES
	(@iCenterID,@dtFundTransferDate,@nCourseFees,
	@nOtherCollections,@nTotalCollection,@nRFFCompany,
	@nTotalReceivable,@nTotalShareCenter,@iDocumentID,@dtDateFrom,@dtDateTo)

	SELECT @FundTransferID = @@IDENTITY 
	SELECT @FundTransferID

--	Insert the values of the receipts covered in this FT
	

--	Set the values of the receipts in receipt table to specift that 
--	fund transfer has been completed
	SET @AdjPosition = 1
	SET @AdjCount = @ReceiptIDs.value('count((FundTransfer/Receipt/ReceiptID))','int')
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		SET @InnerDetailXML = @ReceiptIDs.query('/FundTransfer/Receipt/ReceiptID[position()=sql:variable("@AdjPosition")]')
		SELECT	@iReceiptID = T.a.value('@ReceiptIDs','int')		
				FROM @InnerDetailXML.nodes('/ReceiptID') T(a)

		INSERT INTO dbo.T_Fund_Transfer_Details
		(I_FTD_Fund_Transfer_Header_ID,I_FTD_Receipt_Header_ID,I_Receipt_Status)
		SELECT @FundTransferID,@iReceiptID,I_Status 
		from T_Receipt_Header where I_Receipt_Header_ID = @iReceiptID

		UPDATE dbo.T_Receipt_Header
		SET S_Fund_Transfer_Status = 'Y'
		WHERE I_Receipt_Header_ID = @iReceiptID

		SET @AdjPosition = @AdjPosition + 1
	END	

--	Insert the values of the Fee Components associated with this FT
	SET @AdjPosition = 1
	SET @AdjCount = @sConfigXML.value('count((Values/FeeComponent/Items))','int')
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		SET @InnerDetailXML = @sConfigXML.query('/Values/FeeComponent/Items[position()=sql:variable("@AdjPosition")]')
		SELECT	@iFeeComponent = T.a.value('@FeeComponent','int'),
				@nAmount = T.a.value('@Amount','numeric(18,2)'),
				@nCompanyShare = T.a.value('@CompanyShare','numeric(18,2)')		
				FROM @InnerDetailXML.nodes('/Items') T(a)

		INSERT INTO dbo.T_FT_Fee_Component_Details
		(I_Fund_Transfer_Header_ID,I_Fee_Component_ID,
		N_Total_Amount,N_CompanyShare)
		VALUES
		(@FundTransferID,@iFeeComponent,
		@nAmount,@nCompanyShare)

		SET @AdjPosition = @AdjPosition + 1
	END

--	Insert the value of the Tax Components associated with this FT
	SET @AdjPosition = 1
	SET @AdjCount = @sConfigXML.value('count((Values/Tax/Items))','int')
	WHILE(@AdjPosition<=@AdjCount)
	BEGIN
		SET @InnerDetailXML = @sConfigXML.query('/Values/Tax/Items[position()=sql:variable("@AdjPosition")]')
		SELECT	@iTaxID = T.a.value('@TaxID','int'),
				@nCompanyTax = T.a.value('@CompanyTax','numeric(18,2)'),
				@nBPTax = T.a.value('@BPTax','numeric(18,2)')		
				FROM @InnerDetailXML.nodes('/Items') T(a)

		INSERT INTO dbo.T_FT_Tax_Detail
		(I_Tax_ID,I_Fund_Transfer_Header_ID,
		N_Tax_Amount_Company,N_Tax_Amount_BP)
		VALUES
		(@iTaxID,@FundTransferID,
		@nCompanyTax,@nBPTax)

		SET @AdjPosition = @AdjPosition + 1
	END


--	UPDATE THE ADJUSTMENT FOR THE CANCELLED RECEIPTS
	UPDATE dbo.T_Receipt_Header 
	SET S_Fund_Transfer_Status = 'N'
	WHERE I_Status = 0 
		AND I_Centre_ID = @iCenterID
		AND S_Fund_Transfer_Status = 'Y'
	--	AND I_Receipt_Type IN (1,2)

	

    
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
