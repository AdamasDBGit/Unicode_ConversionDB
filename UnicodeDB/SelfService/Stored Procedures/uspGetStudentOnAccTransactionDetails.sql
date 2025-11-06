CREATE PROCEDURE [SelfService].[uspGetStudentOnAccTransactionDetails](@BrandID INT, @StudentID VARCHAR(MAX), @ReceiptID INT=NULL)
AS
BEGIN

DECLARE @FIYear VARCHAR(20)
DECLARE @FIYearStartDate DATETIME
    
SELECT @FIYear = (CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)    
					ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END) 
					

    
--SELECT SUBSTRING(@FIYear,0,5) AS F_YEAR 

SET @FIYear=SUBSTRING(@FIYear,0,5)
SET @FIYearStartDate=@FIYear+'-04-01'

print DATEADD(year,1,@FIYearStartDate)

select TSD.S_Student_ID,TSD.S_First_Name+' '+ISNULL(TSD.S_Middle_Name,'')+' '+TSD.S_Last_Name as StudentName,
TCHND.S_Center_Name,TCHND.I_Center_ID,
TRH.I_Receipt_Header_ID,
TRH.S_Receipt_No,TRH.N_Receipt_Amount,TRH.N_Tax_Amount,TPMM.S_PaymentMode_Name,ISNULL(TOPM.TransactionNo,'') as TransactionID,
TRH.Dt_Crtd_On as ReceiptDate,ISNULL(TOPM.TransactionDate,TRH.Dt_Crtd_On) as TransactionDate,ISNULL(TOPM.TransactionStatus,'Success') as PaymentStatus
from T_Receipt_Header TRH
inner join T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
inner join T_PaymentMode_Master TPMM on TRH.I_PaymentMode_ID=TPMM.I_PaymentMode_ID
inner join T_Center_Hierarchy_Name_Details TCHND on TRH.I_Centre_Id=TCHND.I_Center_ID
left join SelfService.T_Online_Payment_Master TOPM on TSD.S_Student_ID=TOPM.StudentID and TRH.I_Receipt_Header_ID=TOPM.ReceiptHeaderID and TOPM.StatusID=1
where
TCHND.I_Brand_ID=@BrandID and TSD.S_Student_ID=@StudentID and TRH.I_Status=1
and TRH.I_Invoice_Header_ID is null and TRH.I_Receipt_Header_ID=@ReceiptID--ISNULL(@ReceiptID,TRH.I_Receipt_Header_ID)
--and TRH.Dt_Crtd_On>=@FIYearStartDate and TRH.Dt_Crtd_On<DATEADD(year,1,@FIYearStartDate)






--select RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date,SUM(TRCD.N_Amount_Paid) as BaseAmount,SUM(ISNULL(TDet.TaxPaid,0)) as TaxAmount
--from T_Receipt_Component_Detail TRCD
--inner join T_Invoice_Child_Detail TICD on TRCD.I_Invoice_Detail_ID=TICD.I_Invoice_Detail_ID
--inner join
--(
--	select TSD.S_Student_ID,TCHND.S_Center_Name,TCHND.I_Center_ID,TRH.I_Receipt_Header_ID,TRH.I_Invoice_Header_ID,
--	TRH.S_Receipt_No,TRH.N_Receipt_Amount,TRH.N_Tax_Amount,TPMM.S_PaymentMode_Name,'' as TransactionID,
--	TRH.Dt_Crtd_On as ReceiptDate,TRH.Dt_Crtd_On as TransactionDate,'Success' as PaymentStatus
--	from T_Receipt_Header TRH
--	inner join T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
--	inner join T_PaymentMode_Master TPMM on TRH.I_PaymentMode_ID=TPMM.I_PaymentMode_ID
--	inner join T_Center_Hierarchy_Name_Details TCHND on TRH.I_Centre_Id=TCHND.I_Center_ID
--	where
--	TCHND.I_Brand_ID=@BrandID and TSD.S_Student_ID=@StudentID and TRH.I_Status=1
--	and TRH.I_Invoice_Header_ID is not null
--	and TRH.Dt_Crtd_On>=@FIYearStartDate and TRH.Dt_Crtd_On<DATEADD(year,1,@FIYearStartDate)
--) RDet on TRCD.I_Receipt_Detail_ID=RDet.I_Receipt_Header_ID
--left join
--(
--	select A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID,SUM(TRTD.N_Tax_Paid) as TaxPaid 
--	from T_Receipt_Tax_Detail TRTD
--	inner join T_Receipt_Component_Detail A on TRTD.I_Receipt_Comp_Detail_ID=A.I_Receipt_Comp_Detail_ID
--	group by A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID
--) TDet on RDet.I_Receipt_Header_ID=TDet.I_Receipt_Detail_ID
--group by RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date








--select RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID,TFCM.S_Component_Name,
--SUM(TRCD.N_Amount_Paid) as BaseAmount,SUM(ISNULL(TDet.TaxPaid,0)) as TaxAmount
--from T_Receipt_Component_Detail TRCD
--inner join T_Invoice_Child_Detail TICD on TRCD.I_Invoice_Detail_ID=TICD.I_Invoice_Detail_ID
--inner join T_Fee_Component_Master TFCM on TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
--inner join
--(
--	select TSD.S_Student_ID,TCHND.S_Center_Name,TCHND.I_Center_ID,TRH.I_Receipt_Header_ID,TRH.I_Invoice_Header_ID,
--	TRH.S_Receipt_No,TRH.N_Receipt_Amount,TRH.N_Tax_Amount,TPMM.S_PaymentMode_Name,'' as TransactionID,
--	TRH.Dt_Crtd_On as ReceiptDate,TRH.Dt_Crtd_On as TransactionDate,'Success' as PaymentStatus
--	from T_Receipt_Header TRH
--	inner join T_Student_Detail TSD on TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
--	inner join T_PaymentMode_Master TPMM on TRH.I_PaymentMode_ID=TPMM.I_PaymentMode_ID
--	inner join T_Center_Hierarchy_Name_Details TCHND on TRH.I_Centre_Id=TCHND.I_Center_ID
--	where
--	TCHND.I_Brand_ID=@BrandID and TSD.S_Student_ID=@StudentID and TRH.I_Status=1
--	and TRH.I_Invoice_Header_ID is not null
--	and TRH.Dt_Crtd_On>=@FIYearStartDate and TRH.Dt_Crtd_On<DATEADD(year,1,@FIYearStartDate)
--) RDet on TRCD.I_Receipt_Detail_ID=RDet.I_Receipt_Header_ID
--left join
--(
--	select A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID,SUM(TRTD.N_Tax_Paid) as TaxPaid 
--	from T_Receipt_Tax_Detail TRTD
--	inner join T_Receipt_Component_Detail A on TRTD.I_Receipt_Comp_Detail_ID=A.I_Receipt_Comp_Detail_ID
--	group by A.I_Receipt_Detail_ID,TRTD.I_Invoice_Detail_ID
--) TDet on RDet.I_Receipt_Header_ID=TDet.I_Receipt_Detail_ID
--group by RDet.I_Receipt_Header_ID,TICD.S_Invoice_Number,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID,TFCM.S_Component_Name


END
