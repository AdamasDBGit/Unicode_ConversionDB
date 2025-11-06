CREATE PROCEDURE [ECOMMERCE].[uspGetPlanCoupons]
(
	@PlanID INT
)
AS
BEGIN


	select TCM.*,TCCM.CouponCategoryDesc,TCTM.CouponTypeDesc,TDSM.S_Discount_Scheme_Name,TPCM.PlanID 
	from ECOMMERCE.T_Coupon_Master TCM
	inner join ECOMMERCE.T_Coupon_Category_Master TCCM on TCM.CouponCategoryID=TCCM.CouponCategoryID
	inner join ECOMMERCE.T_Coupon_Type_Master TCTM on TCM.CouponType=TCTM.CouponTypeID
	inner join T_Discount_Scheme_Master TDSM on TDSM.I_Discount_Scheme_ID=TCM.DiscountSchemeID
	inner join ECOMMERCE.T_Plan_Coupon_Map TPCM on TCM.CouponID=TPCM.CouponID
	where
	TCM.StatusID=1 and TCM.AssignedCount<TCM.CouponCount and TPCM.PlanID=@PlanID and TPCM.StatusID=1
	and (CONVERT(DATE,GETDATE())>=TPCM.ValidFrom and TPCM.ValidTo>=CONVERT(DATE,GETDATE()))
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
		inner join ECOMMERCE.T_Plan_Coupon_Map TPCM on TCM.CouponID=TPCM.CouponID
		where
		TCM.StatusID=1 and TCM.AssignedCount<TCM.CouponCount and TPCM.PlanID=@PlanID and TPCM.StatusID=1
		and (CONVERT(DATE,GETDATE())>=TPCM.ValidFrom and TPCM.ValidTo>=CONVERT(DATE,GETDATE()))
		and (CONVERT(DATE,GETDATE())>=TCM.ValidFrom and TCM.ValidTo>=CONVERT(DATE,GETDATE()))
		and (CONVERT(DATE,GETDATE())>=TDSM.Dt_Valid_From and TDSM.Dt_Valid_To>=CONVERT(DATE,GETDATE()))
		and (CONVERT(DATE,GETDATE())>=TDSM.Dt_Valid_From and TDSM.Dt_Valid_To>=CONVERT(DATE,GETDATE()))
	)



END
