CREATE PROCEDURE [dbo].[uspGetDiscountSchemeCenterCourseMap]
(
@DiscountSchemeID INT
)
AS
BEGIN

	select * from T_Discount_Center_Detail where I_Discount_Scheme_ID=@DiscountSchemeID and I_Status=1
	select * from T_Discount_Course_Detail where I_Discount_Centre_Detail_ID in
	(
		select A.I_Discount_Center_Detail_ID from T_Discount_Center_Detail A where A.I_Discount_Scheme_ID=@DiscountSchemeID and A.I_Status=1
	)
	and I_Status=1

END
