CREATE PROCEDURE [dbo].[usp_ERP_Cheque_DebitCredit_Settlement_Report_Bak]
@BrandID NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;

--bounce Debit/Credit
select S_Brand_Name,tcm.S_Center_Name,a.*,ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge((isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0)),
tbm.i_brand_id,a.Dt_Receipt_Date,a.I_PaymentMode_ID,NULL),ISNULL(a.N_Receipt_Amount,0)+ISNULL(a.N_Tax_Amount,0)) as total, c.Is_DebitCredit
from T_Receipt_Header a
inner join T_Brand_Center_Details b on a.I_Centre_Id=b.I_Centre_Id
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID
where a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30,32,34)
and c.Is_DebitCredit = 1 or c.Is_DebitCredit = 0
AND a.I_Status=0
and ( CONVERT(DATE,a.Dt_Upd_On) between '07/01/2025' and '07/31/2025') AND Dt_Deposit_Date IS NOT NULL
and b.I_Brand_ID = @BrandID;


--unsettled Debit/Credits
select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.* ,
ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge((isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0)),tbm.i_brand_id,a.Dt_Receipt_Date,
a.I_PaymentMode_ID,NULL),ISNULL(a.N_Receipt_Amount,0)+ISNULL(a.N_Tax_Amount,0)) as total,c.Is_DebitCredit
from T_Receipt_Header a
inner join T_Brand_Center_Details b on a.I_Centre_Id=b.I_Centre_Id
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID
where a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30,32,34)
and c.Is_DebitCredit = 1 or c.Is_DebitCredit = 0
and ( CONVERT(DATE,Dt_Receipt_Date) between '07/01/2025' and '07/31/2025')
AND (Dt_Deposit_Date IS NULL OR CONVERT(DATE,Dt_Deposit_Date)>'07/31/2025')
AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>'07/31/2025'))
and b.I_Brand_ID = @BrandID;


--collection deposit whose collection is prior nov debitcredit
select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,
ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge((isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0)),tbm.i_brand_id,a.Dt_Receipt_Date,
a.I_PaymentMode_ID,NULL),ISNULL(a.N_Receipt_Amount,0)+ISNULL(a.N_Tax_Amount,0)) as total, c.Is_DebitCredit
from T_Receipt_Header a
inner join T_Brand_Center_Details b on a.I_Centre_Id=b.I_Centre_Id
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID
where a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30,32,34)
and c.Is_DebitCredit = 1 or c.Is_DebitCredit = 0
and ( CONVERT(DATE,Dt_Receipt_Date)<'07/01/2025')
AND (CONVERT(DATE,Dt_Deposit_Date) BETWEEN '07/01/2025' AND '07/31/2025')
AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>='07/01/2025'))
and b.I_Brand_ID = @BrandID;


--collection reversal whose collection prior to nov and is not deposited debitcredit
select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,
ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge((isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0)),tbm.i_brand_id,a.Dt_Receipt_Date,
a.I_PaymentMode_ID,NULL),ISNULL(a.N_Receipt_Amount,0)+ISNULL(a.N_Tax_Amount,0)) as total, c.Is_DebitCredit
from T_Receipt_Header a
inner join T_Brand_Center_Details b on a.I_Centre_Id=b.I_Centre_Id
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID
where a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30,32,34)
and c.Is_DebitCredit = 1 or c.Is_DebitCredit = 0
and ( CONVERT(DATE,Dt_Receipt_Date)<'07/01/2025')
AND Dt_Deposit_Date is NULL
AND ((a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On) BETWEEN '07/01/2025' AND '07/31/2025'))
and b.I_Brand_ID = @BrandID;

END
