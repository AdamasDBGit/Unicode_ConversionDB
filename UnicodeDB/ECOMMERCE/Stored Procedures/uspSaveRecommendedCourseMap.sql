

CREATE PROCEDURE [ECOMMERCE].[uspSaveRecommendedCourseMap](@CourseID int, @RecommendedCourseIDList VARCHAR(MAX))
AS
BEGIN

	insert into ECOMMERCE.T_Recommended_Course
	select @CourseID,CAST(Val as INT),1 from fnString2Rows(@RecommendedCourseIDList,',') AS FSR


END
