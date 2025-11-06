CREATE PROCEDURE [dbo].[uspGetPaymentDetailsFromPayTM]
(
@sBrandName NVARCHAR(max),
@sStudentID NVARCHAR(max),
@iInvoiceHeaderID INT,
@dReceiptDate DATETIME,
@iCentreId INT,
@ReceiptAmount NUMERIC(18, 2) ,  
@ReceiptTaxAmount NUMERIC(18, 2) ,
@iReceiptType INT=2,
@sPaymentDetailsXML XML,
@iPayTMTransactionCode INT
)

AS

BEGIN

DECLARE @iBrandID INT
DECLARE @sReceiptNo nvarchar(max)=NULL
DECLARE @iStudentDetailID INT


IF @sBrandName='RICE'
	SET @iBrandID=109
	
SELECT @iStudentDetailID=TSD.I_Student_Detail_ID FROM dbo.T_Student_Detail AS TSD WHERE TSD.S_Student_ID=@sStudentID AND @sStudentID LIKE '%/RICE/%'

EXEC dbo.uspInsertReceiptHeaderFromAPI @sReceiptNo = @sReceiptNo, -- nvarchar(max)
    @iInvoiceHeaderID = @iInvoiceHeaderID, -- int
    @dReceiptDate = @dReceiptDate, -- datetime
    @iStudentDetailID = @iStudentDetailID, -- int
    @iPaymentModeID = 23, -- int
    @iCentreId = @iCentreId, -- int
    @nReceiptAmount = @ReceiptAmount, -- numeric
    @nReceiptTaxAmount = @ReceiptTaxAmount, -- numeric
    @sFundTransferStatus = 'N', -- char(1)
    @sCrtdBy = 'rice-group-admin', -- nvarchar(max)
    @dCreatedOn = @dReceiptDate, -- datetime
    @nCreditCardNo = NULL, -- numeric
    @dCreditCardExpiry = NULL, -- nvarchar(max)
    @sCreditCardIssuer = NULL, -- nvarchar(max)
    @sChequeDDNo = NULL, -- nvarchar(max)
    @dChequeDDDate = NULL, -- nvarchar(max)
    @sBankName = NULL, -- nvarchar(max)
    @sBranchName = NULL, -- nvarchar(max)
    @iReceiptType = 2, -- int
    @iBrandID = @iBrandID, -- int
    @sNarration = '', -- nvarchar(max)
    @sReceiptDetailXML=@sPaymentDetailsXML




END


