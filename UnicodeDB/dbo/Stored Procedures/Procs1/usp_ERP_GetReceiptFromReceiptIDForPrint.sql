  
CREATE PROCEDURE [dbo].[usp_ERP_GetReceiptFromReceiptIDForPrint] --exec uspGetReceiptFromReceiptIDForFT 692452  
(  
 @iReceiptID int  
)  
  
AS  
BEGIN  
  
  
DECLARE @ReceiptDate DATETIME=NULL  
DECLARE @isNewEnvironment bit='true'  
DECLARE @DEFAULTCurrencyID INT  
DECLARE @DEFAULTCurrencyCode varchar(max)  
  
  
  
-------------------Default Currency Details---------------------------------  
select   
@DEFAULTCurrencyID=I_Currency_ID,  
@DEFAULTCurrencyCode=S_Currency_Code  
from T_Currency_Master where Is_Default=1  
  
---------------------------------------------------------------------------  
  
  
DECLARE @NextInstallmentDate table  
(installmentDate datetime);  
  
insert into @NextInstallmentDate  
-- Execute the stored procedure to get the next installment date  
EXEC [dbo].[usp_ERP_GetNextInstalmentDateForReceipt] @iReceiptID  
  
  
SELECT   
  
RH.I_Receipt_Header_ID as ReceiptHeaderID,  
RH.S_Receipt_No as ReceiptNo,  
RH.I_Invoice_Header_ID as InvoiceHeaderID,  
RH.Dt_Receipt_Date as ReceiptDate,  
RH.I_Student_Detail_ID as StudentDetailID,  
RH.I_PaymentMode_ID as PaymentModeID,  
ISNULL(CM.I_Currency_ID,@DEFAULTCurrencyID) as CurrencyID,  
ISNULL(CM.S_Currency_Code,@DEFAULTCurrencyCode) as CurrencyCode,  
RH.I_Centre_Id as CentreID,  
RH.I_Enquiry_Regn_ID as EnquiryRegnID,  
RH.N_Receipt_Amount as TotalReceiptAmount,  
RH.S_Fund_Transfer_Status as FundTransferStatus,  
RH.I_Status as StatusID,  
RH.Dt_CreditCard_Expiry as CreditCardExpiry,  
RH.S_CreditCard_Issuer as CreditCardIssuer,  
RH.S_Cancellation_Reason as CancellationReason,  
RH.N_CreditCard_No as CreditCardNo,  
COALESCE(NULLIF(RH.S_ChequeDD_No, ''), NULLIF(RH.S_Utr_No, '')) as ChequeDDNo,  
RH.Dt_ChequeDD_Date as ChequeDDDate,  
RH.S_Bank_Name as BankName,  
RH.S_Branch_Name as BranchName,  
RH.I_Receipt_Type as ReceiptTypeID,  
RH.S_Crtd_By as CreatedBy,  
RH.S_Upd_By as UpdatedBy,  
RH.Dt_Crtd_On as CreatedOn,  
RH.Dt_Upd_On as UpdatedOn,  
RH.N_Tax_Amount as TotalTaxAmount,  
RH.N_Amount_Rff as TotalAmountRff,  
RH.N_Receipt_Tax_Rff as TotalReceiptTaxRff,  
RH.S_AdjustmentRemarks as AdjustmentRemarks,  
RH.Bank_Account_Name as BankAccountName,  
RH.Dt_Deposit_Date as DepositDate,  
RH.S_Narration as Narration,  
(select installmentDate from @NextInstallmentDate) as NextInstallmentDate  
  
FROM T_Receipt_Header as RH WITH (NOLOCK)  
left join  
T_Currency_Master as CM on CM.I_Currency_ID=ISNULL(RH.I_Currency_ID,0)  
WHERE RH.I_Receipt_Header_ID = @iReceiptID  
  
  
create table #ReceiptComponentDetails  
(  
ReceiptCompDetailID INT,  
InvoiceDetailID INT,  
ReceiptDetailID INT,  
AmountPaid numeric,  
CompAmountRff numeric,  
FeeComponentID int,  
FeeComponentName varchar(max)  
)  
  
  
  
  
insert into #ReceiptComponentDetails   
SELECT  
RCD.I_Receipt_Comp_Detail_ID as ReceiptCompDetailID,  
RCD.I_Invoice_Detail_ID as InvoiceDetailID,  
RCD.I_Receipt_Detail_ID as ReceiptDetailID,  
RCD.N_Amount_Paid as AmountPaid,  
RCD.N_Comp_Amount_Rff as CompAmountRff,  
ICD.I_Fee_Component_ID as FeeComponentID,  
FCM.S_Component_Name as FeeComponentName  
FROM T_Receipt_Component_Detail RCD WITH (NOLOCK)  
INNER JOIN T_Receipt_Header RH WITH (NOLOCK)  
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH (NOLOCK)  
ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID  
LEFT JOIN T_Fee_Component_Master FCM WITH (NOLOCK) on ICD.I_Fee_Component_ID=FCM.I_Fee_Component_ID  
WHERE RH.I_Receipt_Header_ID = @iReceiptID  
  
  
select * from #ReceiptComponentDetails  
  
  
--01-07-2017 close for new logic  
--SELECT RTD.* FROM T_Receipt_Tax_Detail RTD WITH (NOLOCK)  
--INNER JOIN T_Receipt_Component_Detail RCD WITH (NOLOCK)  
--ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID  
--INNER JOIN T_Receipt_Header RH WITH (NOLOCK)  
--ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
--WHERE RH.I_Receipt_Header_ID = @iReceiptID  
  
  
/* Tax 2024-Feb-16 : Need to modify based on new GST setup */  
select  
@ReceiptDate=RH.Dt_Receipt_Date,  
@isNewEnvironment=ISNULL(TIP.Is_NewGSTEnvironment,'false')  
FROM T_Receipt_Header as RH WITH (NOLOCK)  
inner join  
T_Invoice_Parent as TIP WITH (NOLOCK)   
on RH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID  
WHERE RH.I_Receipt_Header_ID = @iReceiptID  
  
  
 --CONVERT(DATE,@ReceiptDate) < CONVERT(DATE,(select [dbo].[fnGetEnvironmentSwitchDate]()) OR ) -- Need to fetch set up from global   
 IF @isNewEnvironment='false'   
  
  BEGIN  
  
  SELECT   
  RTD.I_Receipt_Comp_Detail_ID as ReceiptCompDetailID,  
  RTD.I_Tax_ID as TaxID,  
  TM.S_Tax_Code as TaxCode,  
  RTD.I_Invoice_Detail_ID as InvoiceDetailID,  
  RTD.N_Tax_Paid as TaxPaid,  
  RTD.N_Tax_Rff as TaxRff,  
  RCD.FeeComponentID,RCD.FeeComponentName  
  FROM T_Receipt_Tax_Detail RTD WITH (NOLOCK)  
  INNER JOIN #ReceiptComponentDetails as RCD with (NOLOCK)   
  ON RTD.I_Receipt_Comp_Detail_ID=RCD.ReceiptCompDetailID AND RCD.InvoiceDetailID=RTD.I_Invoice_Detail_ID  
  INNER JOIN T_Fee_Component_Master FCM WITH (NOLOCK)  
  ON RCD.FeeComponentID = FCM.I_Fee_Component_ID  
  INNER JOIN T_Tax_Master as TM WITH (NOLOCK)  
  ON TM.I_Tax_ID=RTD.I_Tax_ID  
  WHERE RCD.ReceiptDetailID =@iReceiptID  
  ORDER BY RTD.I_Tax_ID ASC  
  
  END  
  
else  
 BEGIN  
  
  
 SELECT   
  RCD.ReceiptCompDetailID,  
  null as TaxID,  
  'CGST' as TaxCode,  
  RCD.InvoiceDetailID,  
  ISNULL(CGST.N_CGST,0) as TaxPaid,  
  ISNULL(CGST.N_CGST,0) as TaxRff,  
  RCD.FeeComponentID,RCD.FeeComponentName  
 from  
  #ReceiptComponentDetails as RCD with (NOLOCK)   
  INNER JOIN  
  T_Receipt_Component_Detail as CGST with (NOLOCK)   
  ON CGST.I_Receipt_Comp_Detail_ID=RCD.ReceiptCompDetailID  
  WHERE RCD.ReceiptDetailID =@iReceiptID and ISNULL(CGST.N_CGST,0) > 0  
  
  UNION  
  
  SELECT   
  RCD.ReceiptCompDetailID,  
  null as TaxID,  
  'SGST' as TaxCode,  
  RCD.InvoiceDetailID,  
  ISNULL(SGST.N_SGST,0) as TaxPaid,  
  ISNULL(SGST.N_SGST,0) as TaxRff,  
  RCD.FeeComponentID,RCD.FeeComponentName  
  from  
  #ReceiptComponentDetails as RCD with (NOLOCK)   
  INNER JOIN  
  T_Receipt_Component_Detail as SGST with (NOLOCK)   
  ON SGST.I_Receipt_Comp_Detail_ID=RCD.ReceiptCompDetailID  
  WHERE RCD.ReceiptDetailID =@iReceiptID and ISNULL(SGST.N_SGST,0) > 0  
  
  
  UNION  
  
  SELECT   
  RCD.ReceiptCompDetailID,  
  null as TaxID,  
  'IGST' as TaxCode,  
  RCD.InvoiceDetailID,  
  ISNULL(IGST.N_IGST,0) as TaxPaid,  
  ISNULL(IGST.N_IGST,0) as TaxRff,  
  RCD.FeeComponentID,RCD.FeeComponentName  
  from  
  #ReceiptComponentDetails as RCD with (NOLOCK)   
  INNER JOIN  
  T_Receipt_Component_Detail as IGST with (NOLOCK)   
  ON IGST.I_Receipt_Comp_Detail_ID=RCD.ReceiptCompDetailID  
  WHERE RCD.ReceiptDetailID =@iReceiptID and ISNULL(IGST.N_IGST,0) > 0  
  
  
 END  
  
  
  
SELECT TAG_ROW as TAGROW, 0 AS InvoiceDetailID, S_Invoice_Number as InvoiceNumber,   
    SUM(N_Amount_Due_OR_ADV) AS AmountDueORADV,   
    SUM(N_Tax_Value) AS TaxValue,   
    SUM(N_Tax_Value_Scheduled) AS TaxValueScheduled  
FROM(  
SELECT 'Invoice' TAG_ROW,   
  0 AS I_Invoice_Detail_ID,   
  ICD.S_Invoice_Number,   
  RCD.N_Amount_Paid AS N_Amount_Due_OR_ADV,  
  ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)  
  AS N_Tax_Value,   
  ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)  
  AS N_Tax_Value_Scheduled  
FROM T_Invoice_Child_Detail ICD  
INNER JOIN T_Receipt_Component_Detail RCD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID  
INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
WHERE RH.I_Receipt_Header_ID = @iReceiptID  
AND RCD.N_Amount_Paid > 0  
AND CONVERT(DATE, RH.Dt_Receipt_Date) >= CONVERT(DATE, ICD.Dt_Installment_Date)  
GROUP BY RCD.I_Receipt_Comp_Detail_ID, ICD.S_Invoice_Number, RCD.N_Amount_Paid) AS INV  
GROUP BY TAG_ROW, S_Invoice_Number  
UNION  
SELECT TAG_ROW, 0 AS I_Invoice_Detail_ID, S_Invoice_Number,   
    SUM(N_Amount_Due_OR_ADV) AS N_Amount_Due_OR_ADV,   
    SUM(N_Tax_Value) AS N_Tax_Value,   
    SUM(N_Tax_Value_Scheduled) AS N_Tax_Value_Scheduled  
FROM(  
SELECT 'Advance Payment' TAG_ROW, 0 AS I_Invoice_Detail_ID,   
    '' AS S_Invoice_Number,    
    RCD.N_Amount_Paid AS N_Amount_Due_OR_ADV,  
    ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)  
    AS N_Tax_Value,   
    ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)  
    AS N_Tax_Value_Scheduled  
FROM T_Invoice_Child_Detail ICD  
INNER JOIN T_Receipt_Component_Detail RCD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID  
INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
WHERE RH.I_Receipt_Header_ID = @iReceiptID  
AND RCD.N_Amount_Paid > 0  
AND CONVERT(DATE, RH.Dt_Receipt_Date) < CONVERT(DATE, ICD.Dt_Installment_Date)  
GROUP BY RCD.I_Receipt_Comp_Detail_ID, ICD.S_Invoice_Number, RCD.N_Amount_Paid) AS INV  
GROUP BY TAG_ROW, S_Invoice_Number  
  
  
  
/*--------------------------------------------- */  
  
/* On account ReceiptType and Tax */  
  
  
select  
RH.I_Receipt_Header_ID as ReceiptHeaderID,  
OnAccountComponentDetails.I_Status_Value as OnAccountComponentID,  
OnAccountComponentDetails.S_Status_Desc as OnAccountComponentName,  
RH.N_Receipt_Amount as AmountPaid  
from   
T_Receipt_Header as RH  
inner join  
T_Brand_Center_Details as BCD on RH.I_Centre_Id=BCD.I_Centre_Id  
inner join  
T_Status_Master as OnAccountComponentDetails   
on RH.I_Receipt_Type=OnAccountComponentDetails.I_Status_Value  
and OnAccountComponentDetails.I_Brand_ID=BCD.I_Brand_ID  
where RH.I_Receipt_Header_ID=@iReceiptID  
  
  
  ------ Tax --------  
  
   select  
   RH.I_Receipt_Header_ID as ReceiptHeaderID,  
    ORTD.I_Tax_ID as TaxID,  
    TM.S_Tax_Code as TaxCode,  
    ORTD.N_Tax_Paid as TaxPaid,  
    ORTD.N_Tax_Rff as TaxRff  
   from   
   T_Receipt_Header RH  
   inner join   
   T_OnAccount_Receipt_Tax as ORTD on RH.I_Receipt_Header_ID=ORTD.I_Receipt_Header_ID  
   inner join  
   T_Tax_Master as TM on TM.I_Tax_ID=ORTD.I_Tax_ID  
   where RH.I_Receipt_Header_ID=@iReceiptID  
  
  -------------------  
  
/* -------------- */  
  
  
  
  
  
  
END  