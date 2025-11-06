CREATE PROCEDURE [dbo].[uspValidateGradingPatternModification] 
(
	@iGradingPatternID int
)
AS
BEGIN TRY
	
	SELECT COUNT(A.I_Course_Center_ID)
	FROM dbo.T_Course_Center_Detail A
	INNER JOIN dbo.T_Centre_Master CM
	ON A.I_Centre_Id = CM.I_Centre_Id
	INNER JOIN dbo.T_Course_Master B
	ON A.I_Course_ID = B.I_Course_ID
	INNER JOIN dbo.T_Grading_Pattern_Master C
	ON B.I_Grading_Pattern_ID = C.I_Grading_Pattern_ID
	WHERE B.I_Grading_Pattern_ID = @iGradingPatternID
	AND A.I_Status = 1
	AND B.I_Status = 1
	AND CM.I_Status = 1
	AND C.I_Status = 1
	AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())
	AND GETDATE() >= ISNULL(CM.Dt_Valid_From, GETDATE())
	AND GETDATE() <= ISNULL(CM.Dt_Valid_To, GETDATE())
	
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
