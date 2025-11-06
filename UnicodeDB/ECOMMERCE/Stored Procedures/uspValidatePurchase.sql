CREATE PROCEDURE [ECOMMERCE].[uspValidatePurchase]
(
	@TransactionAmount DECIMAL(14,2),
	@TransactionTax DECIMAL(14,2),
	@PaymentXML XML,
	@CustomerID VARCHAR(MAX)=NULL
)
AS
BEGIN

	DECLARE @ErrMessage NVARCHAR(4000)
	DECLARE @TotalPayableAmount DECIMAL(14,2)=0
	DECLARE @TotalPayableTax DECIMAL(14,2)=0

	create table #Plans
	(
		ID INT IDENTITY(1,1),
		PlanID INT,
		PlanAmount DECIMAL(14,2),
		PlanTax DECIMAL(14,2)
	)

	create table #Products
	(
		ID INT IDENTITY(1,1),
		ProductID INT,
		PlanID INT,
		ProductAmount DECIMAL(14,2),
		ProductTax DECIMAL(14,2),
		ProductCentreID INT,
		ProductFeePlanID INT,
		PaymentModeID INT,
		CouponCode VARCHAR(MAX),
		BatchID INT,
		SubscriptionAuthKey VARCHAR(MAX),
		SubscriptionStartDate DATETIME,
		CentreID INT,
		PayableAmount DECIMAL(14,2),
		PayableTax DECIMAL(14,2),
		IsCouponApplicable BIT
	)

	create table #Payables
	(
		PayableAmount DECIMAL(14,2),
		PayableTax DECIMAL(14,2),
		IsCouponApplicable BIT
	)

	CREATE TABLE #ProductExist
	(
		Flag BIT,
		ProductList VARCHAR(MAX)
	)

	DECLARE @PlanPos INT=1
	DECLARE @PlanCount INT
	DECLARE @PlanXML XML=''


	BEGIN TRY

		set @PlanCount=@PaymentXML.value('count((TblPlanPayment/RowPlanPayment))','int')

		while(@PlanPos<=@PlanCount)
		begin
	
			DECLARE @PlanID INT=0
			DECLARE @BrandID INT=0
			DECLARE @ProductPos INT=1
			DECLARE @ProductCount INT
			DECLARE @ProductXML XML=''
			DECLARE @PlanPayableAmount DECIMAL(14,2)=0
			DECLARE @PlanPayableTax DECIMAL(14,2)=0

			SET @PlanXML=@PaymentXML.query('/TblPlanPayment/RowPlanPayment[position()=sql:variable("@PlanPos")]')

			SELECT  @PlanID=T.a.value('@PlanID', 'int')
			FROM    @PlanXML.nodes('/RowPlanPayment') T ( a )

			select @BrandID=B.BrandID from ECOMMERCE.T_Plan_Master A 
			inner join ECOMMERCE.T_Plan_Brand_Map B on A.PlanID=B.PlanID and B.StatusID=1
			where A.PlanID=@PlanID

			insert into #Plans
			SELECT  T.a.value('@PlanID', 'int') ,
					T.a.value('@PaidAmount','numeric(18,2)'),
					T.a.value('@PaidTax','numeric(18,2)')
			FROM    @PlanXML.nodes('/RowPlanPayment') T ( a )
			INNER JOIN ECOMMERCE.T_Plan_Master T1 on T1.PlanID=T.a.value('@PlanID', 'int')
			WHERE
			T1.IsPublished=1 and T1.StatusID=1 and ISNULL(T1.ValidTo,GETDATE())>=GETDATE()

			

			IF((select COUNT(*) from #Plans where PlanID=@PlanID)=0)
			BEGIN

				SELECT @ErrMessage='Invalid plan id: '+CAST(@PlanID as VARCHAR(MAX))

				RAISERROR(@ErrMessage,11,1)

			END

			--Same course purchase validation

			DECLARE @CourseIDList VARCHAR(MAX)

			EXEC [ECOMMERCE].[uspValidatePlanForCustomer] @CustomerID,@PlanID,@CourseIDList OUTPUT

			IF(@CourseIDList!='')
			BEGIN

				SELECT @ErrMessage='Student enrollment invalid for following product ids : '+@CourseIDList+' under plan id '+CAST(@PlanID as VARCHAR(MAX))

				RAISERROR(@ErrMessage,11,1)

			END

			--Same course purchase validation


			set @ProductCount=@PlanXML.value('count((RowPlanPayment/TblProductPayment/RowProductPayment))','int')

			while(@ProductPos<=@ProductCount)
			begin
				
				DECLARE @ProductID INT
				DECLARE @CenterID INT=0
				DECLARE @CourseID INT=0
				DECLARE @PaymentModeID INT
				DECLARE @CouponCode VARCHAR(MAX)=NULL
				DECLARE @ID INT=0

				set @ProductXML=@PlanXML.query('/RowPlanPayment/TblProductPayment/RowProductPayment[position()=sql:variable("@ProductPos")]')

				insert into #Products
				(
					ProductID,
					PlanID,
					ProductAmount,
					ProductTax,
					ProductCentreID,
					ProductFeePlanID,
					PaymentModeID,
					CouponCode,
					BatchID,
					SubscriptionAuthKey,
					SubscriptionStartDate
				)
				SELECT  T.a.value('@ProductID', 'int') ,
						@PlanID,
						T.a.value('@PaidAmount','numeric(18,2)'),
						T.a.value('@PaidTax','numeric(18,2)'),
						T.a.value('@ProductCentreID','int'),
						T.a.value('@ProductFeePlanID','int'),
						T.a.value('@PaymentMode','int'),
						T.a.value('@CouponCode','varchar(max)'),
						T.a.value('@BatchID','int'),
						T.a.value('@AuthKey','varchar(max)'),
						T.a.value('@BillingStartDate','datetime')
				FROM    @ProductXML.nodes('/RowProductPayment') T ( a )
				INNER JOIN ECOMMERCE.T_Plan_Product_Map T1 on T1.PlanID=@PlanID and T1.ProductID=T.a.value('@ProductID', 'int')
				WHERE
				T1.StatusID=1

				SET @ID=SCOPE_IDENTITY()


				update #Products set CentreID=
				(
					select A.CenterID from ECOMMERCE.T_Product_Center_Map A
					where
					A.ProductCentreID=
					(
						SELECT  T.a.value('@ProductCentreID', 'int') from @ProductXML.nodes('/RowProductPayment') T ( a )
					)
					and A.StatusID=1 and A.IsPublished=1
				)
				where
				ID=@ID

				select @ProductID=ProductID,@CouponCode=ISNULL(CouponCode,''),@CenterID=CentreID,@PaymentModeID=PaymentModeID
				from #Products where ID=@ID

				--Enquiry Validation

					IF NOT EXISTS
					(
						select * from ECOMMERCE.T_Registration A
						inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID and B.StatusID=1
						inner join T_Enquiry_Regn_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
						where A.CustomerID=@CustomerID and A.StatusID=1 and C.I_Centre_Id=@CenterID
					)
					BEGIN

						DECLARE @MobileNo VARCHAR(MAX)=''

						select @MobileNo=A.MobileNo from ECOMMERCE.T_Registration A where A.CustomerID=@CustomerID and A.StatusID=1

						IF(@MobileNo is not null)
						BEGIN

							IF EXISTS
							(
								select * from T_Enquiry_Regn_Detail where I_Centre_Id=@CenterID and S_Mobile_No=@MobileNo
							)
							BEGIN

								--SELECT @ErrMessage='Entry with same mobile no. already exists for centreid'+CAST(@CenterID as VARCHAR(MAX))
								--RAISERROR(@ErrMessage,11,1)closed by susmita

								--modify by susmita
								IF EXISTS
								(
									select * from T_Enquiry_Regn_Detail where S_Mobile_No=@MobileNo and (I_Enquiry_Status_Code < 3 or I_Enquiry_Status_Code IS NULL) and I_Centre_Id=@CenterID --modify by susmita 2022-12-16 : to make centre specific
								)

								BEGIN

									IF EXISTS
									(
										select * from T_Student_Detail where I_Enquiry_Regn_ID in (select I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail where S_Mobile_No=@MobileNo and I_Centre_Id=@CenterID) --modify by susmita 2022-12-16 : to make centre specific
									)
									BEGIN

										SELECT @ErrMessage='Entry with same mobile no. already enrolled for centreid'+CAST(@CenterID as VARCHAR(MAX))

										RAISERROR(@ErrMessage,11,1)

									END
									ELSE
									BEGIN
										update T_Enquiry_Regn_Detail set S_Mobile_No=@MobileNo+'-D' where I_Enquiry_Regn_ID in (select I_Enquiry_Regn_ID from T_Enquiry_Regn_Detail where S_Mobile_No=@MobileNo and (I_Enquiry_Status_Code < 3 or I_Enquiry_Status_Code IS NULL) and I_Centre_Id=@CenterID) --modify by susmita 2022-12-16 : to make centre specific
									END
										


								END

								ELSE
								BEGIN

										SELECT @ErrMessage='Entry with same mobile no. already exists for centreid'+CAST(@CenterID as VARCHAR(MAX))

										RAISERROR(@ErrMessage,11,1)

								END
								--modify by susmita

							END

						END
						ELSE
						BEGIN

							SELECT @ErrMessage='Mobile no. cannot be null'

							RAISERROR(@ErrMessage,11,1)

						END

					END


				--Enquiry Validation


				--Batch Validation
				IF NOT EXISTS
				(
					select * from #Products A 
					inner join ECOMMERCE.T_Product_Master B on A.ProductID=B.ProductID
					inner join T_Student_Batch_Master C on A.BatchID=C.I_Batch_ID and B.CourseID=C.I_Course_ID and C.I_Status=2
					inner join T_Center_Batch_Details D on D.I_Batch_ID=A.BatchID and D.I_Centre_Id=A.CentreID and C.I_Batch_ID=D.I_Batch_ID and D.I_Status=4
					where A.ID=@ID
				)
				BEGIN

					SELECT @ErrMessage='Invalid batch for product id '+CAST(@ProductID as VARCHAR(MAX))

					RAISERROR(@ErrMessage,11,1)

				END

				--IF EXISTS
				--(
				--	select * from ECOMMERCE.T_Registration A
				--	inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID
				--	inner join T_Student_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
				--	inner join T_Student_Batch_Details D on C.I_Student_Detail_ID=D.I_Student_ID
				--	inner join #Products E on E.BatchID=D.I_Batch_ID
				--	where
				--	D.I_Status=1 and E.ID=@ID and A.CustomerID=@CustomerID
				--)
				--BEGIN

				--	SELECT @ErrMessage='You are already enrolled in this batch. Please select a different batch. Product Id: '+CAST(@ProductID as VARCHAR(MAX))

				--	RAISERROR(@ErrMessage,11,1)

				--END




				--Batch Validation

				PRINT @BrandID
				PRINT @CouponCode
				PRINT @PlanID
				PRINT @ProductID
				PRINT @CenterID
				PRINT @PaymentModeID

				insert into #Payables
				select * from [ECOMMERCE].[fnValidateProductPayables] (@BrandID,@CouponCode,@PlanID,@ProductID,@CenterID,@PaymentModeID)

				update #Products set PayableAmount=(select ISNULL(PayableAmount,0) from #Payables),
									 PayableTax=(select ISNULL(PayableTax,0) from #Payables),
									 IsCouponApplicable=(select ISNULL(IsCouponApplicable,0) from #Payables)
				where
				ID=@ID

				--select * from #Payables

				TRUNCATE TABLE #Payables


				--Validate Subscription
				--IF((select SubscriptionAuthKey from #Products where ID=@ID) IS NOT NULL and (select SubscriptionAuthKey from #Products where ID=@ID)!='' and (select PaymentModeID from #Products where ID=@ID)=1)
				--BEGIN
					
				--	SELECT @ErrMessage='Invalid subscription for product id '+CAST(@ProductID as VARCHAR(MAX))

				--	RAISERROR(@ErrMessage,11,1)

				--END

				--IF((select SubscriptionAuthKey from #Products where ID=@ID) IS NOT NULL and (select SubscriptionAuthKey from #Products where ID=@ID)!='' and (select PaymentModeID from #Products where ID=@ID)=2)
				--BEGIN

				--	IF((select SubscriptionStartDate from #Products where ID=@ID) IS NOT NULL and (select SubscriptionStartDate from #Products where ID=@ID)<CONVERT(DATE,GETDATE()))
				--	BEGIN

				--		SELECT @ErrMessage='Invalid Billing Start Date for product id '+CAST(@ProductID as VARCHAR(MAX))

				--		RAISERROR(@ErrMessage,11,1)

				--	END

				--END
				--Validate Subscription

				--select * from #Products


				IF((select IsCouponApplicable from #Products where ID=@ID)=0 and @CouponCode IS NOT NULL and @CouponCode!='')
				BEGIN

					SELECT @ErrMessage='Invalid coupon for product id '+CAST(@ProductID as VARCHAR(MAX))

					RAISERROR(@ErrMessage,11,1)
				END

				--select * from #Products
				--select * from #Payables

				IF((select (PayableAmount-ProductAmount)+(PayableTax-ProductTax) from #Products where ID=@ID)!=0)
				BEGIN

					SELECT @ErrMessage='Amount mismatch for product id '+CAST(@ProductID as VARCHAR(MAX))

					RAISERROR(@ErrMessage,11,1)
				END
				ELSE
				BEGIN
					
					set @PlanPayableAmount=@PlanPayableAmount+(select ProductAmount from #Products where ID=@ID)
					set @PlanPayableTax=@PlanPayableTax+(select ProductTax from #Products where ID=@ID)
					

				END

				set @ProductPos=@ProductPos+1

			end

			set @TotalPayableAmount=@TotalPayableAmount+@PlanPayableAmount
			set @TotalPayableTax=@TotalPayableTax+@PlanPayableTax


			IF((select (@PlanPayableAmount-PlanAmount)+(@PlanPayableTax-PlanTax) from #Plans where ID=@ID)!=0)
			BEGIN

				SELECT @ErrMessage='Amount mismatch for plan id '+CAST(@PlanID as VARCHAR(MAX))

				RAISERROR(@ErrMessage,11,1)

			END


			set @PlanPos=@PlanPos+1

		END

		IF((@TotalPayableAmount-@TransactionAmount)+(@TotalPayableTax-@TransactionTax)!=0)
		BEGIN

			SELECT @ErrMessage='Transaction Amount mismatch'

			RAISERROR(@ErrMessage,11,1)

		END

		--Validate Product Count Per Plan

		DECLARE @i INT=1
		DECLARE @plc INT=0

		select @plc=MAX(ID) from #Plans

		while(@i<=@plc)
		begin

			IF(
				(select COUNT(A.ProductID) from #Products A
				inner join #Plans B on A.PlanID=B.PlanID
				where
				B.ID=@i)
				!=
				(select COUNT(*) from ECOMMERCE.T_Plan_Product_Map
				where
				PlanID=
				(
					select PlanID from #Plans where ID=@i
				)
				and StatusID=1)
			  )
			BEGIN

				select @ErrMessage='Product count do not match'
				RAISERROR(@ErrMessage,11,1)

			END

			set @i=@i+1

		end

		--Validate Product Count Per Plan


		PRINT @ErrMessage

		IF(@ErrMessage IS NULL)
			select 1
		ELSE
			select 0

	
		--select * from #Plans
		--select * from #Products

	END TRY
    BEGIN CATCH
	--Error occurred:  
        --ROLLBACK TRANSACTION
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH

END



