CREATE PROCEDURE [dbo].[uspGetActiveCourseListForSelectedCenter]
(
	@iCenterId INT,
	@iCourseFamilyID INT=NULL
)


AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @dCurrentDate  DATETIME

	SET @dCurrentDate=(CAST(SUBSTRING(CAST(GETDATE() AS VARCHAR),1,11) as datetime))
	
	SELECT DISTINCT X.I_Course_ID AS COURSE_ID,A.S_Course_Name AS COURSE_NAME,A.S_Course_Code AS COURSE_CODE
	FROM dbo.T_Course_Center_Detail X WITH(NOLOCK)  
	INNER JOIN dbo.T_Course_Center_Delivery_FeePlan Y WITH(NOLOCK)
	ON X.I_Course_Center_ID = Y.I_Course_Center_ID  
	INNER JOIN dbo.T_Course_Delivery_Map C WITH(NOLOCK)
	ON Y.I_Course_Delivery_ID = C.I_Course_Delivery_ID	
	INNER JOIN dbo.T_Delivery_Pattern_Master Z WITH(NOLOCK)
	ON Z.I_Delivery_Pattern_ID = C.I_Delivery_Pattern_ID
	INNER JOIN dbo.T_Course_Fee_Plan B WITH(NOLOCK)
	ON Y.I_Course_Fee_Plan_ID = B.I_Course_Fee_Plan_ID  
	INNER JOIN dbo.T_Course_Master A WITH(NOLOCK)
	ON X.I_Course_ID = A.I_Course_ID	
	WHERE X.I_Centre_Id = @iCenterID  
	AND A.I_CourseFamily_ID = ISNULL(@iCourseFamilyID,A.I_CourseFamily_ID)
	AND X.I_STATUS <> 0	AND Y.I_STATUS <> 0 AND C.I_STATUS <> 0 AND B.I_STATUS <> 0 AND A.I_STATUS <> 0
	AND @dCurrentDate >= ISNULL(Y.Dt_Valid_From, @dCurrentDate)  
	AND @dCurrentDate <= ISNULL(Y.Dt_Valid_To, @dCurrentDate)  
	AND @dCurrentDate >= ISNULL(X.Dt_Valid_From, @dCurrentDate)  
	AND @dCurrentDate <= ISNULL(X.Dt_Valid_To, @dCurrentDate)  
	ORDER BY A.S_Course_Name

END
