
CREATE PROCEDURE [LMS].[uspCalculateStudentStatusForAPI_temp](@Status VARCHAR(MAX)=NULL,@StudentDetailID INT=NULL)
AS 
    BEGIN

        DECLARE @dtDate DATETIME= GETDATE() ;
		DECLARE @i INT=1
		DECLARE @c INT=0

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

		CREATE TABLE #Std
		(
			ID INT IDENTITY(1,1),
			StudentDetailID INT,
			InvoiceHeaderID INT,
			DueAmount DECIMAL(14,2),
			IsDefaulter INT,
			IsPaymentDue INT,
			IsPreDefaulter INT,
			IsDiscontinued INT,
			IsCompleted INT,
			DefaulterDate DATETIME,
			PaymentDueDate DATETIME,
			PreDefaulterDate DATETIME
		)

		IF(@StudentDetailID IS NULL)
		BEGIN

		INSERT  INTO #Due
        EXEC [LMS].[uspGetDueReportForDate] '54',109,@dtDate,'ALL'

		END
		ELSE
		BEGIN

			INSERT  INTO #Due
			EXEC [LMS].[uspGetDueReportForDate] '54',109,@dtDate,'ALL',@StudentDetailID

		END



		IF(@StudentDetailID IS NULL)
		BEGIN

			insert into #Std(StudentDetailID,InvoiceHeaderID,DueAmount)
			select A.I_Student_Detail_ID,T1.InvoiceHeaderID,T1.Due--,dbo.fnGetCompletedStatus(A.I_Student_Detail_ID)
			from T_Student_Detail A
			left join
			(
				select T.I_Student_Detail_ID,T.InvoiceHeaderID,T.Due from
				(
					select I_Student_Detail_ID,InvoiceHeaderID,SUM(CurrentDue) as Due
					from #Due
					group by I_Student_Detail_ID,InvoiceHeaderID
					having SUM(CurrentDue)>=100
				) T
			) T1 on A.I_Student_Detail_ID=T1.I_Student_Detail_ID
			where A.S_Student_ID like '%RICE%'		

		END
		ELSE
		BEGIN

			insert into #Std(StudentDetailID,InvoiceHeaderID,DueAmount)
			select A.I_Student_Detail_ID,T1.InvoiceHeaderID,T1.Due--,dbo.fnGetCompletedStatus(A.I_Student_Detail_ID)
			from T_Student_Detail A
			left join
			(
				select T.I_Student_Detail_ID,T.InvoiceHeaderID,T.Due from
				(
					select I_Student_Detail_ID,InvoiceHeaderID,SUM(CurrentDue) as Due
					from #Due
					group by I_Student_Detail_ID,InvoiceHeaderID
					having SUM(CurrentDue)>=100
				) T
			) T1 on A.I_Student_Detail_ID=T1.I_Student_Detail_ID
			where A.S_Student_ID like '%RICE%' and A.I_Student_Detail_ID=@StudentDetailID

		END


		update T1
		set
		T1.IsDefaulter=ISNULL(T2.Defaulter,0),
		T1.DefaulterDate=T2.DefaulterDate
		from
		#Std T1
		inner join
		(
			SELECT  DISTINCT
					XX.I_Student_Detail_ID ,
					XX.InvoiceHeaderID,
					DATEADD(d,30,XX.InstalmentDate) as DefaulterDate,
					1 AS Defaulter
			FROM    ( SELECT    I_Student_Detail_ID ,
								InvoiceHeaderID,
								SUM(ISNULL(CurrentDue,0)) AS TotalDue,
								MIN(TTT.Dt_Installment_Date) as InstalmentDate
						FROM      #Due TTT
						WHERE     DATEDIFF(d,TTT.Dt_Installment_Date,GETDATE()) >= 30     
						GROUP BY  I_Student_Detail_ID,InvoiceHeaderID
						HAVING SUM(ISNULL(CurrentDue,0))>=100

					) XX
		) T2 on T1.StudentDetailID=T2.I_Student_Detail_ID and T1.InvoiceHeaderID=T2.InvoiceHeaderID


		update T1
		set
		T1.IsPaymentDue=ISNULL(T2.PayDue,0),
		T1.PaymentDueDate=T2.InstalmentDate
		from
		#Std T1
		inner join
		(
			SELECT  DISTINCT
					XX.I_Student_Detail_ID ,
					XX.InvoiceHeaderID,
					XX.InstalmentDate,
					1 AS PayDue
			FROM    ( SELECT    I_Student_Detail_ID ,
								TTT.InvoiceHeaderID,
								SUM(ISNULL(CurrentDue,0)) AS TotalDue,
								MIN(TTT.Dt_Installment_Date) as InstalmentDate
						FROM    #Due TTT
						WHERE   DATEDIFF(d,TTT.Dt_Installment_Date,GETDATE()) >=1
								and
								DATEDIFF(d,TTT.Dt_Installment_Date,GETDATE()) <=10     
						GROUP BY  I_Student_Detail_ID ,TTT.InvoiceHeaderID
						HAVING SUM(ISNULL(CurrentDue,0))>=100
					) XX
		) T2 on T1.StudentDetailID=T2.I_Student_Detail_ID and T1.InvoiceHeaderID=T2.InvoiceHeaderID


		update T1
		set
		T1.IsPreDefaulter=ISNULL(T2.PreDefaulter,0),
		T1.PreDefaulterDate=T2.PreDefaulterDate
		from
		#Std T1
		inner join
		(
			SELECT  DISTINCT
					XX.I_Student_Detail_ID ,
					XX.InvoiceHeaderID,
					XX.PreDefaulterDate,
					1 AS PreDefaulter
			FROM    ( SELECT    I_Student_Detail_ID,
								InvoiceHeaderID,
								SUM(ISNULL(CurrentDue,0)) AS TotalDue,
								MIN(DATEADD(d,30-DATEDIFF(d,TTT.Dt_Installment_Date,GETDATE()),GETDATE())) as PreDefaulterDate
						FROM    #Due TTT
						WHERE     
						DATEDIFF(d,TTT.Dt_Installment_Date,GETDATE()) >= 11
						AND
						DATEDIFF(d,TTT.Dt_Installment_Date,GETDATE()) <= 30      
						GROUP BY  I_Student_Detail_ID,InvoiceHeaderID
						HAVING SUM(ISNULL(CurrentDue,0))>=100
					) XX
		) T2 on T1.StudentDetailID=T2.I_Student_Detail_ID and T1.InvoiceHeaderID=T2.InvoiceHeaderID


		update T1
		set
		T1.IsDiscontinued=ISNULL(T2.Discontinued,0)
		from
		#Std T1
		inner join
		(
			select I_Student_Detail_ID, 1 AS Discontinued 
			from T_Student_Detail 
			where S_Student_ID like '%RICE%' and I_Status=0
		) T2 on T1.StudentDetailID=T2.I_Student_Detail_ID


		update T1
		set
		T1.IsCompleted=T2.Completed
		from
		#Std T1
		inner join
		(
			select E.I_Student_Detail_ID, 1 AS Completed 
			from 
			T_Invoice_Parent A
			inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID
			inner join T_Invoice_Batch_Map C on B.I_Invoice_Child_Header_ID=C.I_Invoice_Child_Header_ID and C.I_Status=1
			inner join T_Student_Batch_Master D on C.I_Batch_ID=D.I_Batch_ID
			inner join T_Student_Detail E on A.I_Student_Detail_ID=E.I_Student_Detail_ID
			where
			CONVERT(DATE,GETDATE())>=DATEADD(m,2,CONVERT(DATE,D.Dt_Course_Expected_End_Date)) and A.I_Status=1 and E.I_Status=1
		) T2 on T1.StudentDetailID=T2.I_Student_Detail_ID


		select @c=COUNT(*) from #Std
		
		WHILE(@i<=@c)
		BEGIN

			DECLARE @StdID INT
			DECLARE @InvID INT
			DECLARE @disc INT
			DECLARE @def INT
			DECLARE @predef INT
			DECLARE @paydue INT
			DECLARE @due DECIMAL(14,2)
			DECLARE @comp INT

			DECLARE @defdate DATETIME
			DECLARE @payduedate DATETIME
			DECLARE @predefdate DATETIME

			select 
			@StdID=StudentDetailID,
			@InvID=ISNULL(InvoiceHeaderID,0),
			@disc=ISNULL(IsDiscontinued,0),
			@def=ISNULL(IsDefaulter,0),
			@predef=ISNULL(IsPreDefaulter,0),
			@paydue=ISNULL(IsPaymentDue,0),
			@defdate=DefaulterDate,
			@payduedate=PaymentDueDate,
			@due=DueAmount,
			@predefdate=PreDefaulterDate
			from 
			#Std where ID=@i


			---DISCONTINUED (7)---
			IF(@Status IS NULL OR @Status='DISCONTINUED')
			BEGIN

				IF(@disc=1)
				BEGIN

					IF NOT EXISTS
					(
						select * from T_Student_Status where I_Status_ID=7 and I_Student_Detail_ID=@StdID and I_Status=1 and ValidTo IS NULL
					)
					BEGIN

						insert into T_Student_Status
						(
							I_Student_Detail_ID,
							I_Status_ID,
							I_Status,
							ValidFrom,
							Dt_Crtd_On,
							S_Crtd_By
						)
						VALUES
						(
							@StdID,
							7,
							@disc,
							GETDATE(),
							GETDATE(),
							'rice-group-admin'
						)

					END
					ELSE IF(ISNULL(@disc,0)=0)
					BEGIN

						UPDATE T_Student_Status 
						set 
						ValidTo=GETDATE(),
						Dt_Updt_On=GETDATE(),
						S_Updt_By='rice-group-admin',
						B_IsInQueue=0
						where
						I_Status_ID=7 and I_Student_Detail_ID=@StdID and I_Status=1 and ValidTo IS NULL

					END


				END

			END


			---COMPLETED (5)---
			IF(@Status IS NULL OR @Status='COMPLETED')
			BEGIN

				IF(@comp=1)
				BEGIN

					IF NOT EXISTS
					(
						select * from T_Student_Status where I_Status_ID=5 and I_Student_Detail_ID=@StdID and I_Status=1 and ValidTo IS NULL
					)
					BEGIN

						insert into T_Student_Status
						(
							I_Student_Detail_ID,
							I_Status_ID,
							I_Status,
							ValidFrom,
							Dt_Crtd_On,
							S_Crtd_By
						)
						VALUES
						(
							@StdID,
							5,
							@comp,
							GETDATE(),
							GETDATE(),
							'rice-group-admin'
						)

					END
					ELSE IF(ISNULL(@comp,0)=0)
					BEGIN

						UPDATE T_Student_Status 
						set 
						ValidTo=GETDATE(),
						Dt_Updt_On=GETDATE(),
						S_Updt_By='rice-group-admin',
						B_IsInQueue=0
						where
						I_Status_ID=5 and I_Student_Detail_ID=@StdID and I_Status=1 and ValidTo IS NULL

					END


				END

			END

			---DEFAULTER (3)---
			IF((@Status IS NULL OR @Status='DEFAULTER' OR @Status='FINANCIAL') and @InvID IS NOT NULL)
			BEGIN

				IF(@def=1)
				BEGIN

					IF NOT EXISTS
					(
						select * from T_Student_Status where I_Status_ID=3 and I_Student_Detail_ID=@StdID and I_Status=1 
																and ValidTo IS NULL and StatusDate=@defdate and InvoiceHeaderID=@InvID
					)
					BEGIN

						insert into T_Student_Status
						(
							I_Student_Detail_ID,
							I_Status_ID,
							I_Status,
							ValidFrom,
							Dt_Crtd_On,
							S_Crtd_By,
							InvoiceHeaderID,
							StatusDate,
							N_Due
						)
						VALUES
						(
							@StdID,
							3,
							@def,
							@defdate,
							GETDATE(),
							'rice-group-admin',
							@InvID,
							@defdate,
							@due
						)

					END
					ELSE IF(ISNULL(@def,0)=0)
					BEGIN

						UPDATE T_Student_Status 
						set 
						ValidTo=GETDATE(),
						Dt_Updt_On=GETDATE(),
						S_Updt_By='rice-group-admin',
						B_IsInQueue=0
						where
						I_Status_ID=3 and I_Student_Detail_ID=@StdID and I_Status=1 
						and ValidTo IS NULL and StatusDate=@defdate and InvoiceHeaderID=@InvID
						and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE())

					END


				END

			END

			---PAYMENT DUE (9)---
			IF((@Status IS NULL OR @Status='PAYMENTDUE' OR @Status='FINANCIAL') and @InvID IS NOT NULL)
			BEGIN

				IF(@paydue=1)
				BEGIN

					IF NOT EXISTS
					(
						select * from T_Student_Status where I_Status_ID=9 and I_Student_Detail_ID=@StdID and I_Status=1 
																and ValidTo IS NULL and StatusDate=@payduedate and InvoiceHeaderID=@InvID
					)
					BEGIN

						insert into T_Student_Status
						(
							I_Student_Detail_ID,
							I_Status_ID,
							I_Status,
							ValidFrom,
							Dt_Crtd_On,
							S_Crtd_By,
							InvoiceHeaderID,
							StatusDate,
							N_Due
						)
						VALUES
						(
							@StdID,
							9,
							@paydue,
							@payduedate,
							GETDATE(),
							'rice-group-admin',
							@InvID,
							@payduedate,
							@due
						)

					END
					ELSE IF(ISNULL(@paydue,0)=0)
					BEGIN

						UPDATE T_Student_Status 
						set 
						ValidTo=GETDATE(),
						Dt_Updt_On=GETDATE(),
						S_Updt_By='rice-group-admin',
						B_IsInQueue=0
						where
						I_Status_ID=9 and I_Student_Detail_ID=@StdID and I_Status=1 
						and ValidTo IS NULL and InvoiceHeaderID=@InvID
						and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE())

					END


				END

			END


			---PREDEFAULTER (8)---
			IF((@Status IS NULL OR @Status='PREDEFAULTER' OR @Status='FINANCIAL') and @InvID IS NOT NULL)
			BEGIN

				IF(@predef=1)
				BEGIN

					IF NOT EXISTS
					(
						select * from T_Student_Status where I_Status_ID=8 and I_Student_Detail_ID=@StdID and I_Status=1 
																and ValidTo IS NULL and StatusDate=@payduedate and InvoiceHeaderID=@InvID
					)
					BEGIN

						insert into T_Student_Status
						(
							I_Student_Detail_ID,
							I_Status_ID,
							I_Status,
							ValidFrom,
							Dt_Crtd_On,
							S_Crtd_By,
							InvoiceHeaderID,
							StatusDate,
							N_Due
						)
						VALUES
						(
							@StdID,
							8,
							@predef,
							@predefdate,
							GETDATE(),
							'rice-group-admin',
							@InvID,
							@predefdate,
							@due
						)

					END
					ELSE IF(ISNULL(@predef,0)=0)
					BEGIN

						UPDATE T_Student_Status 
						set 
						ValidTo=GETDATE(),
						Dt_Updt_On=GETDATE(),
						S_Updt_By='rice-group-admin',
						B_IsInQueue=0
						where
						I_Status_ID=8 and I_Student_Detail_ID=@StdID and I_Status=1 
						and ValidTo IS NULL and InvoiceHeaderID=@InvID
						and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE())

					END


				END

			END


			SET @i=@i+1

		END
        
		

		IF(@StudentDetailID IS NULL)
		BEGIN

			UPDATE T_Student_Status
			set
			ValidTo=GETDATE(),
			Dt_Updt_On=GETDATE(),
			S_Updt_By='rice-group-admin',
			B_IsInQueue=0
			where
			CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE())
			and
			I_Status_ID IN (3,8,9)
			and
			InvoiceHeaderID NOT IN
			(
				select DISTINCT InvoiceHeaderID from #Std
			)

		END
		ELSE
		BEGIN

			UPDATE T_Student_Status
			set
			ValidTo=GETDATE(),
			Dt_Updt_On=GETDATE(),
			S_Updt_By='rice-group-admin',
			B_IsInQueue=0
			where
			CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE())
			and
			I_Status_ID IN (3,8,9)
			and
			InvoiceHeaderID NOT IN
			(
				select DISTINCT InvoiceHeaderID from #Std
			)
			and I_Student_Detail_ID=@StudentDetailID


		END
        
		IF(@Status IS NULL)
		BEGIN

			EXEC [LMS].[uspCalculateFutureStudentStatusForAPI] 'PAYMENTDUE',10
			EXEC [LMS].[uspCalculateFutureStudentStatusForAPI] 'DEFAULTER',0
			EXEC [LMS].[uspCalculateFutureStudentStatusForAPI] 'PREDEFAULTER',0

		END


        --select * from #Std
        
        DROP TABLE #Due                                       
	
	
    END
