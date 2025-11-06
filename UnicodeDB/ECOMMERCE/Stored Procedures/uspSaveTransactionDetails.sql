CREATE PROCEDURE [ECOMMERCE].[uspSaveTransactionDetails]
(
	@TransactionNo VARCHAR(MAX),
	@CustomerID VARCHAR(MAX),
	@TransactionDate DATETIME,
	@TransactionSource VARCHAR(MAX),
	@TransactionMode VARCHAR(MAX),
	@TransactionStatus VARCHAR(MAX),
	@TransactionAmount DECIMAL(14,2),
	@TransactionTax DECIMAL(14,2),
	@PaymentXML XML
)
AS
BEGIN

	DECLARE @ErrMessage NVARCHAR(4000)
	DECLARE @TransactionID INT=0
	

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
		SubscriptionPlanID VARCHAR(MAX),
		SubscriptionAuthKey VARCHAR(MAX),
		SubscriptionStartDate DATETIME,
		SubscriptionEndDate DATETIME,
		BillingPeriod DECIMAL(14,2),
		BillingAmount DECIMAL(14,2),
		CentreID INT,
		FeePlanID INT,
		DiscountSchemeID INT,
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

	DECLARE @PlanPos INT=1
	DECLARE @PlanCount INT
	DECLARE @PlanXML XML=''


	BEGIN TRY

		BEGIN TRANSACTION

		IF NOT EXISTS(select * from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
		BEGIN

				RAISERROR('Customer ID does not exist',11,1)

		END

		IF NOT EXISTS(select * from ECOMMERCE.T_Transaction_Master where TransactionNo=@TransactionNo and StatusID=1)
		BEGIN

			insert into ECOMMERCE.T_Transaction_Master
			select @TransactionNo,@CustomerID,@TransactionDate,@TransactionSource,@TransactionMode,@TransactionStatus,@TransactionAmount,@TransactionTax,
					0,0,GETDATE(),'rice-group-admin',NULL,NULL,NULL,1


			set @TransactionID=SCOPE_IDENTITY()

		END
		--ELSE
		--BEGIN

		--	select @TransactionID=TransactionID from ECOMMERCE.T_Transaction_Master where TransactionNo=@TransactionNo and StatusID=1

		--	--SELECT @ErrMessage='Duplicate Transaction No'

		--	--RAISERROR(@ErrMessage,11,1)

		--END

		IF(@TransactionID>0)
		BEGIN

			set @PlanCount=@PaymentXML.value('count((TblPlanPayment/RowPlanPayment))','int')

			while(@PlanPos<=@PlanCount)
			begin
	
				DECLARE @PlanID INT=0
				DECLARE @BrandID INT=0
				DECLARE @ProductPos INT=1
				DECLARE @ProductCount INT
				DECLARE @ProductXML XML=''
				DECLARE @TransactionPlanDetailID INT=0

				SET @PlanXML=@PaymentXML.query('/TblPlanPayment/RowPlanPayment[position()=sql:variable("@PlanPos")]')

				SELECT  @PlanID=T.a.value('@PlanID', 'int')
				FROM    @PlanXML.nodes('/RowPlanPayment') T ( a )

				select @BrandID=BrandID from ECOMMERCE.T_Plan_Master where PlanID=@PlanID

				insert into #Plans
				SELECT  T.a.value('@PlanID', 'int') ,
						T.a.value('@PaidAmount','numeric(18,2)'),
						T.a.value('@PaidTax','numeric(18,2)')
				FROM    @PlanXML.nodes('/RowPlanPayment') T ( a )
				INNER JOIN ECOMMERCE.T_Plan_Master T1 on T1.PlanID=T.a.value('@PlanID', 'int')
				WHERE
				T1.IsPublished=1 and T1.StatusID=1 and ISNULL(T1.ValidTo,GETDATE())>=GETDATE()

				insert into ECOMMERCE.T_Transaction_Plan_Details
				select @TransactionID,@PlanID, PlanAmount,PlanTax,0,0,NULL from #Plans where PlanID=@PlanID

				set @TransactionPlanDetailID=SCOPE_IDENTITY()



				IF(@TransactionPlanDetailID>0)
				BEGIN

					set @ProductCount=@PlanXML.value('count((RowPlanPayment/TblProductPayment/RowProductPayment))','int')

					while(@ProductPos<=@ProductCount)
					begin
				
						DECLARE @ProductID INT
						DECLARE @CenterID INT
						DECLARE @PaymentModeID INT
						DECLARE @CouponCode VARCHAR(MAX)=NULL
						DECLARE @ID INT=0
						DECLARE @TransactionProductDetailID INT=0

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
							SubscriptionPlanID,
							SubscriptionAuthKey,
							SubscriptionStartDate,
							SubscriptionEndDate,
							BillingPeriod,
							BillingAmount
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
								T.a.value('@SubscriptionPlanID','varchar(max)'),
								T.a.value('@AuthKey','varchar(max)'),
								T.a.value('@BillingStartDate','datetime'),
								T.a.value('@BillingEndDate','datetime'),
								T.a.value('@BillingPeriod','numeric(18,2)'),
								T.a.value('@TotalBillingAmount','numeric(18,2)')
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


						update #Products set FeePlanID=
						(
							select A.CourseFeePlanID from ECOMMERCE.T_Product_FeePlan A
							where
							A.ProductFeePlanID=
							(
								SELECT  T.a.value('@ProductFeePlanID', 'int') from @ProductXML.nodes('/RowProductPayment') T ( a )
							)
							and A.StatusID=1 and A.IsPublished=1 and (A.ValidFrom<=GETDATE() and ISNULL(A.ValidTo,GETDATE())>=GETDATE())
						)
						where
						ID=@ID

						update #Products set DiscountSchemeID=
						(
							select ISNULL(A.DiscountSchemeID,0) from ECOMMERCE.T_Coupon_Master A where A.CouponCode=
							(
								SELECT  T.a.value('@CouponCode', 'varchar(max)') from @ProductXML.nodes('/RowProductPayment') T ( a )
							)
							and A.StatusID=1 and (A.ValidFrom<=GETDATE() and A.ValidTo>=GETDATE())
						)

						insert into ECOMMERCE.T_Transaction_Product_Details
						select @TransactionPlanDetailID,ProductID,ProductCentreID,ProductFeePlanID,ISNULL(CouponCode,NULL),CentreID,FeePlanID,ISNULL(DiscountSchemeID,NULL),
								PaymentModeID,BatchID,ProductAmount,ProductTax,
								CASE WHEN BatchID IS NOT NULL and BatchID>0 THEN 1 ELSE 0 END,0,NULL,NULL,NULL,NULL
						from #Products where ID=@ID

						set @TransactionProductDetailID=SCOPE_IDENTITY()

						IF(@TransactionProductDetailID>0 and ISNULL((SELECT  T.a.value('@AuthKey', 'varchar(max)') from @ProductXML.nodes('/RowProductPayment') T ( a )),'')!='')
						BEGIN

							insert into ECOMMERCE.T_Transaction_Product_Subscription_Details
							select @TransactionProductDetailID,SubscriptionPlanID,SubscriptionAuthKey,BillingPeriod,SubscriptionStartDate,SubscriptionEndDate,
							BillingAmount,1
							from #Products where ID=@ID

						END

						IF(@TransactionStatus!='Failure')
						BEGIN

							IF((select CouponCode from #Products where ID=@ID) IS NOT NULL and (select CouponCode from #Products where ID=@ID)!='')
							BEGIN

								update ECOMMERCE.T_Coupon_Master set AssignedCount=AssignedCount+1
								where
								CouponCode COLLATE DATABASE_DEFAULT=
								(
									select ISNULL(A.CouponCode,'') COLLATE DATABASE_DEFAULT 
									from #Products A
									inner join ECOMMERCE.T_Coupon_Master B on A.CouponCode COLLATE DATABASE_DEFAULT=B.CouponCode COLLATE DATABASE_DEFAULT
									where A.ID=@ID and CONVERT(DATE,B.ValidTo)>=CONVERT(DATE,GETDATE()) and B.CouponCount>=AssignedCount+1
								)
								and CouponCount>=AssignedCount+1

							END

						END


						set @ProductPos=@ProductPos+1

					end

				END

				IF(
					(select SUM(CanBeProcessed) from ECOMMERCE.T_Transaction_Product_Details where TransactionPlanDetailID=@TransactionPlanDetailID)
					=
					(select COUNT(*) from ECOMMERCE.T_Transaction_Product_Details where TransactionPlanDetailID=@TransactionPlanDetailID)
				)
				BEGIN

					Update ECOMMERCE.T_Transaction_Plan_Details set CanBeProcessed=1 
					where 
					TransactionID=@TransactionID and TransactionPlanDetailID=@TransactionPlanDetailID

				END

				set @PlanPos=@PlanPos+1

			END

		END

		IF(
			((select SUM(CanBeProcessed) from ECOMMERCE.T_Transaction_Plan_Details where TransactionID=@TransactionID)
			=
			(select COUNT(*) from ECOMMERCE.T_Transaction_Plan_Details where TransactionID=@TransactionID))
			and
			((select TransactionStatus from ECOMMERCE.T_Transaction_Master where TransactionID=@TransactionID)='Success')
		  )
		BEGIN

			Update ECOMMERCE.T_Transaction_Master set CanBeProcessed=1 
			where 
			TransactionID=@TransactionID

		END
		


		--IF(@ErrMessage IS NULL)
		--	select 1
		--ELSE
		--	select 0

	
		--select * from #Plans
		--select * from #Products

		COMMIT TRANSACTION

	END TRY
    BEGIN CATCH
	--Error occurred:  
        ROLLBACK TRANSACTION
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH

END



