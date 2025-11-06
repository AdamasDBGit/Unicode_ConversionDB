CREATE Proc ERP_REPORTS.USP_ERP_Cheque_Details(@BranID Int,@Startdate date,@Enddate date)    
as begin    
--Declare @BranID int,@Startdate date ,@Enddate date    
--SET @BranID=107    
--SET @Startdate='03/01/2025'    
--SET @Enddate='03/01/2025'    
--- settled cheque    
select  'Settled Cheque' as Category, S_Brand_Name as BrandName,tcm.S_Center_Name as CenterName    
,sd.S_Student_ID   as StudentID  
,a.S_Receipt_No as ReceiptNo,a.Dt_Receipt_Date as Receiptdate,a.S_ChequeDD_No as ChequeDDNo    
,a.Dt_ChequeDD_Date as ChequeDate,    
a.S_Bank_Name as BankName    
,a.S_Branch_Name as BranchName    
,a.Bank_Account_Name as Bank_Account_Name    
,a.Dt_Deposit_Date as DepositDate    
,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as Total_Amount    
    
--SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
   from T_Receipt_Header a     
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=a.I_Student_Detail_ID    
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
 a.I_PaymentMode_ID in (2,3,4,27,31) --AND b.I_Brand_ID=107 --AND a.I_Status=1  --added 31 by susmita for loan : 2023-Feb-09    
and ( CONVERT(DATE, Dt_Deposit_Date) between @Startdate and @Enddate)  --mm/dd/yyyy    
and b.I_Brand_ID =@BranID -- added by susmita : 2024-May-13     
    
---bounce cheque    
UNION ALL    
    
select  'Bounce Cheque' as Category, S_Brand_Name as BrandName,tcm.S_Center_Name as CenterName    
,sd.S_Student_ID     
,a.S_Receipt_No,a.Dt_Receipt_Date as Receiptdate,a.S_ChequeDD_No as ChequeDDNo    
,a.Dt_ChequeDD_Date as ChequeDate,    
a.S_Bank_Name as BankName    
,a.S_Branch_Name as BranchName    
,a.Bank_Account_Name as Bank_Account_Name    
,a.Dt_Deposit_Date as Depoditdate    
,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as Total_Amount    
   from T_Receipt_Header a     
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=a.I_Student_Detail_ID    
    
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
 a.I_PaymentMode_ID in (2,3,4,27,31) --AND b.I_Brand_ID=107  --added 31 by susmita for loan : 2023-Feb-09    
 AND a.I_Status=0    
and (  CONVERT(DATE,a.Dt_Upd_On) between @Startdate and @Enddate) AND Dt_Deposit_Date IS NOT NULL    
and b.I_Brand_ID =@BranID -- added by susmita : 2024-May-13     
    
---unsettle cheque    
Union ALL    
select 'Unsettle cheque' as Category, S_Brand_Name as BrandName,tcm.S_Center_Name as CenterName    
,sd.S_Student_ID     
,a.S_Receipt_No,a.Dt_Receipt_Date as Receiptdate,a.S_ChequeDD_No as ChequeDDNo    
,a.Dt_ChequeDD_Date as ChequeDate,    
a.S_Bank_Name as BankName    
,a.S_Branch_Name as BranchName    
,a.Bank_Account_Name as Bank_Account_Name    
,a.Dt_Deposit_Date as Depoditdate    
,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as Total_Amount    
    
--SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
   from T_Receipt_Header a     
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=a.I_Student_Detail_ID    
    
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
 a.I_PaymentMode_ID in (2,3,4,27,31) --AND b.I_Brand_ID=107 --AND a.I_Status=1  --added 31 by susmita for loan : 2023-Feb-09    
and ( CONVERT(DATE,Dt_Receipt_Date) between @Startdate and @Enddate)    
AND (Dt_Deposit_Date IS NULL OR CONVERT(DATE,Dt_Deposit_Date)>@Startdate)    
AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>@Enddate))    
and b.I_Brand_ID =@BranID -- added by susmita : 2024-May-13     
    
-----Need to use below part     
----collection deposit whose collection is prior nov     
--select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as total     
    
----SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
--   from T_Receipt_Header a     
--inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
--inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
--inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
--inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
--where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
-- a.I_PaymentMode_ID in (2,3,4,27,31) --AND b.I_Brand_ID=107 --AND a.I_Status=1  --added 31 by susmita for loan : 2023-Feb-09    
--and ( CONVERT(DATE,Dt_Receipt_Date)<'03/01/2025')    
--AND (CONVERT(DATE,Dt_Deposit_Date) BETWEEN '03/01/2025' AND '03/31/2025')    
----AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>'03/31/2025'))    
--AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>='03/01/2025'))--modified by Akash on 3.9.2016    
--and b.I_Brand_ID in (110,107) -- added by susmita : 2024-May-13     
    
    
----collection reversal whose collection prior to nov and is not deposited    
--select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as total     
    
----SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
--   from T_Receipt_Header a     
--inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
--inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
--inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
--inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
--where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
-- a.I_PaymentMode_ID in (2,3,4,27,31) --AND b.I_Brand_ID=107 --AND a.I_Status=1  --added 31 by susmita for loan : 2023-Feb-09    
--and ( CONVERT(DATE,Dt_Receipt_Date)<'03/01/2025')    
--AND Dt_Deposit_Date is NULL     
--AND ((a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On) BETWEEN '03/01/2025' AND '03/31/2025'))    
--and b.I_Brand_ID in (110,107) -- added by susmita : 2024-May-13     
    
    
    
--receipt details for collection prior to Nov but settled in Nov    
-----Need to use below part----End------     
    
    
    
    
--settled Debit/Credit    
Union ALL    
select 'Settled Debit/Credit' as Category, S_Brand_Name as BrandName,tcm.S_Center_Name as CenterName    
,sd.S_Student_ID     
,a.S_Receipt_No,a.Dt_Receipt_Date as Receiptdate,a.S_ChequeDD_No as ChequeDDNo    
,a.Dt_ChequeDD_Date as ChequeDate,    
a.S_Bank_Name as BankName    
,a.S_Branch_Name as BranchName    
,a.Bank_Account_Name as Bank_Account_Name    
,a.Dt_Deposit_Date as Depoditdate    
,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as Total_Amount    
    
--SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
   from T_Receipt_Header a     
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=a.I_Student_Detail_ID    
    
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
 a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30) --AND b.I_Brand_ID=107 --AND a.I_Status=1    
and ( CONVERT(DATE, Dt_Deposit_Date) between @Startdate and @Enddate)  --mm/dd/yyyy     
and b.I_Brand_ID =@BranID -- added by susmita : 2024-May-13     
    
--bounce Debit/Credit    
Union ALL    
 select 'Bounce Debit/Credit' as Category, S_Brand_Name as BrandName,tcm.S_Center_Name as CenterName    
,sd.S_Student_ID     
,a.S_Receipt_No,a.Dt_Receipt_Date as Receiptdate,a.S_ChequeDD_No as ChequeDDNo    
,a.Dt_ChequeDD_Date as ChequeDate,    
a.S_Bank_Name as BankName    
,a.S_Branch_Name as BranchName    
,a.Bank_Account_Name as Bank_Account_Name  ,a.Dt_Deposit_Date as Depoditdate    
,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as Total_Amount    
   from T_Receipt_Header a     
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=a.I_Student_Detail_ID    
    
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
 a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30) --AND b.I_Brand_ID=107     
 AND a.I_Status=0    
and (  CONVERT(DATE,a.Dt_Upd_On) between @Startdate and @Enddate) AND Dt_Deposit_Date IS NOT NULL    
and b.I_Brand_ID =@BranID -- added by susmita : 2024-May-13     
    
Union ALL    
--unsettled Debit/Credits    
    
select 'Unsettled Debit/Credits' as Category, S_Brand_Name as BrandName,tcm.S_Center_Name as CenterName    
,sd.S_Student_ID     
,a.S_Receipt_No,a.Dt_Receipt_Date as Receiptdate,a.S_ChequeDD_No as ChequeDDNo    
,a.Dt_ChequeDD_Date as ChequeDate,    
a.S_Bank_Name as BankName    
,a.S_Branch_Name as BranchName    
,a.Bank_Account_Name as Bank_Account_Name    
,a.Dt_Deposit_Date as Depoditdate    
,isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0) as Total_Amount    
    
--SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
   from T_Receipt_Header a     
inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
Inner Join T_Student_Detail sd on sd.I_Student_Detail_ID=a.I_Student_Detail_ID    
    
where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
 a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30) --AND b.I_Brand_ID=107 --AND a.I_Status=1    
and ( CONVERT(DATE,Dt_Receipt_Date) between @Startdate and @Enddate)    
AND (Dt_Deposit_Date IS NULL OR CONVERT(DATE,Dt_Deposit_Date)>@Startdate)    
AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>@Startdate))    
and b.I_Brand_ID =@BranID -- added by susmita : 2024-May-13     
--Need to add later    
--collection deposit whose collection is prior nov debitcredit    
--select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,    
--ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge((isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0)),tbm.i_brand_id,a.Dt_Receipt_Date,a.I_PaymentMode_ID,NULL),ISNULL(a.N_Receipt_Amount,0)+ISNULL(a.N_Tax_Amount,0)) as total     
    
----SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
--   from T_Receipt_Header a     
--inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
--inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
--inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
--inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
--where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
-- a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30) --AND b.I_Brand_ID=107 --AND a.I_Status=1    
--and ( CONVERT(DATE,Dt_Receipt_Date)<'03/01/2025')    
--AND (CONVERT(DATE,Dt_Deposit_Date) BETWEEN '03/01/2025' AND '03/31/2025')    
----AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>'03/31/2025'))    
--AND (a.I_Status=1 OR (a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On)>='03/01/2025'))--modified by Akash on 3.9.2016    
--and b.I_Brand_ID in (110,107) -- added by susmita : 2024-May-13     
---Need to add later----    
----collection reversal whose collection prior to nov and is not deposited debitcredit    
--select S_Brand_Name,tcm.S_Center_Name,a.N_Receipt_Amount,a.N_Tax_Amount,a.*,    
--ISNULL(dbo.fnGetReceiptAmtExcldConvenienceCharge((isnull(a.N_Receipt_Amount,0) + isnull(a.N_Tax_Amount ,0)),tbm.i_brand_id,a.Dt_Receipt_Date,a.I_PaymentMode_ID,NULL),ISNULL(a.N_Receipt_Amount,0)+ISNULL(a.N_Tax_Amount,0)) as total     
    
----SELECT SUM(N_Receipt_Amount+N_Tax_Amount)    
--   from T_Receipt_Header a     
--inner join T_Brand_Center_Details b on  a.I_Centre_Id=b.I_Centre_Id    
--inner join T_Brand_Master tbm on b.I_Brand_ID=tbm.I_Brand_ID    
--inner join T_Centre_Master tcm on a.I_Centre_Id=tcm.I_Centre_Id    
--inner join T_PaymentMode_Master c on a.I_PaymentMode_ID=c.I_PaymentMode_ID    
--where --Dt_Receipt_Date between '11/1/2013' and '11/30/2013' and    
-- a.I_PaymentMode_ID in (13,14,15,16,17,19,20,21,22,23,24,25,28,29,30) --AND b.I_Brand_ID=107 --AND a.I_Status=1    
--and ( CONVERT(DATE,Dt_Receipt_Date)<'03/01/2025')    
--AND Dt_Deposit_Date is NULL     
--AND ((a.I_Status=0 AND CONVERT(DATE,a.Dt_Upd_On) BETWEEN '03/01/2025' AND '03/31/2025'))    
--and b.I_Brand_ID in (110,107) -- added by susmita : 2024-May-13     
    
End