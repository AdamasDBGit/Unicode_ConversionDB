CREATE PROCEDURE [dbo].[uspGetDiscountSchemeList](@iCentreID INT, @iBatchID INT, @iPaymentMode INT)
AS
BEGIN

	Declare @CourseID INT

	select @CourseID=I_Course_ID from T_Student_Batch_Master where I_Batch_ID=@iBatchID


	select DISTINCT A.* from T_Discount_Scheme_Master A
	inner join T_Discount_Scheme_Details B on A.I_Discount_Scheme_ID=B.I_Discount_Scheme_ID
	inner join T_Discount_Center_Detail C on A.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
	inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID
	where
	B.I_IsApplicableOn=@iPaymentMode and C.I_Centre_ID=@iCentreID and D.I_Course_ID=@CourseID and A.I_Status=1
	and C.I_Status=1 and D.I_Status=1


	select DISTINCT B.* from T_Discount_Scheme_Master A
	inner join T_Discount_Scheme_Details B on A.I_Discount_Scheme_ID=B.I_Discount_Scheme_ID
	inner join T_Discount_Center_Detail C on A.I_Discount_Scheme_ID=C.I_Discount_Scheme_ID
	inner join T_Discount_Course_Detail D on C.I_Discount_Center_Detail_ID=D.I_Discount_Centre_Detail_ID
	where
	B.I_IsApplicableOn=@iPaymentMode and C.I_Centre_ID=@iCentreID and D.I_Course_ID=@CourseID and A.I_Status=1
	and C.I_Status=1 and D.I_Status=1



END
