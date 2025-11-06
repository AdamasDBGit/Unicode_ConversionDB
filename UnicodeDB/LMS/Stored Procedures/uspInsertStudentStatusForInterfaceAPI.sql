CREATE PROCEDURE [LMS].[uspInsertStudentStatusForInterfaceAPI]
as
begin

	DECLARE @dtDate DATETIME=GETDATE()

	--select * from [LMS].[T_Student_Details_Interface_API]

	INSERT INTO [LMS].[T_Student_Details_Interface_API]
	(
		StudentID,
		StudentDetailID,
		StudentStatus,
		StatusFlag,
		BatchCode,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn,
		DueAmount,
		DefaulterDate,
		PayOutLink,
		MandateLink
	)
	select B.S_Student_ID,B.I_Student_Detail_ID,
	CASE WHEN A.I_Status_ID=7 THEN 'discontinued'
		 WHEN A.I_Status_ID=5 THEN 'completed'
		 WHEN A.I_Status_ID=3 THEN 'defaulter'
		 WHEN A.I_Status_ID=8 THEN 'predefaulter'
		 WHEN A.I_Status_ID=9 THEN 'paymentdue'
	END AS StudentStatus,
	A.I_Status,
	ISNULL(E.S_Batch_Code,''),
	'STATUS UPDATE',
	0,
	0,
	1,
	GETDATE(),
	A.N_Due,
	A.StatusDate,
	A.S_PayoutLink,
	A.S_MandateLink
	from 
	T_Student_Status A
	inner join T_Student_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	left join T_Invoice_Child_Header C on A.InvoiceHeaderID=C.I_Invoice_Header_ID
	left join T_Invoice_Batch_Map D on C.I_Invoice_Child_Header_ID=D.I_Invoice_Child_Header_ID and D.I_Status=1
	left join T_Student_Batch_Master E on D.I_Batch_ID=E.I_Batch_ID
	where 
	A.B_IsInQueue=0 and A.Dt_Crtd_On<=@dtDate and A.ValidTo IS NULL


	INSERT INTO [LMS].[T_Student_Details_Interface_API]
	(
		StudentID,
		StudentDetailID,
		StudentStatus,
		StatusFlag,
		BatchCode,
		ActionType,
		ActionStatus,
		NoofAttempts,
		StatusID,
		CreatedOn,
		DueAmount,
		DefaulterDate,
		PayOutLink,
		MandateLink
	)
	select B.S_Student_ID,B.I_Student_Detail_ID,
	CASE WHEN A.I_Status_ID=7 THEN 'discontinued'
		 WHEN A.I_Status_ID=5 THEN 'completed'
		 WHEN A.I_Status_ID=3 THEN 'defaulter'
		 WHEN A.I_Status_ID=8 THEN 'predefaulter'
		 WHEN A.I_Status_ID=9 THEN 'paymentdue'
	END AS StudentStatus,
	0,
	ISNULL(E.S_Batch_Code,''),
	'STATUS UPDATE',
	0,
	0,
	1,
	GETDATE(),
	A.N_Due,
	A.StatusDate,
	A.S_PayoutLink,
	A.S_MandateLink
	from 
	T_Student_Status A
	inner join T_Student_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	left join T_Invoice_Child_Header C on A.InvoiceHeaderID=C.I_Invoice_Header_ID
	left join T_Invoice_Batch_Map D on C.I_Invoice_Child_Header_ID=D.I_Invoice_Child_Header_ID and D.I_Status=1
	left join T_Student_Batch_Master E on D.I_Batch_ID=E.I_Batch_ID
	where 
	A.B_IsInQueue=0 and A.Dt_Updt_On<=@dtDate and A.ValidTo IS NOT NULL


	update T_Student_Status set B_IsInQueue=1 where B_IsInQueue=0 and Dt_Crtd_On<=@dtDate and ValidTo IS NULL
	update T_Student_Status set B_IsInQueue=1 where B_IsInQueue=0 and Dt_Updt_On<=@dtDate and ValidTo IS NOT NULL


end 
