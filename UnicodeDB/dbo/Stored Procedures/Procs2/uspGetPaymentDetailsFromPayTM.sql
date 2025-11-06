CREATE PROCEDURE [dbo].[uspGetPaymentDetailsFromPayTM]
(
@sBrandName NVARCHAR(MAX),
@sStudentID NVARCHAR(MAX),
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
DECLARE @sReceiptNo VARCHAR(MAX)=NULL
DECLARE @iStudentDetailID INT


IF @sBrandName='RICE'
	SET @iBrandID=109
	
SELECT @iStudentDetailID=TSD.I_Student_Detail_ID FROM dbo.T_Student_Detail AS TSD WHERE TSD.S_Student_ID=@sStudentID AND @sStudentID LIKE '%/RICE/%'

EXEC dbo.uspInsertReceiptHeaderFromAPI @sReceiptNo = @sReceiptNo, -- varchar(20)
    @iInvoiceHeaderID = @iInvoiceHeaderID, -- int
    @dReceiptDate = @dReceiptDate, -- datetime
    @iStudentDetailID = @iStudentDetailID, -- int
    @iPaymentModeID = 23, -- int
    @iCentreId = @iCentreId, -- int
    @nReceiptAmount = @ReceiptAmount, -- numeric
    @nReceiptTaxAmount = @ReceiptTaxAmount, -- numeric
    @sFundTransferStatus = 'N', -- char(1)
    @sCrtdBy = 'rice-group-admin', -- varchar(20)
    @dCreatedOn = @dReceiptDate, -- datetime
    @nCreditCardNo = NULL, -- numeric
    @dCreditCardExpiry = NULL, -- varchar(12)
    @sCreditCardIssuer = NULL, -- varchar(500)
    @sChequeDDNo = NULL, -- varchar(20)
    @dChequeDDDate = NULL, -- varchar(12)
    @sBankName = NULL, -- varchar(50)
    @sBranchName = NULL, -- varchar(20)
    @iReceiptType = 2, -- int
    @iBrandID = @iBrandID, -- int
    @sNarration = '', -- varchar(500)
    @sReceiptDetailXML=@sPaymentDetailsXML




END

