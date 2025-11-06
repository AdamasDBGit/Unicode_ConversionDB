CREATE PROCEDURE [LMS].[uspCalculateFutureStudentStatusForAPI]
(
	@StdStatus VARCHAR(MAX),
	@IntervalDays INT
)
AS
BEGIN

	DECLARE @ForDate DATETIME
	DECLARE @i INT=1
	DECLARE @c INT=0

	SET @ForDate=CONVERT(DATE,DATEADD(d,@IntervalDays,GETDATE()))

	CREATE TABLE #Due
	(
		S_Brand_Name VARCHAR(MAX),
        I_Center_ID INT,
        S_Center_Name VARCHAR(MAX),
        S_Course_Name VARCHAR(MAX),
		I_Batch_ID INT,
        S_Batch_Name VARCHAR(MAX),
		I_Student_Detail_ID INT,
        S_Student_ID VARCHAR(MAX),
        S_Student_Name VARCHAR(MAX),
        InvoiceHeaderID INT,
        S_Invoice_No VARCHAR(MAX),
        I_Invoice_Detail_ID INT,
        Dt_Installment_Date DATETIME,
        I_Installment_No INT,
        I_Fee_Component_ID INT,
        S_Component_Name VARCHAR(MAX),
        BaseAmountDue DECIMAL(14,2),
        TaxDue DECIMAL(14,2),
        TotalAmtPayable DECIMAL(14,2),
        Amount_Paid DECIMAL(14,2),
        Tax_Paid DECIMAL(14,2),
        Total_Paid DECIMAL(14,2),
        CurrentDue DECIMAL(14,2)
	)

	CREATE TABLE #Status
	(
		ID INT IDENTITY(1,1),
		StudentDetailID INT,
		InvoiceHeaderID INT,
		MaxInstalmentDate DATETIME,
		StatusID INT,
		Flag INT,
		StatusDate DATETIME,
		ValidFrom DATETIME,
		ValidTo DATETIME,
		DueAmount DECIMAL(14,2)
	)



	INSERT INTO #Due
	EXEC [LMS].[uspGetDueReportForDate] '54',109,@ForDate,'ALL'

	IF(@StdStatus='PAYMENTDUE')
	BEGIN
		INSERT INTO #Status
		select 
		T.I_Student_Detail_ID,
		T.InvoiceHeaderID,
		MAX(T.Dt_Installment_Date),
		9,
		1,
		@ForDate,
		@ForDate,
		NULL,
		SUM(ISNULL(T.CurrentDue,0))
		from #Due T
		where T.CurrentDue>100
		group by T.I_Student_Detail_ID,T.InvoiceHeaderID
		order by T.I_Student_Detail_ID,T.InvoiceHeaderID


	END
	IF(@StdStatus='DEFAULTER')
	BEGIN
		INSERT INTO #Status
		select 
		T.I_Student_Detail_ID,
		T.InvoiceHeaderID,
		MAX(T.Dt_Installment_Date),
		3,
		1,
		CASE WHEN DATEADD(d,@IntervalDays,MAX(T.Dt_Installment_Date))<@ForDate THEN DATEADD(d,@IntervalDays,MAX(T.Dt_Installment_Date))
		ELSE @ForDate END,
		CASE WHEN DATEADD(d,@IntervalDays,MAX(T.Dt_Installment_Date))<@ForDate THEN DATEADD(d,@IntervalDays,MAX(T.Dt_Installment_Date))
		ELSE @ForDate END,
		NULL,
		SUM(ISNULL(T.CurrentDue,0))
		from #Due T
		where T.CurrentDue>100
		group by T.I_Student_Detail_ID,T.InvoiceHeaderID
		order by T.I_Student_Detail_ID,T.InvoiceHeaderID


	END
	IF(@StdStatus='PREDEFAULTER')
	BEGIN
		INSERT INTO #Status
		select 
		T.I_Student_Detail_ID,
		T.InvoiceHeaderID,
		MAX(T.Dt_Installment_Date),
		8,
		1,
		DATEADD(d,30,MAX(T.Dt_Installment_Date)),
		CASE WHEN DATEADD(d,@IntervalDays,MAX(T.Dt_Installment_Date))<@ForDate THEN DATEADD(d,@IntervalDays,MAX(T.Dt_Installment_Date))
		ELSE @ForDate END,
		NULL,
		SUM(ISNULL(T.CurrentDue,0))
		from #Due T
		where T.CurrentDue>100
		group by T.I_Student_Detail_ID,T.InvoiceHeaderID
		order by T.I_Student_Detail_ID,T.InvoiceHeaderID


	END




	--select * from T_Student_Status_Master
	select @c=COUNT(*) from #Status
	select * from #Status


	WHILE(@i<=@c)
	BEGIN

		IF NOT EXISTS
		(
			select * from T_Student_Status A
			inner join 
			#Status B on A.I_Student_Detail_ID=B.StudentDetailID and A.InvoiceHeaderID=B.InvoiceHeaderID
										and A.StatusDate=B.StatusDate and A.N_Due=B.DueAmount and A.I_Status=B.Flag
										and A.I_Status_ID=B.StatusID
			where B.ID=@i
		)
		BEGIN

			IF NOT EXISTS
			(
				select * from T_Student_Status A
				inner join #Status B on A.I_Student_Detail_ID=B.StudentDetailID and A.InvoiceHeaderID=B.InvoiceHeaderID
											and A.I_Status_ID=B.StatusID and A.ValidTo IS NULL and CONVERT(DATE,A.ValidFrom)<=CONVERT(DATE,B.ValidFrom)
			)
			BEGIN

				INSERT INTO T_Student_Status
				(
					[I_Student_Detail_ID],
					[I_Status_ID],
					[I_Status],
					[N_Due],
					[StatusDate],
					[InvoiceHeaderID],
					[ValidFrom],
					[ValidTo],
					[Dt_Crtd_On],
					[S_Crtd_By]
				)
				select 
				StudentDetailID,
				StatusID,
				Flag,
				DueAmount,
				StatusDate,
				InvoiceHeaderID,
				ValidFrom,
				ValidTo,
				GETDATE(),
				'rice-group-admin'
				from 
				#Status where ID=@i

			END

		END

		SET @i=@i+1

	END



	--select * from T_Student_Status

	DROP TABLE #Due
	DROP TABLE #Status

END
