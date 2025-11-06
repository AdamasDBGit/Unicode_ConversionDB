CREATE PROCEDURE [ECOMMERCE].[uspGetCoupons]
(
	@sPlanID VARCHAR(MAX)='',
	@PurchaseAmount DECIMAL(14,2)=NULL,
	@BrandID INT
)
AS
BEGIN

	Declare @PlanCount INT

	create table #Plans
	(
		ID INT IDENTITY(1,1),
		PlanID INT
	)

	create table #Coupons
	(
		ID INT IDENTITY(1,1),
		CouponID INT
	)

	IF(@sPlanID is not null and @sPlanID!='')
	BEGIN

		insert into #Plans
		select CAST(Val as INT) from fnString2Rows(@sPlanID,',')

		select @PlanCount=COUNT(*) from #Plans

	END


	insert into #Coupons
	select T1.CouponID from
	(
		select A.CouponID,COUNT(A.PlanID) as PlanIDCount from ECOMMERCE.T_Plan_Coupon_Map A
		where
		A.PlanID in
		(
			select PlanID from #Plans
		)
		group by A.CouponID
		having COUNT(A.PlanID)=@PlanCount
	) T1


	select TCM.*,TCCM.CouponCategoryDesc,TCTM.CouponTypeDesc,TDSM.S_Discount_Scheme_Name 
	from ECOMMERCE.T_Coupon_Master TCM
	inner join ECOMMERCE.T_Coupon_Category_Master TCCM on TCM.CouponCategoryID=TCCM.CouponCategoryID
	inner join ECOMMERCE.T_Coupon_Type_Master TCTM on TCM.CouponType=TCTM.CouponTypeID
	inner join T_Discount_Scheme_Master TDSM on TDSM.I_Discount_Scheme_ID=TCM.DiscountSchemeID
	where
	TCM.CouponID in
	(
		select A.CouponID from #Coupons A
	)
	and TCM.BrandID=@BrandID and TCM.StatusID=1 and TCM.AssignedCount<TCM.CouponCount 
	and (CONVERT(DATE,GETDATE())>=TCM.ValidFrom and TCM.ValidTo>=CONVERT(DATE,GETDATE()))
	and (CONVERT(DATE,GETDATE())>=TDSM.Dt_Valid_From and TDSM.Dt_Valid_To>=CONVERT(DATE,GETDATE()))



	select * from T_Discount_Scheme_Details TDSD
	where
	TDSD.I_Discount_Scheme_ID in
	(
		select TCM.DiscountSchemeID 
		from ECOMMERCE.T_Coupon_Master TCM
		inner join ECOMMERCE.T_Coupon_Category_Master TCCM on TCM.CouponCategoryID=TCCM.CouponCategoryID
		inner join ECOMMERCE.T_Coupon_Type_Master TCTM on TCM.CouponType=TCTM.CouponTypeID
		inner join T_Discount_Scheme_Master TDSM on TDSM.I_Discount_Scheme_ID=TCM.DiscountSchemeID
		where
		TCM.CouponID in
		(
			select A.CouponID from #Coupons A
		)
		and TCM.BrandID=@BrandID and TCM.StatusID=1 and TCM.AssignedCount<TCM.CouponCount
		and (CONVERT(DATE,GETDATE())>=TCM.ValidFrom and TCM.ValidTo>=CONVERT(DATE,GETDATE()))
		and (CONVERT(DATE,GETDATE())>=TDSM.Dt_Valid_From and TDSM.Dt_Valid_To>=CONVERT(DATE,GETDATE()))
	)



END
