CREATE PROCEDURE [REPORT].[PriorMonthCollectionChequeReport]
(
@dtStartDate DATE,
@dtEndDate DATE
)
AS
BEGIN


CREATE table #temptable
(
BrandName varchar(100),
CenterName varchar(100),
ReceiptAmountN numeric(20),
TaxAmountN numeric(20),
ReceiptHeaderID int,
ReceiptNo varchar(10),
InvoiceHeaderID int,
ReceiptDate Date,
StudentDetailID int,
PaymentMode int,
CenterID int,
EnquiryID int,
ReceiptAmount numeric(10),
FundTransferStatus varchar(1),
StatusID int,
CreditCardExpiry Date,
CreditCardIssuer varchar(50),
CanncellationReason varchar(250),
CreditCardNo numeric(16),
ChequeDDNo numeric(20),
DDDate Date,
BankName varchar(100),
BranchName varchar(100),
ReceiptType int,
CrtdBy varchar(100),
UpdtBy varchar(100),
CrtdOn Date,
UpdtOn Date,
NTaxAmount numeric(20),
NAmountRff numeric(20),
NReceiptTaxRff numeric(20),
AdjustmentRemarks varchar(20),
BankAccounNAme varchar(100),
DepositDate Date,
Narration varchar(100),
Total numeric(20) 
)
INSERT INTO #temptable
(
BrandName,
CenterName,
ReceiptAmountN,
TaxAmountN,
ReceiptHeaderID,
ReceiptNo,
InvoiceHeaderID,
ReceiptDate,
StudentDetailID,
PaymentMode,
CenterID,
EnquiryID,
ReceiptAmount,
FundTransferStatus,
StatusID,
CreditCardExpiry,
CreditCardIssuer,
CanncellationReason,
CreditCardNo,
ChequeDDNo,
DDDate,
BankName,
BranchName,
ReceiptType,
CrtdBy,
UpdtBy,
CrtdOn,
UpdtOn,
NTaxAmount,
NAmountRff,
NReceiptTaxRff,
AdjustmentRemarks,
BankAccounNAme,
DepositDate,
Narration,
Total
)
select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as total 

--SELECT SUM(N_Receipt_Amount+N_Tax_Amount)
   from T_Receipt_Header a 
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and
 a.I_PaymentMode_ID in (2,3,4) --AND b.I_Brand_ID=107 --AND a.I_Status=1
and ( CONVERT(DATE,Dt_Receipt_Date)<@dtStartDate)
AND (CONVERT(DATE,Dt_Deposit_Date) BETWEEN @dtStartDate AND @dtEndDate)
AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>@dtEndDate))

select * from #temptable

END
