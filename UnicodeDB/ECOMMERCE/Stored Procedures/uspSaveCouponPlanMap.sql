CREATE PROCEDURE [ECOMMERCE].[uspSaveCouponPlanMap](@CouponID INT, @PlanID INT, @ValidFrom DATETIME=NULL, @ValidTo DATETIME=NULL)
AS
BEGIN

	IF(@ValidFrom IS NULL)
		SET @ValidFrom=GETDATE()

	IF NOT EXISTS(select * from ECOMMERCE.T_Plan_Coupon_Map where CouponID=@CouponID and PlanID=@PlanID and StatusID=1)
	BEGIN


		insert into ECOMMERCE.T_Plan_Coupon_Map
		select @PlanID,@CouponID,1,@ValidFrom,@ValidTo

	END


END
