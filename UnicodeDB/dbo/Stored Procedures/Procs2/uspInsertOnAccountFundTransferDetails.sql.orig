-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Insert Fund Transfer Details in the tables
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertOnAccountFundTransferDetails] 
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
	@ReceiptIDs varchar(500)
)
AS
BEGIN
	SET NOCOUNT OFF

	DECLARE @FundTransferID int

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
	N_Total_Receivable,N_Total_Share_Center,I_Document_ID)
	VALUES
	(@iCenterID,@dtFundTransferDate,@nCourseFees,
	@nOtherCollections,@nTotalCollection,@nRFFCompany,
	@nTotalReceivable,@nTotalShareCenter,@iDocumentID)

	SELECT @FundTransferID = @@IDENTITY 

--	Insert the values of the receipts covered in this FT
	INSERT INTO dbo.T_Fund_Transfer_Details
	(I_FTD_Fund_Transfer_Header_ID,I_FTD_Receipt_Header_ID)
	SELECT @FundTransferID,* FROM dbo.fnString2Rows(@ReceiptIDs,',')

--	Set the values of the receipts in receipt table to specift that 
--	fund transfer has been completed
	UPDATE dbo.T_Receipt_Header
	SET S_Fund_Transfer_Status = 'Y'
	WHERE I_Receipt_Header_ID IN 
	(SELECT * FROM dbo.fnString2Rows(@ReceiptIDs,','))

--	UPDATE THE ADJUSTMENT FOR THE CANCELLED RECEIPTS
	UPDATE dbo.T_Receipt_Header 
	SET S_Fund_Transfer_Status = 'N'
	WHERE I_Status = 0 
		AND I_Centre_ID = @iCenterID
		AND S_Fund_Transfer_Status = 'Y'
		AND I_Receipt_Type NOT IN (1,2)

    
END
