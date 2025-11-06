CREATE PROCEDURE [ECOMMERCE].[uspGetFeePlanList](@CenterID INT, @ProductID INT)
AS
BEGIN

	DECLARE @CourseID INT=0

	select @CourseID=CourseID from ECOMMERCE.T_Product_Master where ProductID=@ProductID

	select DISTINCT A.I_Course_Fee_Plan_ID,A.S_Fee_Plan_Name from T_Course_Fee_Plan A
	inner join T_Course_Center_Delivery_FeePlan B on A.I_Course_Fee_Plan_ID=B.I_Course_Fee_Plan_ID
	inner join T_Course_Center_Detail C on B.I_Course_Center_ID=C.I_Course_Center_ID
	where
	C.I_Centre_Id=@CenterID and B.I_Status=1 and C.I_Status=1 and A.I_Status=1
	and A.I_Course_ID=@CourseID

END
