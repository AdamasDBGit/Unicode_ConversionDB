
CREATE PROCEDURE [LMS].[uspUpdateStudentStatusNew]
as
begin

	DECLARE @dtdate DATETIME=GETDATE()

	insert into LMS.T_Student_Details_Interface_API
	(
		StudentID,
		BatchCode,
		StudentStatus,
		StatusFlag,
		MandateLink,
		PayOutLink,
		DueAmount,
		DefaulterDate,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn
	)
	select
	B.S_Student_ID,
	ISNULL(TSBM.S_Batch_Code,''),
	CASE WHEN A.I_Status_ID=3 THEN 'defaulter'
		 WHEN A.I_Status_ID=9 THEN 'paymentdue'
		 WHEN A.I_Status_ID=7 THEN 'discontinued'
		 WHEN A.I_Status_ID=8 THEN 'predefaulter'
		 WHEN A.I_Status_ID=5 THEN 'completed'
	END,
	CASE WHEN A.ValidTo IS NULL THEN 1
		 WHEN ValidTo IS NOT NULL THEN 0
	END,
	ISNULL(A.S_MandateLink,''),
	ISNULL(A.S_PayoutLink,''),
	A.N_Due,
	A.StatusDate,
	'STATUS UPDATE',
	0,
	0,
	1,
	GETDATE()
	from 
	T_Student_Status A
	inner join T_Student_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	left join T_Invoice_Child_Header TICH on A.InvoiceHeaderID=TICH.I_Invoice_Header_ID
	left join T_Invoice_Batch_Map TIBM on TICH.I_Invoice_Child_Header_ID=TIBM.I_Invoice_Child_Header_ID and TIBM.I_Status=1
	left join T_Student_Batch_Master TSBM on TIBM.I_Batch_ID=TSBM.I_Batch_ID
	where A.B_IsInQueue=0 and A.Dt_Crtd_On<=@dtdate

	UNION ALL

	select
	B.S_Student_ID,
	ISNULL(TSBM.S_Batch_Code,''),
	CASE WHEN A.I_Status_ID=3 THEN 'defaulter'
		 WHEN A.I_Status_ID=9 THEN 'paymentdue'
		 WHEN A.I_Status_ID=7 THEN 'discontinued'
		 WHEN A.I_Status_ID=8 THEN 'predefaulter'
		 WHEN A.I_Status_ID=5 THEN 'completed'
	END,
	CASE WHEN A.ValidTo IS NULL THEN 1 ELSE 0 END,
	ISNULL(A.S_MandateLink,''),
	ISNULL(A.S_PayoutLink,''),
	A.N_Due,
	A.StatusDate,
	'STATUS UPDATE',
	0,
	0,
	1,
	GETDATE()
	from 
	T_Student_Status A
	inner join T_Student_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	left join T_Invoice_Child_Header TICH on A.InvoiceHeaderID=TICH.I_Invoice_Header_ID
	left join T_Invoice_Batch_Map TIBM on TICH.I_Invoice_Child_Header_ID=TIBM.I_Invoice_Child_Header_ID and TIBM.I_Status=1
	left join T_Student_Batch_Master TSBM on TIBM.I_Batch_ID=TSBM.I_Batch_ID
	where A.B_IsInQueue=0 and A.Dt_Updt_On<=@dtdate


	update T_Student_Status set B_IsInQueue=1 where B_IsInQueue=0 and Dt_Crtd_On<=@dtdate
	update T_Student_Status set B_IsInQueue=1 where B_IsInQueue=0 and Dt_Updt_On<=@dtdate

end 
