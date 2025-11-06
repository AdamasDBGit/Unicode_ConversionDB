CREATE PROCEDURE [ECOMMERCE].[uspSaveCoupon]
(
	@CouponCode VARCHAR(MAX),
	@CouponName VARCHAR(MAX),
	@CouponDesc VARCHAR(MAX),
	@sBrandID VARCHAR(MAX),
	@DiscountID INT,
	@CouponCategoryID INT,
	@CouponTypeID INT,
	@CouponCount INT,
	@GreaterThanAmount DECIMAL(14,2)=NULL,
	@CustomerCode VARCHAR(MAX)=NULL,
	@ValidFrom DATETIME,
	@ValidTo DATETIME,
	@CampaignDiscountMapID INT=NULL,
	@PerStudentCount INT=1,
	@IsPrivate BIT='False'--susmita: 2022-09-15
)
AS
BEGIN


	Declare @CouponID INT=0
	DECLARE @flag INT=1

	BEGIN TRY

		BEGIN TRANSACTION


	if(@CouponCategoryID=1)
	BEGIN

		if exists(select * from ECOMMERCE.T_Coupon_Master where 
		CouponCode=@CouponCode and StatusID=1 and CouponCount>AssignedCount and CONVERT(DATE,ValidTo)>=CONVERT(DATE,GETDATE()) and CouponCategoryID=1)
		BEGIN

			set @flag=0

		END

	END
	ELSE IF(@CouponCategoryID=2 and ISNULL(@GreaterThanAmount,0)>0)
	BEGIN

		if exists(select * from ECOMMERCE.T_Coupon_Master where CouponCode=@CouponCode and StatusID=1 and CouponCount>AssignedCount and CONVERT(DATE,ValidTo)>=CONVERT(DATE,GETDATE()) and CouponCategoryID=2 and GreaterThanAmount=@GreaterThanAmount)
		BEGIN

			set @flag=0

		END

	END
	ELSE IF(@CouponCategoryID=3 and @CustomerCode IS NOT NULL and @CustomerCode!='')
	BEGIN

		if exists(select * from ECOMMERCE.T_Coupon_Master where CouponCode=@CouponCode and StatusID=1 and CouponCount>AssignedCount and CONVERT(DATE,ValidTo)>=CONVERT(DATE,GETDATE()) and CouponCategoryID=3 and CustomerID=@CustomerCode)
		BEGIN

			set @flag=0

		END

	END




	if (@flag=1)
	begin

		insert into ECOMMERCE.T_Coupon_Master
		(
		CouponCode,
		CouponName,
		CouponDesc,
		BrandID,
		DiscountSchemeID,
		CouponCategoryID,
		CouponType,
		CouponCount,
		AssignedCount,
		StatusID,
		ValidFrom,
		ValidTo,
		GreaterThanAmount,
		CustomerID,
		CampaignDiscountMapID,
		PerStudentCount,
		IsPrivate
		)
		select 
		@CouponCode,
		@CouponName,
		@CouponDesc,
		0,
		@DiscountID,
		@CouponCategoryID,
		@CouponTypeID,
		@CouponCount,
		0,
		1,
		@ValidFrom,
		@ValidTo,
		@GreaterThanAmount,
		@CustomerCode,
		@CampaignDiscountMapID,
		@PerStudentCount,
		@IsPrivate --susmita 2022-09-15

		set @CouponID=SCOPE_IDENTITY()

		if(@CouponID>0)
		BEGIN


			insert into ECOMMERCE.T_Coupon_Brand_Map
			select @CouponID,CAST(Val as INT),1 from fnString2Rows(@sBrandID,',')

		END

	end


	select @CouponID

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
