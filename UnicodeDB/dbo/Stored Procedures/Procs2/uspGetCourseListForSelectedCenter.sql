CREATE PROCEDURE [dbo].[uspGetCourseListForSelectedCenter]
(
	@iCenterId INT,
	@iCourseFamilyID INT=NULL
)


AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT DISTINCT CCD.I_Course_ID COURSE_ID,
	   CM.S_Course_Name COURSE_NAME,
	   CM.S_Course_Code AS COURSE_CODE,
	   CM.Dt_Crtd_On--akash
	FROM dbo.T_Course_Center_Detail CCD
	INNER JOIN dbo.T_Course_Master CM
	ON CM.I_Course_ID = CCD.I_Course_ID
	WHERE CCD.I_Centre_Id = @iCenterId
	AND CM.I_CourseFamily_ID = ISNULL(@iCourseFamilyID,CM.I_CourseFamily_ID)
	AND CCD.I_Status = 1
--	AND GETDATE() >= ISNULL(CCD.Dt_Valid_From, GETDATE())
--	AND GETDATE() <= ISNULL(CCD.Dt_Valid_To, GETDATE())
--	AND CCD.I_Course_Center_ID IN
--	(	SELECT B.I_Course_Center_ID 
--		FROM dbo.T_Course_Center_Delivery_FeePlan B
--		WHERE B.I_Status = 1
--		AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
--		AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())
--	)
	ORDER BY CM.Dt_Crtd_On DESC--akash
	--CM.S_Course_Name
	
END
