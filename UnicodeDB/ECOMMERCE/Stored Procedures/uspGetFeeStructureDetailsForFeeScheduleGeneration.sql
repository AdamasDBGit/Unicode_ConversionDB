CREATE PROCEDURE [ECOMMERCE].[uspGetFeeStructureDetailsForFeeScheduleGeneration]
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
			T1.IsPublished=1 and T1.StatusID=1 and T1.ValidTo>=GETDATE()

			IF((select COUNT(*) from #Plans where PlanID=@PlanID)=0)
			BEGIN

				SELECT @ErrMessage='Invalid plan id: '+CAST(@PlanID as VARCHAR(MAX))

				RAISERROR(@ErrMessage,11,1)

			END


			set @ProductCount=@PlanXML.value('count((RowPlanPayment/TblProductPayment/RowProductPayment))','int')

			while(@ProductPos<=@ProductCount)
			begin
				
				DECLARE @ProductID INT
				DECLARE @CenterID INT
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
					BatchID
				)
				SELECT  T.a.value('@ProductID', 'int') ,
						@PlanID,
						T.a.value('@PaidAmount','numeric(18,2)'),
						T.a.value('@PaidTax','numeric(18,2)'),
						T.a.value('@ProductCentreID','int'),
						T.a.value('@ProductFeePlanID','int'),
						T.a.value('@PaymentMode','int'),
						T.a.value('@CouponCode','varchar(max)'),
						T.a.value('@BatchID','int')
				FROM    @ProductXML.nodes('/RowProductPayment') T ( a )
				INNER JOIN ECOMMERCE.T_Plan_Product_Map T1 on T1.PlanID=@PlanID
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

				insert into #Payables
				select * from [ECOMMERCE].[fnValidateProductPayables] (@BrandID,@CouponCode,@PlanID,@ProductID,@CenterID,@PaymentModeID)

				update #Products set PayableAmount=(select ISNULL(PayableAmount,0) from #Payables),
									 PayableTax=(select ISNULL(PayableTax,0) from #Payables),
									 IsCouponApplicable=(select ISNULL(IsCouponApplicable,0) from #Payables)
				where
				ID=@ID

				TRUNCATE TABLE #Payables


				IF((select IsCouponApplicable from #Products where ID=@ID)=0 and @CouponCode IS NOT NULL)
				BEGIN

					SELECT @ErrMessage='Invalid coupon for product id '+CAST(@ProductID as VARCHAR(MAX))

					RAISERROR(@ErrMessage,11,1)
				END

				IF((select (PayableAmount-ProductAmount)+(PayableTax-ProductTax) from #Products where ID=@ID)!=0)
				BEGIN

					SELECT @ErrMessage='Amount mismatch for product id '+CAST(@ProductID as VARCHAR(MAX))

					RAISERROR(@ErrMessage,11,1)
				END

				set @ProductPos=@ProductPos+1

			end



			set @PlanPos=@PlanPos+1

		END


		--Validate Product Count Per Plan

		DECLARE @i INT=1
		DECLARE @plc INT=0

		select @plc=MAX(ID) from #Plans

		while(@i<=@plc)
		begin

			IF(
				(select COUNT(*) from #Products A
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



