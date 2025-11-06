CREATE PROCEDURE [dbo].[uspValidateCourseModification] 
(
	@iCourseID int
)
AS
BEGIN TRY

	
	SELECT COUNT(A.I_Course_Center_ID) 
	FROM dbo.T_Course_Center_Detail A
	INNER JOIN dbo.T_Centre_Master B
	ON A.I_Centre_Id = B.I_Centre_Id
	INNER JOIN dbo.T_Course_Master C
	ON A.I_Course_ID = C.I_Course_ID
	WHERE A.I_Course_ID = @iCourseID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND C.I_Status = 1	
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To,GETDATE())
	AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(B.Dt_Valid_To,GETDATE())
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
