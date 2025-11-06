--exec [SelfService].[uspGetStudentTransactionDetailsByDate] 107,'23-0133',6
CREATE PROCEDURE [SelfService].[uspGetStudentTransactionDetailsByDate]
(
@BrandID INT
,@StudentID VARCHAR(MAX)
,@Interval int
)
AS
BEGIN

DECLARE @Days int
DECLARE @FIYear VARCHAR(20)
DECLARE @FIYearStartDate DATETIME
    
SELECT @FIYear = (CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)    
					ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END) 
				
SET @Days = CASE @Interval
                     WHEN 1 THEN 2 -- days
					 WHEN 2 THEN 7
					 WHEN 3 THEN 30
					 WHEN 4 THEN 60
					 WHEN 5 THEN 180
					 WHEN 6 THEN 365
                   END 
    
set @FIYearStartDate = DATEADD(DAY,-@Days,GETDATE())
print @FIYearStartDate
SET @FIYear=SUBSTRING(@FIYear,0,5)
SET @FIYearStartDate=@FIYear+'-04-01'

--print DATEADD(year,1,@FIYearStartDate)
--print @Days
--		print DATEADD(DAY,-@Days,GETDATE())	
select TSD.S_Student_ID S_Student_ID,TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name as StudentName,
ISNULL(TCHND.S_Center_Name,'') S_Center_Name
,ISNULL(TCHND.I_Center_ID,'') I_Center_ID
,ISNULL(TCM.I_Course_ID,'') I_Course_ID
,ISNULL(TCM.S_Course_Name,'') S_Course_Name
,ISNULL(TSBM.I_Batch_ID,'') I_Batch_ID
,ISNULL(TSBM.S_Batch_Name,'') S_Batch_Name
,ISNULL(TRH.I_Receipt_Header_ID,0) I_Receipt_Header_ID
,ISNULL(TRH.I_Invoice_Header_ID,0) I_Invoice_Header_ID
,ISNULL(TRH.S_Receipt_No,0) S_Receipt_No
,ISNULL(TRH.N_Receipt_Amount,0) N_Receipt_Amount
,ISNULL(TRH.N_Tax_Amount,0) N_Tax_Amount
,ISNULL(TPMM.S_PaymentMode_Name,'') S_PaymentMode_Name
,'' as TransactionID
,ISNULL(TRH.Dt_Crtd_On,'') as ReceiptDate
,TRH.Dt_Crtd_On as TransactionDate,'Success' as PaymentStatus
from  T_Student_Detail TSD 
 join T_Receipt_Header TRH ON  TRH.I_Status=1 and TSD.I_Student_Detail_ID = TRH.I_Student_Detail_ID
	and TRH.I_Invoice_Header_ID is not null

join T_PaymentMode_Master TPMM on TRH.I_PaymentMode_ID=TPMM.I_PaymentMode_ID
join T_Center_Hierarchy_Name_Details TCHND on TRH.I_Centre_Id=TCHND.I_Center_ID
join T_Invoice_Child_Header TICH on TRH.I_Invoice_Header_ID=TICH.I_Invoice_Header_ID and TICH.I_Course_ID IS NOT NULL
join T_Invoice_Batch_Map TIBM on TICH.I_Invoice_Child_Header_ID=TIBM.I_Invoice_Child_Header_ID
join T_Course_Master TCM on TICH.I_Course_ID=TCM.I_Course_ID
join T_Student_Batch_Master TSBM on TIBM.I_Batch_ID=TSBM.I_Batch_ID
where
TCHND.I_Brand_ID=@BrandID and TSD.S_Student_ID=@StudentID  
and TRH.Dt_Crtd_On>=DATEADD(DAY,-@Days,GETDATE()) and TRH.Dt_Crtd_On<GETDATE()

select RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date,SUM(TRCD.N_Amount_Paid) as BaseAmount,SUM(ISNULL(TDet.TaxPaid,0)) as TaxAmount
from T_Receipt_Component_Detail TRCD
inner join T_Invoice_Child_Detail TICD on TRCD.I_Invoice_Detail_ID=TICD.I_Invoice_Detail_ID
inner join
(
	select TSD.S_Student_ID,TCHND.S_Center_Name,TCHND.I_Center_ID,TRH.I_Receipt_Header_ID,TRH.I_Invoice_Header_ID,
	TRH.S_Receipt_No,TRH.N_Receipt_Amount,TRH.N_Tax_Amount,TPMM.S_PaymentMode_Name,'' as TransactionID,
	TRH.Dt_Crtd_On as ReceiptDate,TRH.Dt_Crtd_On as TransactionDate,'Success' as PaymentStatus
	from T_Receipt_Header TRH
	inner join T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	inner join T_PaymentMode_Master TPMM on TRH.I_PaymentMode_ID=TPMM.I_PaymentMode_ID
	inner join T_Center_Hierarchy_Name_Details TCHND on TRH.I_Centre_Id=TCHND.I_Center_ID
	where
	TCHND.I_Brand_ID=@BrandID and TSD.S_Student_ID=@StudentID and TRH.I_Status=1
	and TRH.I_Invoice_Header_ID is not null
	--and TRH.Dt_Crtd_On>=@FIYearStartDate and TRH.Dt_Crtd_On<DATEADD(year,1,@FIYearStartDate)
	 and TRH.Dt_Crtd_On>=DATEADD(DAY,-@Days,GETDATE()) and TRH.Dt_Crtd_On<GETDATE()
) RDet on TRCD.I_Receipt_Detail_ID=RDet.I_Receipt_Header_ID
left join
(
	select A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID,SUM(TRTD.N_Tax_Paid) as TaxPaid 
	from T_Receipt_Tax_Detail TRTD
	inner join T_Receipt_Component_Detail A on TRTD.I_Receipt_Comp_Detail_ID=A.I_Receipt_Comp_Detail_ID
	group by A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID
) TDet on RDet.I_Receipt_Header_ID=TDet.I_Receipt_Detail_ID
group by RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date








select RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID,TFCM.S_Component_Name,
SUM(TRCD.N_Amount_Paid) as BaseAmount,SUM(ISNULL(TDet.TaxPaid,0)) as TaxAmount
from T_Receipt_Component_Detail TRCD
inner join T_Invoice_Child_Detail TICD on TRCD.I_Invoice_Detail_ID=TICD.I_Invoice_Detail_ID
inner join T_Fee_Component_Master TFCM on TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
inner join
(
	select TSD.S_Student_ID,TCHND.S_Center_Name,TCHND.I_Center_ID,TRH.I_Receipt_Header_ID,TRH.I_Invoice_Header_ID,
	TRH.S_Receipt_No,TRH.N_Receipt_Amount,TRH.N_Tax_Amount,TPMM.S_PaymentMode_Name,'' as TransactionID,
	TRH.Dt_Crtd_On as ReceiptDate,TRH.Dt_Crtd_On as TransactionDate,'Success' as PaymentStatus
	from T_Receipt_Header TRH
	inner join T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	inner join T_PaymentMode_Master TPMM on TRH.I_PaymentMode_ID=TPMM.I_PaymentMode_ID
	inner join T_Center_Hierarchy_Name_Details TCHND on TRH.I_Centre_Id=TCHND.I_Center_ID
	where
	TCHND.I_Brand_ID=@BrandID and TSD.S_Student_ID=@StudentID and TRH.I_Status=1
	and TRH.I_Invoice_Header_ID is not null
	--and TRH.Dt_Crtd_On>=@FIYearStartDate and TRH.Dt_Crtd_On<DATEADD(year,1,@FIYearStartDate)
	and TRH.Dt_Crtd_On>=DATEADD(DAY,-@Days,GETDATE()) and TRH.Dt_Crtd_On<GETDATE()
) RDet on TRCD.I_Receipt_Detail_ID=RDet.I_Receipt_Header_ID
left join
(
	select A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID,SUM(TRTD.N_Tax_Paid) as TaxPaid 
	from T_Receipt_Tax_Detail TRTD
	inner join T_Receipt_Component_Detail A on TRTD.I_Receipt_Comp_Detail_ID=A.I_Receipt_Comp_Detail_ID
	group by A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID
) TDet on RDet.I_Receipt_Header_ID=TDet.I_Receipt_Detail_ID
group by RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID,TFCM.S_Component_Name


END
