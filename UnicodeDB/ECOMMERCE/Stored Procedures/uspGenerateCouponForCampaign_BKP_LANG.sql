CREATE PROCEDURE [ECOMMERCE].[uspGenerateCouponForCampaign_BKP_LANG]
(
	@CampaignName VARCHAR(MAX),
	@MarksObtained DECIMAL(14,2),
	@CustomerID VARCHAR(MAX),
	@ValidFrom DATETIME=NULL,
	@ValidTo DATETIME=NULL
)
AS
BEGIN

	DECLARE @CampaignID INT=0
	DECLARE @DiscountID INT=0
	DECLARE @MapID INT=0
	DECLARE @CouponName VARCHAR(MAX),
			@CouponPrefix VARCHAR(MAX),
			@CouponTypeID INT,
			@CouponCount INT,
			@GenerationCount INT
	DECLARE @CouponCode VARCHAR(MAX)=''
	DECLARE @sBrandID VARCHAR(MAX)=''
	DECLARE @DiscountLumpsumPerc DECIMAL(14,2)=0
	DECLARE @DiscountInstalmentPerc DECIMAL(14,2)=0
	DECLARE @MessageDesc VARCHAR(MAX)=''
	DECLARE @MobileNo VARCHAR(MAX)=''
	DECLARE @RegID INT


	DECLARE @Coupon TABLE
	(
		CouponID INT
	)

	DECLARE @Brand TABLE
	(
		ID INT IDENTITY(1,1),
		BrandID INT
	)

	DECLARE @Plan TABLE
	(
		ID INT IDENTITY(1,1),
		PlanID INT
	)


	BEGIN TRY

		BEGIN TRANSACTION


		IF NOT EXISTS (select * from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
		BEGIN

			RAISERROR('Invalid CustomerID',11,1)

		END


		SELECT @MobileNo=MobileNo,@RegID=RegID FROM ECOMMERCE.T_Registration WHERE CustomerID=@CustomerID

		select @CampaignID=ISNULL(CampaignID,0) 
		from ECOMMERCE.T_Campaign_Master 
		where 
		StatusID=1 and CampaignName=@CampaignName and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ValidTo)>=CONVERT(DATE,GETDATE())

		IF(@CampaignID IS NULL OR @CampaignID=0)
		BEGIN

			RAISERROR('No such campaign exists',11,1)

		END


		IF(@ValidFrom IS NULL and @CampaignID>0)
		BEGIN

			select @ValidFrom=ValidFrom
			from ECOMMERCE.T_Campaign_Master 
			where CampaignID=@CampaignID

		END

		IF(@ValidTo IS NULL and @CampaignID>0)
		BEGIN

			select @ValidTo=ValidTo
			from ECOMMERCE.T_Campaign_Master 
			where CampaignID=@CampaignID

		END


		select @DiscountID=ISNULL(DiscountID,0),@MapID=ISNULL(ID,0) 
		from ECOMMERCE.T_Campaign_Discount_Map
		where
		CampaignID=@CampaignID and StatusID=1 and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ValidTo)>=CONVERT(DATE,GETDATE())
		and
		FromMarks<=@MarksObtained and ToMarks>=@MarksObtained

		--IF((@DiscountID IS NULL OR @DiscountID=0) and @MapID>0)
		--BEGIN

		--	select '' as CouponCode, 0 as LumpsumDiscount,0 as InstalmentDiscount, @MessageDesc as MessageDesc

		--END


		IF(@DiscountID>0 and @MapID>0)
		BEGIN

			DECLARE @i INT=1
			DECLARE @c INT=0


			select @DiscountLumpsumPerc=SUM(ISNULL(N_Discount_Rate,0)) from T_Discount_Scheme_Details where I_Discount_Scheme_ID=@DiscountID and I_IsApplicableOn=1
			select @DiscountInstalmentPerc=SUM(ISNULL(N_Discount_Rate,0)) from T_Discount_Scheme_Details where I_Discount_Scheme_ID=@DiscountID and I_IsApplicableOn=2


			select 
			@CouponPrefix=CouponPrefix,
			@CouponName=CouponName,
			@CouponCount=CouponCount,
			@CouponTypeID=CouponTypeID,
			@GenerationCount=ISNULL(GenerationCount,0),
			@MessageDesc=ISNULL(MessageDesc,'')
			from ECOMMERCE.T_Campaign_Discount_Map where ID=@MapID

			--select * from ECOMMERCE.T_Campaign_Discount_Map where ID=@MapID

			--select 
			--@CouponPrefix,
			--@CouponName,
			--@CouponCount,
			--@CouponTypeID,
			--@GenerationCount


			insert into @Brand
			select BrandID from ECOMMERCE.T_Campaign_Brand_Map where CampaignID=@CampaignID and StatusID=1


			select @c=COUNT(*) from @Brand

			while(@i<=@c)
			BEGIN

				set @sBrandID=@sBrandID+(select CAST(BrandID as VARCHAR(MAX)) from @Brand where ID=@i)


				set @i=@i+1

			END


			set @GenerationCount=@GenerationCount+1

			update ECOMMERCE.T_Campaign_Discount_Map set GenerationCount=@GenerationCount where ID=@MapID

			set @CouponCode=@CouponPrefix+CAST(@GenerationCount as VARCHAR(MAX))

			insert into @Coupon
			exec [ECOMMERCE].[uspSaveCoupon] @CouponCode,@CouponName,@CouponName,@sBrandID,@DiscountID,3,@CouponTypeID,@CouponCount,0,@CustomerID,@ValidFrom,@ValidTo,@MapID

			--select * from @Coupon

			IF((select COUNT(*) from @Coupon)=1)
			BEGIN

				DECLARE @CouponID INT=0

				select @CouponID=ISNULL(CouponID,0) from @Coupon

				IF (@CouponID IS NULL OR @CouponID=0)
				BEGIN

					RAISERROR('No coupon could be generated',11,1)

				END

				IF(@CouponID>0)
				BEGIN

					insert into @Plan
					select DISTINCT PlanID from
					(
						select A.I_Discount_Scheme_ID,A.I_Centre_ID,B.I_Course_ID
						from 
						T_Discount_Center_Detail A
						inner join T_Discount_Course_Detail B on A.I_Discount_Center_Detail_ID=B.I_Discount_Centre_Detail_ID
						where
						A.I_Discount_Scheme_ID=@DiscountID and A.I_Status=1 and B.I_Status=1
					) T1
					inner join
					(
						select A.PlanID,C.CourseID,D.CenterID 
						from ECOMMERCE.T_Plan_Master A
						inner join ECOMMERCE.T_Plan_Product_Map B on A.PlanID=B.PlanID and B.StatusID=1
						inner join ECOMMERCE.T_Product_Master C on B.ProductID=C.ProductID
						inner join ECOMMERCE.T_Product_Center_Map D on B.ProductID=D.ProductID
						where
						C.StatusID=1 and D.StatusID=1 and A.StatusID=1 and CONVERT(DATE,ISNULL(A.ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
						and A.IsPublished=1 and C.IsPublished=1
					) T2 on T1.I_Centre_ID=T2.CenterID and T1.I_Course_ID=T2.CourseID


					DECLARE @j INT=1
					DECLARE @cc INT=0

					select @cc=COUNT(*) from @Plan

					IF (@cc=0)
					BEGIN

						RAISERROR('No suitable Plans present',11,1)

					END
					ELSE
					BEGIN

						insert into ECOMMERCE.T_Campaign_Coupon_Details
						(
							CamapaignID,
							CampaignDiscountMapID,
							CouponID,
							CustomerID,
							MarksObtained,
							MessageDesc,
							CreatedOn,
							CreatedBy
						)
						select 
						@CampaignID,
						@MapID,
						@CouponID,
						@CustomerID,
						@MarksObtained,
						REPLACE(MessageDesc,'[mark%]',CAST(@MarksObtained as NVARCHAR(10))+'%') as MessageDesc,
						GETDATE(),
						'rice-group-admin'
						from 
						ECOMMERCE.T_Campaign_Discount_Map where ID=@MapID

					END

					WHILE(@j<=@cc)
					BEGIN
					
						DECLARE @PlanID INT

						select @PlanID=PlanID from @Plan where ID=@j

						exec [ECOMMERCE].[uspSaveCouponPlanMap] @CouponID,@PlanID,NULL,NULL

						set @j=@j+1


					END


					if(@cc>0)
					BEGIN

					IF ((SELECT SMSTypeID FROM ECOMMERCE.T_Campaign_Discount_Map WHERE ID=@MapID) IS NOT NULL)
					BEGIN

						INSERT INTO dbo.T_SMS_SEND_DETAILS
						(
						    S_MOBILE_NO,
						    I_SMS_STUDENT_ID,
						    I_SMS_TYPE_ID,
						    S_SMS_BODY,
						    I_IS_SUCCESS,
						    I_NO_OF_ATTEMPT,
						    S_RETURN_CODE_FROM_PROVIDER,
						    I_REFERENCE_ID,
						    I_REFERENCE_TYPE_ID,
						    Dt_SMS_SEND_ON,
						    I_Status,
						    S_Crtd_By,
						    S_Upd_By,
						    Dt_Crtd_On,
						    Dt_Upd_On
						)
						
						SELECT 
							@MobileNo,
							@RegID,
							A.SMSTypeID,
							REPLACE(REPLACE(B.S_SMS_BODY_TEMPLATE,'[MARK]',CAST(@MarksObtained as NVARCHAR(10))+'%'),'[CODE]',@CouponCode),
							0,
							0,
							'',
							@RegID,
							B.I_REFERENCE_TYPE_ID,
							NULL,
							1,
							'rice-group-admin',
							NULL,
							GETDATE(),
							NULL
						FROM 
						ECOMMERCE.T_Campaign_Discount_Map A
						INNER JOIN dbo.T_SMS_TYPE_MASTER B ON A.SMSTypeID=B.I_SMS_TYPE_ID AND B.I_Status=1
						WHERE A.ID=@MapID

						END


						select @CouponCode as CouponCode, @DiscountLumpsumPerc as LumpsumDiscount,@DiscountInstalmentPerc as InstalmentDiscount, @MessageDesc as MessageDesc
					END
					else
						select '' as CouponCode, @DiscountLumpsumPerc as LumpsumDiscount,@DiscountInstalmentPerc as InstalmentDiscount, @MessageDesc as MessageDesc

				END
			END


		END

		ELSE IF (@DiscountID=0 and @MapID>0)
		BEGIN

			select 
			@MessageDesc=ISNULL(MessageDesc,'')
			from ECOMMERCE.T_Campaign_Discount_Map where ID=@MapID

			select 'N/A' as CouponCode, 0 as LumpsumDiscount,0 as InstalmentDiscount, @MessageDesc as MessageDesc

		END

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
