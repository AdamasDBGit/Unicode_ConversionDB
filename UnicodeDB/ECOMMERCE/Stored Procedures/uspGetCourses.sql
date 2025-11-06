CREATE PROCEDURE [ECOMMERCE].[uspGetCourses](@BrandID INT)
AS
BEGIN

	select * from T_Course_Master A 
	where 
	A.I_Brand_ID=@BrandID and A.I_Status=1
	

END
