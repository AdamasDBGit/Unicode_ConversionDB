CREATE PROCEDURE [ECOMMERCE].[uspGetCouponList](@CouponCategoryID INT, @BrandID INT=109)
AS
BEGIN

	select DISTINCT TCM.* from ECOMMERCE.T_Coupon_Master TCM
	inner join ECOMMERCE.T_Coupon_Category_Master TCCM on TCM.CouponCategoryID=TCCM.CouponCategoryID
	inner join ECOMMERCE.T_Coupon_Brand_Map TCBM on TCM.CouponID=TCBM.CouponID
	where
	TCM.StatusID=1 and TCM.ValidTo>=GETDATE() and TCBM.BrandID=@BrandID and TCCM.CouponCategoryID=@CouponCategoryID
	and TCM.AssignedCount<TCM.CouponCount

END
