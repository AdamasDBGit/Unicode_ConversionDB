CREATE PROCEDURE [dbo].[uspGetCourseListforCenterLevel] 
(
	-- Add the parameters for the stored procedure here
	@iCenterID int
)

AS
BEGIN

	SET NOCOUNT OFF;
	
	-- CourseObject List
	-- Table[1]
	SELECT	DISTINCT B.I_Course_ID,
			B.S_Course_Code,
			B.S_Course_Name,
			C.S_CourseFamily_Name,
			C.I_CourseFamily_ID
	FROM 
		dbo.T_Course_Center_Detail A, 
		dbo.T_Course_Master B, 
		dbo.T_CourseFamily_Master C
	WHERE A.I_Centre_ID = @iCenterID
	AND A.I_Course_ID = B.I_Course_ID
    AND B.I_CourseFamily_ID = C.I_CourseFamily_ID
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND A.I_Status <> 0 AND B.I_STATUS <>0
	AND A.I_Course_ID IN
	(
			SELECT A1.I_Course_ID 
			FROM dbo.T_Course_Center_Detail A1
			INNER JOIN dbo.T_Course_Center_Delivery_FeePlan B
			ON A1.I_Course_Center_ID = B.I_Course_Center_ID
			AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
			AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())
			AND B.I_Status = 1
			AND A1.I_Course_ID = A.I_Course_ID 
			AND A1.I_Centre_Id = @iCenterID
		)
END
